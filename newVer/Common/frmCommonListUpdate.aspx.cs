using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

using ZJSIG.UIProcess;
using ZJSIG.UIProcess.Common;
using ZJSIG.Common.DataSearchCondition;

public partial class Common_frmCommonListUpdate : System.Web.UI.Page
{
    public string getColModel( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        switch ( this.Request.QueryString[ "formType" ] )
        {
            case"customer":
                script.Append( createScripts( ) );
                break;
            case"customersalt":
                script.Append( createSaleScript( ) );
                break;
            case"customerother":
                script.Append( createOtherSaleScript( ) );
                break;
            case "productUse":
                script.Append( createOrderProductScripts( ) );
                break;
            case"saltworks":
                script.Append( createSaltWorksScripts( ) );
                break;
            case"sms":
                script.Append( createSmsPasswordScripts( ) );
                break;
        }
        //script.Append( createOtherSaleScript() );// this.Request[ "ReportName" ] ));
        script.Append( "var formType = '" + this.Request.QueryString[ "formType" ] + "';\r\n" );
        script.Append( "var customers ='" + this.Request.QueryString[ "CustomerIds" ] + "';\r\n" );
        //script.Append( "var schemeStore = " );
        //script.Append( UIAdmStaticReport.getSchemeStore( this ) );
        script.Append( "</script>" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string response = "";
        string customerIds = this.Request[ "CustomerIds" ];
        switch ( this.Request.QueryString[ "method" ] )
        {
            case"getsaltworks":
                if ( customerIds != null )
                {
                    if ( customerIds.Length > 0 )
                    {
                        QueryConditions query = new QueryConditions( );
                        query.TableName = "AdmSaltWorks";
                        query.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
                        query.Condition.Add(new Condition("WorksYear", DateTime.Now.Year - 5, Condition.CompareType.GreaterThanOrEqual));//查最近5年的数据，否则保存post提交的数据太长可能会被截断
                        DataSet dsSalt = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery(100, 0, query, "works_year desc ");
                        if ( dsSalt.Tables[ 0 ].Columns[ 0 ].ColumnName.IndexOf( "_" ) != -1 )
                            UIProcessBase.ConvertDataTableColumn( dsSalt.Tables[ 0 ] );
                        dsSalt.Tables[ 0 ].Columns.Add( "CustomerName" );

                        query = new QueryConditions();
                        query.TableName = "CrmCustomer";
                        query.Condition.Add(new Condition("CustomerId", customerIds, Condition.CompareType.SelectIn));
                        query.Columns = "Short_Name,Customer_Id";
                        DataSet dsCustomer = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );

                        foreach ( string str in customerIds.Split( ',' ) )
                        {
                            //判断是否有本年度的，如果没有还需要增加一行，然后显示给界面用于保存 jianggl
                            dsSalt.Tables[ 0 ].DefaultView.RowFilter = "CustomerId = " + str + " and WorksYear= " + DateTime.Now.Year;
                            dsCustomer.Tables[ 0 ].DefaultView.RowFilter = "CustomerId = " + str;
                            if ( dsSalt.Tables[ 0 ].DefaultView.Count == 0 )
                            {
                                DataRow dr = dsSalt.Tables[ 0 ].NewRow( );
                                dr["CustomerId"] = str;
                                dr["WorksYear"] = DateTime.Now.Year;
                                dr["CustomerName"] = dsCustomer.Tables[0].DefaultView[0][0];
                                dsSalt.Tables[ 0 ].Rows.InsertAt( dr, 0); //插入到最前面
                            }
                            DataRow[] drs= dsSalt.Tables[ 0 ].Select("CustomerId = " + str);                             
                            foreach(DataRow dr in drs)
                                dr["CustomerName"] = dsCustomer.Tables[0].DefaultView[0][0];
                        }
                        
                        //foreach(d
                        //设置数据的json格式
                        response = "{'totalProperty':'" + dsSalt.Tables[ 0 ].Rows.Count + "','root':[";
                        response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsSalt.Tables[ 0 ] );

                        response += "]}";
                    }
                }
                this.Response.Write( response );
                this.Response.End( );
                break;
            case"smslist":
                this.getSmsPassWordList( );
                break;
            case"getlist":                
                if(customerIds!=null)
                {
                    if(customerIds.Length>0)
                    {
                        QueryConditions query = new QueryConditions();
                        query.TableName="VTempCustomerSurvey";
                        query.Condition.Add(new Condition("CustomerId",customerIds,Condition.CompareType.SelectIn));
                        response= ZJSIG.UIProcess.UIProcessBase.getJsonListByQuery(100,0,query,"Customer_No");                        
                    }
                }
                this.Response.Write( response );
                this.Response.End( );
                break;
            case"getothersalelist":
                QueryConditions query1 = new QueryConditions( );
                query1.TableName = "TempCustomerBrandSale";
                query1.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.Equal ) );
                if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query1 ) > 0 )
                {
                    response = UIProcessBase.getJsonListByQuery( 1000, 0, query1, "Big_Class_Name" );
                }
                else
                {
                    query1.Condition[ 0 ].ColumnValue = 0;
                    DataSet dsOther = UIProcessBase.getDataSetByQuery( 1000, 0, query1, "Big_Class_Name" );
                    foreach ( DataRow dr in dsOther.Tables[ 0 ].Rows )
                    {
                        dr[ "CustomerId" ] = customerIds;
                    }
                    //设置数据的json格式
                    response = "{'totalProperty':'" + dsOther.Tables[ 0 ].Rows.Count + "','root':[";
                    response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsOther.Tables[ 0 ] );

                    response += "]}";

                }
                this.Response.Write( response );
                this.Response.End( );
                break;
            case"getsalelist":
                if ( customerIds != null )
                {
                    if ( customerIds.Length > 0 )
                    {
                        QueryConditions query = new QueryConditions( );
                        query.Columns="Customer_Id,Chinese_name Customer_Name,Customer_No";
                        query.TableName = "CrmCustomer";
                        query.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
                        DataSet dsCustomer = UIProcessBase.getDataSetByQuery( 1000, 0, query, "Customer_No" );
                        query.TableName = "TempCustomerSaltSale";
                        query.Columns = "";
                        DataSet dsSale = UIProcessBase.getDataSetByQuery( 100000, 0, query, "" );
                        //ClassId = 241
                        query = new QueryConditions( );
                        query.Condition.Add( new Condition( "ParentClassId", 241, Condition.CompareType.Equal ) );
                        int count = 0;
                        List<ZJSIG.BA.BusinessEntities.BaReportType> reportList = ZJSIG.BA.BLL.BLBaReportType.GetPageList(
                            10, 0, query, "", out count );
                        foreach ( ZJSIG.BA.BusinessEntities.BaReportType item in reportList )
                        {
                            query = new QueryConditions( );
                            query.TableName = "BaReportProduct";
                            query.Condition.Add( new Condition( "ClassId", item.ClassId, Condition.CompareType.Equal ) );
                            DataSet ds = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
                            foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                            {
                                string columnName = "Product" + dr[ "ProductId" ].ToString( );
                                dsCustomer.Tables[ 0 ].Columns.Add(columnName );
                                if ( dsSale.Tables[ 0 ].Rows.Count > 0 )
                                {
                                    foreach ( DataRow drCustomer in dsCustomer.Tables[ 0 ].Rows )
                                    {
                                        dsSale.Tables[ 0 ].DefaultView.RowFilter = "CustomerId = " + drCustomer[ "CustomerId" ].ToString( ) + " and ProductId=" + dr[ "ProductId" ].ToString( );
                                        if ( dsSale.Tables[ 0 ].DefaultView.Count > 0 )
                                        {
                                            drCustomer[ columnName ] = dsSale.Tables[ 0 ].DefaultView[ 0 ][ "SaleAmt" ];
                                        }
                                    }
                                }
                            }
                        }
                        //设置数据的json格式
                        response = "{'totalProperty':'" + dsCustomer.Tables[0].Rows.Count + "','root':[";
                            response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson(dsCustomer.Tables[0] ); 
                        
                        response += "]}";
                    }
                }
                this.Response.Write( response );
                this.Response.End( );
                break;
            case "savecustomer":
                UIMessageBase message = new UIMessageBase( );
                try
                {
                    switch ( this.Request[ "formType" ] )
                    {
                        case "customer":
                            saveCustomer( );
                            break;
                        case "customersalt":
                            saveCustomerSaltSale( );
                            break;
                        case "customerother":
                            saveCustomerOtherSale( );
                            break;
                        case "productUse":
                            saveOrderProduct( );
                            break;
                        case"saltworks":
                            saveSaltWorks( );
                            break;
                        case"sms":
                            saveSmsPassWord( );
                            break;
                    }
                    message.success = true;
                    message.errorinfo = "数据保存成功！";
                }
                catch ( Exception ep )
                {
                    message.success = false;
                    message.errorinfo = "数据保存失败：" + ep.Message;
                }
                finally
                {
                    this.Response.Write( UIProcessBase.ObjectToJson(message) );
                    this.Response.End( );
                }
                break;
            case "productUse":
                getOrderDtlList( );
                break;
        }
    }

    #region 客户非盐类销售情况

    private void saveCustomerOtherSale( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string customerId = dsData.Tables[ 0 ].Rows[0][ "CustomerId" ].ToString();

        QueryConditions query1 = new QueryConditions( );
        query1.TableName = "TempCustomerBrandSale";
        query1.Condition.Add( new Condition( "CustomerId", customerId, Condition.CompareType.Equal ) );
        DataSet oldData = UIProcessBase.getDataSetByQuery( 1000, 0, query1, "" );
        if ( oldData.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( oldData.Tables[ 0 ] );
        oldData.Tables[ 0 ].Columns.Remove( oldData.Tables[ 0 ].Columns[ oldData.Tables[ 0 ].Columns.Count - 1 ] );
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            oldData.Tables[ 0 ].DefaultView.RowFilter = "BigClassName = '" + dr[ "BigClassName" ].ToString( ) + "' and SmallClassName = '" +
                dr[ "SmallClassName" ].ToString( ) + "'";
            if ( oldData.Tables[ 0 ].DefaultView.Count == 0 )
            {
                DataRow drNew = oldData.Tables[ 0 ].NewRow( );
                drNew[ "BigClassName" ] = dr[ "BigClassName" ];
                drNew[ "SmallClassName" ] = dr[ "SmallClassName" ];
                oldData.Tables[ 0 ].Rows.Add( drNew );
            }
            foreach ( DataColumn dc in oldData.Tables[ 0 ].Columns )
            {
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dr[ dc.ColumnName ].ToString( ) != "" )
                    {
                        oldData.Tables[ 0 ].DefaultView[ 0 ][ dc.ColumnName ] = dr[ dc.ColumnName ];
                    }
                    else
                    {
                        //oldData.Tables[ 0 ].DefaultView[ 0 ][ dc.ColumnName ] = System.DBNull.Value;
                    }
                }
                else
                {
                    oldData.Tables[ 0 ].DefaultView[ 0 ][ dc.ColumnName ] = dr[ dc.ColumnName ];
                }
            }
        }

        oldData.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { oldData.Tables[ 0 ].Columns[ "CustomerId" ], oldData.Tables[ 0 ].Columns[ "SmallClassName" ] };
        oldData.Tables[ 0 ].TableName = "TempCustomerBrandSale";
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( oldData );
    }

    private string createOtherSaleScript( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "客户名称", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerNo", "客户编号", "", "", "1" } );

        dtColumns.Rows.Add( new object[ ] { "BigClassName", "大分类", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SmallClassName", "小分类", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandOneName",  "品名", "", "new Ext.form.TextField({})","0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandOneBrand", "品牌", "", "new Ext.form.TextField({})" , "0"} );
        dtColumns.Rows.Add( new object[ ] { "BrandOneSale", "销售额", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandTwoName",  "品名", "", "new Ext.form.TextField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandTwoBrand", "品牌", "", "new Ext.form.TextField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandTwoSale", "销售额", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandThreeName",  "品名", "", "new Ext.form.TextField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandThreeBrand", "品牌", "",  "new Ext.form.TextField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "BrandThreeSale", "销售额", "", "new Ext.form.NumberField({})","0" } );

        dtColumns.Rows.Add( new object[ ] { "BrandPurch", "采购渠道", "", "new Ext.form.TextField({})", "0" } );
        
        
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        //GroupHeadColumn item = new GroupHeadColumn( );
        //item.align = "center";
        //item.Header = "单位信息";
        //item.Colspan = 11;
        //groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        //foreach ( object obj in list )
        //{
        //    /*  List<GroupHeadColumn> headColumns = obj as List<GroupHeadColumn>;
        //      groupModel.AppendSpace(2,"[");
        //      groupModel.AppendSpaceLine( 3, "{ colspan:1}," );
        //      foreach ( GroupHeadColumn itemColumn in headColumns )
        //      {
        //          groupModel.AppendSpaceLine( 3, "{" );
        //          groupModel.AppendSpaceLine( 0, ConvertString.ConvertToString( 4, itemColumn ) );
        //          groupModel.AppendSpaceLine( 3, "}," );
        //      }
        //      groupModel.DelLastChar( "," );
        //      groupModel.AppendSpaceLine( 2, "]," );*/
        //}
        //groupModel.DelLastChar( "," );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=getothersalelist&type=saltsale'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";

            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if ( type == "string" || type == "date" )
            {
                gridColum.Width = 100;
            }
            else
            {
                gridColum.Width = 60;
            }
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        //colModel.AppendLine( " var reportView='" + itemReport.ReportView + "';" );
        //colModel.AppendLine( " var staticReportId='" + itemReport.ReportId.ToString( ) + "';" );
        #endregion

        return colModel.ToString( );
    }

    #endregion

    #region 客户盐类销售情况

    private void saveCustomerSaltSale( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string customerIds = "";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            if ( customerIds.Length > 0 )
            {
                customerIds += ",";
            }
            customerIds += dr[ "CustomerId" ].ToString( );
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
        query.TableName = "TempCustomerSaltSale";
        DataSet ds = UIProcessBase.getDataSetByQuery( 10000, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
        {
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        }
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        DataRow drEdit = null;
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            foreach ( DataColumn dc in dsData.Tables[ 0 ].Columns )
            {
                if ( dc.ColumnName.IndexOf( "Product" ) != -1 )
                {
                    ds.Tables[ 0 ].DefaultView.RowFilter = "CustomerId=" + dr[ "CustomerId" ].ToString( ) + " and ProductId = " + dc.ColumnName.Substring( 7 );
                    if ( ds.Tables[ 0 ].DefaultView.Count == 0 )
                    {
                        if ( dr[ dc ].ToString( ) != "" )
                        {
                            DataRow drNew = ds.Tables[ 0 ].NewRow( );
                            drNew[ "CustomerId" ] = dr[ "CustomerId" ];
                            drNew[ "ProductId" ] = dc.ColumnName.Substring( 7 );
                            drNew[ "SaleAmt" ] = dr[ dc ];
                            ds.Tables[ 0 ].Rows.Add( drNew );
                        }

                    }
                    else
                    {
                        if ( dr[ dc ].ToString( ) != "" )
                        {
                            ds.Tables[ 0 ].DefaultView[ 0 ][ "SaleAmt" ] = dr[ dc ];
                        }
                        else
                        {
                            ds.Tables[ 0 ].DefaultView[ 0 ].Delete( );
                        }
                    }
                }
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "CustomerId" ],ds.Tables[0].Columns["ProductId"] };
        ds.Tables[ 0 ].TableName = "TempCustomerSaltSale";
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
    }

    private string createSaleScript( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "客户名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerNo", "客户编号", "", "", "0" } );
        //ClassId = 241
        QueryConditions query = new QueryConditions();
        query.Condition.Add(new Condition("ParentClassId",241,Condition.CompareType.Equal));
        int count=0;
        List<ZJSIG.BA.BusinessEntities.BaReportType> reportList = ZJSIG.BA.BLL.BLBaReportType.GetPageList(
            10, 0, query, "", out count );
        foreach ( ZJSIG.BA.BusinessEntities.BaReportType item in reportList )
        {
            query = new QueryConditions( );
            query.TableName = "BaReportProduct";
            query.Condition.Add( new Condition( "ClassId", item.ClassId, Condition.CompareType.Equal ) );
            DataSet ds = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
            query = new QueryConditions( );
            query.TableName = "BaProductSmallClass";
            query.Condition.Add( new Condition( "ClassId", 0, Condition.CompareType.Equal ) );
            foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
            {
                query.Condition[0].ColumnValue = dr["ProductId"].ToString();
                dtColumns.Rows.Add( new object[ ]{"Product"+dr["ProductId"].ToString(),UIProcessBase.getDataSetByQuery(1,0,query,"").Tables[0].Rows[0]["ClassName"].ToString(),
                    "","new Ext.form.NumberField({})","0"} );
            }
        }

        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        //GroupHeadColumn item = new GroupHeadColumn( );
        //item.align = "center";
        //item.Header = "单位信息";
        //item.Colspan = 11;
        //groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        //foreach ( object obj in list )
        //{
        //    /*  List<GroupHeadColumn> headColumns = obj as List<GroupHeadColumn>;
        //      groupModel.AppendSpace(2,"[");
        //      groupModel.AppendSpaceLine( 3, "{ colspan:1}," );
        //      foreach ( GroupHeadColumn itemColumn in headColumns )
        //      {
        //          groupModel.AppendSpaceLine( 3, "{" );
        //          groupModel.AppendSpaceLine( 0, ConvertString.ConvertToString( 4, itemColumn ) );
        //          groupModel.AppendSpaceLine( 3, "}," );
        //      }
        //      groupModel.DelLastChar( "," );
        //      groupModel.AppendSpaceLine( 2, "]," );*/
        //}
        //groupModel.DelLastChar( "," );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=getsalelist&type=saltsale'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";

            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if ( type == "string" || type == "date" )
            {
                gridColum.Width = 100;
            }
            else
            {
                gridColum.Width = 60;
            }
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        //colModel.AppendLine( " var reportView='" + itemReport.ReportView + "';" );
        //colModel.AppendLine( " var staticReportId='" + itemReport.ReportId.ToString( ) + "';" );
        #endregion

        return colModel.ToString( );
    }
    #endregion

    #region 客户基本信息
    private void saveCustomer( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml);//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string customerIds = "";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            if ( customerIds.Length > 0 )
            {
                customerIds += ",";
            }
            customerIds += dr[ "CustomerId" ].ToString( );
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
        query.TableName = "TempCustomerSurvey";
        DataSet ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        DataRow drEdit = null;
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            ds.Tables[ 0 ].DefaultView.RowFilter = "CustomerId = " + dr[ "CustomerId" ].ToString( );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                drEdit = ds.Tables[ 0 ].DefaultView[ 0 ].Row;
            }
            else
            {
                drEdit = ds.Tables[ 0 ].NewRow( );
                drEdit[ "CustomerId" ] = dr[ "CustomerId" ];
                ds.Tables[ 0 ].Rows.Add( drEdit );
            }
            foreach ( DataColumn dc in ds.Tables[ 0 ].Columns )
            {
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dr[ dc.ColumnName ].ToString( ) == "" )
                    {
                        continue;
                    }
                }
                drEdit[ dc.ColumnName ] = dr[ dc.ColumnName ];
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "CustomerId" ] };
        ds.Tables[ 0 ].TableName = "TempCustomerSurvey";
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );

        //更新许可证信息
        DataTable dtCustomerL = new DataTable( );
        dtCustomerL.Columns.Add( "CustomerId", typeof( System.Int64 ) );
        dtCustomerL.Columns.Add( "LicenseNo" );
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dtCustomerL.Rows.Add( new object[ ] { dr[ "CustomerId" ], null } );
        }
        dtCustomerL.AcceptChanges( );
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dtCustomerL.DefaultView.RowFilter = "CustomerId = " + dr[ "CustomerId" ].ToString( );
            dtCustomerL.DefaultView[ 0 ][ "LicenseNo" ] = dr[ "LicenseNo" ].ToString( );
        }
        dtCustomerL.TableName = "CrmCustomer";
        dtCustomerL.PrimaryKey = new DataColumn[ ] { dtCustomerL.Columns[ "CustomerId" ] };
        DataSet dsCustomer = new DataSet( );
        dsCustomer.Tables.Add( dtCustomerL );
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsCustomer );
    }

    private static string createScripts(  )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "","1" } );
        dtColumns.Rows.Add(new object[]{"CustomerName","客户名称","","","0"});
        dtColumns.Rows.Add( new object[ ] { "CustomerNo", "客户编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "LicenseNo", "食盐许可证", "", "new Ext.form.TextField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "Address", "地址", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "LinkMan", "联系人", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "LinkTel", "联系电话", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerArea", "场地面积（平方米）", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleYearSale", "年销售额（盐类 元）", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "OtherYearSale", "年销售额（非盐类 元）", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleCanSale", "是否符合食盐零售许可条件", "", "new Ext.form.NumberField({})", "0" } );
        DataView dvColumn = dtColumns.DefaultView;

        
        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        GroupHeadColumn item = new GroupHeadColumn();
        item.align="center";
        item.Header="单位信息";
        item.Colspan=11;
        groupModel.AppendSpaceLine( 3,"{"+ ConvertString.ConvertToString( 1, item )+"}" );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=getlist&type=customer'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.editor = "";
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";
            
            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if ( type == "string" || type == "date" )
            {
                gridColum.Width = 100;
            }
            else
            {
                gridColum.Width = 60;
            }
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        //colModel.AppendLine( " var reportView='" + itemReport.ReportView + "';" );
        //colModel.AppendLine( " var staticReportId='" + itemReport.ReportId.ToString( ) + "';" );
        #endregion

        return colModel.ToString( );
    }
    #endregion

    #region 订单产品用途设置

    private void getOrderDtlList( )
    {
        string customerIds = this.Request[ "CustomerIds" ];
        QueryConditions tempQuery = new QueryConditions( );

        tempQuery.Condition.Add( new Condition( "OrderId", customerIds, Condition.CompareType.SelectIn ) );
        tempQuery.TableName = "VScmOrderView";
        DataSet dsProduct = UIProcessBase.getDataSetByQuery( 100, 0, tempQuery, "" );
        dsProduct.Tables[ 0 ].Columns.Add( "ProductUse" );
        foreach ( DataRow dr in dsProduct.Tables[ 0 ].Rows )
        {
            tempQuery = new QueryConditions( );
            tempQuery.Condition.Add( new Condition( "OrderDtlId", dr[ "OrderDtlId" ].ToString( ), Condition.CompareType.Equal ) );
            tempQuery.Columns = "Product_Use";
            tempQuery.TableName = "ScmOrderDtl";
            DataSet dsTemp = UIProcessBase.getDataSetByQuery( 1, 0, tempQuery, "" );
            if ( dsTemp.Tables[ 0 ].Rows.Count == 1 )
            {
                dr[ "ProductUse" ] = dsTemp.Tables[ 0 ].Rows[ 0 ][ 0 ];
            }
        }
        //设置数据的json格式
        string response = "{'totalProperty':'" + dsProduct.Tables[ 0 ].Rows.Count + "','root':[";
        response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsProduct.Tables[ 0 ] );

        response += "]}";
        this.Response.Write( response );
        this.Response.End( );
    }

    private void saveOrderProduct( )
    {

        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        DataTable dtProductUse = new DataTable( );
        dtProductUse.Columns.Add( "OrderDtlId", typeof( System.Int64 ) );
        dtProductUse.Columns.Add( "ProductUse");
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dtProductUse.Rows.Add( new object[ ] { dr[ "OrderDtlId" ], null } );
        }
        dtProductUse.AcceptChanges( );
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dtProductUse.DefaultView.RowFilter = "OrderDtlId = " + dr[ "OrderDtlId" ].ToString( );
            dtProductUse.DefaultView[ 0 ][ "ProductUse" ] = dr[ "ProductUse" ].ToString( );
        }
        dtProductUse.TableName = "ScmOrderDtl";
        dtProductUse.PrimaryKey = new DataColumn[ ] { dtProductUse.Columns[ "OrderDtlId" ] };
        DataSet ds = new DataSet( );
        ds.Tables.Add( dtProductUse );
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
    }

    private static string createOrderProductScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );
        dtColumns.Columns.Add( "Width" );
        dtColumns.Columns.Add( "Renderer" );

        dtColumns.Rows.Add( new object[ ] { "OrderDtlId", "标识", "", "", "1",20 } );
        dtColumns.Rows.Add( new object[ ] { "OrderNumber", "订单编号", "", "", "0",80 } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "客户名称", "", "", "0",150 } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "产品名称", "", "", "0",150 } );
        dtColumns.Rows.Add( new object[ ] { "ProductNo", "产品编号", "", "", "0" ,60} );        
        dtColumns.Rows.Add( new object[ ] { "SaleQty", "订单数量", "", "", "0",60 } );
        dtColumns.Rows.Add( new object[ ] { "UnitName", "单位", "", "", "0" ,40} );
        dtColumns.Rows.Add( new object[ ] { "ProductUse", "用途", "", "", "0" ,60} );
        dtColumns.Rows[dtColumns.Rows.Count-1]["Editor"] = "new Ext.form.ComboBox({store: dsCorpKind,displayField: 'DicsName',valueField: 'DicsCode',triggerAction: 'all',id: 'productCombo1',hideTrigger:true, editable:false,typeAhead: true," +
                        " mode: 'local',emptyText: '',selectOnFocus: false})";
        
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );

        colModel.AppendLine( "var dsCorpKind =" + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_CORPKIND ) + ";" );
        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        GroupHeadColumn item = new GroupHeadColumn( );
        item.align = "center";
        item.Header = "单位信息";
        item.Colspan = 11;
        groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        //foreach ( object obj in list )
        //{
        //    /*  List<GroupHeadColumn> headColumns = obj as List<GroupHeadColumn>;
        //      groupModel.AppendSpace(2,"[");
        //      groupModel.AppendSpaceLine( 3, "{ colspan:1}," );
        //      foreach ( GroupHeadColumn itemColumn in headColumns )
        //      {
        //          groupModel.AppendSpaceLine( 3, "{" );
        //          groupModel.AppendSpaceLine( 0, ConvertString.ConvertToString( 4, itemColumn ) );
        //          groupModel.AppendSpaceLine( 3, "}," );
        //      }
        //      groupModel.DelLastChar( "," );
        //      groupModel.AppendSpaceLine( 2, "]," );*/
        //}
        //groupModel.DelLastChar( "," );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        //获企业性质
        
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=productUse&type=productUse'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";
            gridColum.Width = int.Parse( drv[ "Width" ].ToString() );
            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
                if ( type == "combo" )
                {
                    //gridColum.editor = "new Ext.form.ComboBox({store: dsCorpKind,displayField: 'DicsName',valueField: 'DicsCode',triggerAction: 'all',id: 'productCombo1',hideTrigger:true, editable:false,typeAhead: true," +
                    //    " mode: 'local',emptyText: '',selectOnFocus: false})";
                }
            }
            //if ( type == "string" || type == "date" )
            //{
            //    gridColum.Width = 100;
            //}
            //else
            //{
            //    gridColum.Width = 60;
            //}
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
                //gridColum.Renderer = 
                StringBuilder scriptRender = new StringBuilder( );
                gridColum.Renderer = scriptRender.ToString( );
                
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        #endregion

        return colModel.ToString( );
    }
    #endregion

    #region 盐场信息设置

    private void saveSaltWorks( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string customerIds = "";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            if (customerIds.IndexOf(dr["CustomerId"].ToString()) == -1)
            {
                if (customerIds.Length > 0)
                {
                    customerIds += ",";
                }
                customerIds += dr["CustomerId"].ToString();
            }
            //check
            try{
                int worksyear = int.Parse(dr[ "WorksYear" ].ToString( ));
                if (worksyear <= 2009) throw new Exception("年份输入不对！");
            }catch
            {
                throw new Exception("年份输入不对！");
            }
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
        query.TableName = "AdmSaltWorks";
        DataSet ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        DataRow drEdit = null;
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            ds.Tables[0].DefaultView.RowFilter = "CustomerId = " + dr["CustomerId"].ToString()
                + " and WorksYear = " +dr[ "WorksYear" ].ToString( );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                drEdit = ds.Tables[ 0 ].DefaultView[ 0 ].Row;
            }
            else
            {
                drEdit = ds.Tables[ 0 ].NewRow( );
                drEdit["CustomerId"] = dr["CustomerId"];
                ds.Tables[ 0 ].Rows.Add( drEdit );
            }
            foreach ( DataColumn dc in ds.Tables[ 0 ].Columns )
            {
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dr[ dc.ColumnName ].ToString( ) == "" )
                    {
                        continue;
                    }
                }
                drEdit[ dc.ColumnName ] = dr[ dc.ColumnName ];
            }
        }
        ds.Tables[0].PrimaryKey = new DataColumn[] { ds.Tables[0].Columns["CustomerId"], ds.Tables[0].Columns["WorksYear"] };
        ds.Tables[ 0 ].TableName = "AdmSaltWorks";
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
        
    }

    private static string createSaltWorksScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "", "1" });
        dtColumns.Rows.Add( new object[ ] { "WorksYear", "年份", "", "new Ext.form.NumberField({})", "0" });
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "盐场名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "WorksArea", "盐场面积", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "WorksAllWorkers", "职工数", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "WorksSaltWorkers", "制盐职工", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "WorksMemo", "备注", "", "new Ext.form.TextField({})", "0" });
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        GroupHeadColumn item = new GroupHeadColumn( );
        item.align = "center";
        item.Header = "单位信息";
        item.Colspan = 11;
        groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=getsaltworks&type=saltworks'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.editor = "";
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";

            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if ( type == "string" || type == "date" )
            {
                gridColum.Width = 100;
            }
            else
            {
                gridColum.Width = 60;
            }
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        //colModel.AppendLine( " var reportView='" + itemReport.ReportView + "';" );
        //colModel.AppendLine( " var staticReportId='" + itemReport.ReportId.ToString( ) + "';" );
        #endregion

        return colModel.ToString( );
    }
    #endregion

    /*
    private string createColModelScript(DataView  dv,string url )
    {
        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );
        
        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );

        GroupHeadColumn item = new GroupHeadColumn( );
        item.align = "center";
        item.Header = "单位信息";
        item.Colspan = 11;
        groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel

        StringPlus reader = new StringPlus( );
        //创建GridStore
        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: '"+url+"'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";
            gridColum.Width = int.Parse( drv[ "Width" ].ToString( ) );
            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );              
            }
            if ( dv.Table.Columns.Contains( "Renderer" ) )
            {
                if ( drv[ "renderer" ].ToString( ) != "" )
                {
                    gridColum.Renderer = drv[ "renderer" ].ToString( );
                }
            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );
        reader.AppendLine( "var sortInfor='';" );
        

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        #endregion

        return colModel.ToString( );
    }
*/

    #region 客户短信订单密码

    private void getSmsPassWordList( )
    {
        string customerIds = this.Request[ "CustomerIds" ];
        QueryConditions tempQuery = new QueryConditions( );
        tempQuery.Columns = "Customer_Id,Chinese_Name,Sms_PassWord";
        tempQuery.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
        tempQuery.TableName = "CrmCustomer";
        DataSet dsProduct = UIProcessBase.getDataSetByQuery( 100, 0, tempQuery, "" );
       
        //设置数据的json格式
        string response = "{'totalProperty':'" + dsProduct.Tables[ 0 ].Rows.Count + "','root':[";
        response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsProduct.Tables[ 0 ] );

        response += "]}";
        this.Response.Write( response );
        this.Response.End( );
    }

    private void saveSmsPassWord( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string customerIds = "";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            if ( customerIds.Length > 0 )
                customerIds += ",";
            customerIds += dr[ "CustomerId" ].ToString( );
        }
        QueryConditions tempQuery = new QueryConditions( );
        tempQuery.Columns = "Customer_Id,Chinese_Name,Sms_PassWord";
        tempQuery.Condition.Add( new Condition( "CustomerId", customerIds, Condition.CompareType.SelectIn ) );
        tempQuery.TableName = "CrmCustomer";
        DataSet dsSms = UIProcessBase.getDataSetByQuery( 100, 0, tempQuery, "" );
        dsSms.Tables[ 0 ].Columns.RemoveAt( dsSms.Tables[ 0 ].Columns.Count - 1 );
        foreach ( DataRow dr in dsSms.Tables[ 0 ].Rows )
        {
            dsData.Tables[ 0 ].DefaultView.RowFilter = "CustomerId = " + dr[ "CustomerId" ].ToString( );
            dr[ "SmsPassword" ] = dsData.Tables[ 0 ].DefaultView[ 0 ][ "SmsPassword" ];
        }
        dsSms.Tables[ 0 ].TableName = "CrmCustomer";
        dsSms.Tables[0].PrimaryKey = new DataColumn[ ] { dsSms.Tables[ 0 ].Columns[ "CustomerId" ] };
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsSms );
    }

    private static string createSmsPasswordScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );
        dtColumns.Columns.Add( "Width" );
        dtColumns.Columns.Add( "Renderer" );

        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "", "1", 20 } );
        dtColumns.Rows.Add( new object[ ] { "ChineseName", "客户名称", "", "", "0", 250 } );
        dtColumns.Rows.Add( new object[ ] { "SmsPassword", "短信订单密码", "", "new Ext.form.TextField({})", "0", 150 } );

        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );

        
        #region 创建GroupHeader

        groupModel.AppendSpaceLine( 0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({" );
        groupModel.AppendSpaceLine( 1, "rows: [" );
        //groupModel.AppendSpace( 2, "[" );
        GroupHeadColumn item = new GroupHeadColumn( );
        item.align = "center";
        item.Header = "设置短信订单密码";
        item.Colspan = 11;
        groupModel.AppendSpaceLine( 3, "{" + ConvertString.ConvertToString( 1, item ) + "}" );
        //foreach ( object obj in list )
        //{
        //    /*  List<GroupHeadColumn> headColumns = obj as List<GroupHeadColumn>;
        //      groupModel.AppendSpace(2,"[");
        //      groupModel.AppendSpaceLine( 3, "{ colspan:1}," );
        //      foreach ( GroupHeadColumn itemColumn in headColumns )
        //      {
        //          groupModel.AppendSpaceLine( 3, "{" );
        //          groupModel.AppendSpaceLine( 0, ConvertString.ConvertToString( 4, itemColumn ) );
        //          groupModel.AppendSpaceLine( 3, "}," );
        //      }
        //      groupModel.DelLastChar( "," );
        //      groupModel.AppendSpaceLine( 2, "]," );*/
        //}
        //groupModel.DelLastChar( "," );
        groupModel.AppendSpaceLine( 1, "]});" );

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus( );
        //获企业性质

        reader.AppendLine( "var gridStore = new Ext.data.Store({" );
        reader.AppendLine( "url: 'frmCommonListUpdate.aspx?method=smslist&type=sms'," );

        reader.AppendLine( " reader :new Ext.data.JsonReader({" );
        reader.AppendLine( "totalProperty: 'totalProperty'," );
        reader.AppendLine( "root: 'root'," );

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine( "fields: [" );

        //需要创建的Grid显示列
        colModel.Append( "var colModel = new Ext.grid.ColumnModel({\r\n" );
        colModel.AppendSpaceLine( 1, "columns: [" );
        colModel.AppendSpaceLine( 2, "new Ext.grid.RowNumberer()," );
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn( );
        foreach ( DataRowView drv in dvColumn )
        {
            gridColum.DataIndex = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Header = drv[ "HeaderText" ].ToString( );

            gridColum.Id = drv[ "HeaderMapcolumn" ].ToString( );
            gridColum.Tooltip = drv[ "HeaderText" ].ToString( );
            gridColum.Sortable = true;
            gridColum.Renderer = "";
            gridColum.Width = int.Parse( drv[ "Width" ].ToString( ) );
            string type = "string";
            if ( drv[ "ColumnType" ].ToString( ) != "" )
            {
                type = drv[ "ColumnType" ].ToString( );
                if ( type == "date" )
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
                if ( type == "combo" )
                {
                    //gridColum.editor = "new Ext.form.ComboBox({store: dsCorpKind,displayField: 'DicsName',valueField: 'DicsCode',triggerAction: 'all',id: 'productCombo1',hideTrigger:true, editable:false,typeAhead: true," +
                    //    " mode: 'local',emptyText: '',selectOnFocus: false})";
                }
            }
            //if ( type == "string" || type == "date" )
            //{
            //    gridColum.Width = 100;
            //}
            //else
            //{
            //    gridColum.Width = 60;
            //}
            if ( drv[ "Editor" ].ToString( ) != "" )
            {
                gridColum.editor = drv[ "Editor" ].ToString( );
                //gridColum.Renderer = 
                StringBuilder scriptRender = new StringBuilder( );
                gridColum.Renderer = scriptRender.ToString( );

            }
            if ( drv[ "Hidden" ].ToString( ) == "1" )
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine( 2, "{" + gridColum.ToJsString( 0 ) + "}," );

            reader.AppendSpaceLine( 1, "{" + string.Format( "name:'{0}',type:'{1}'", drv[ "HeaderMapcolumn" ].ToString( ), type ) + "}," );
        }
        colModel.DelLastChar( "," );
        colModel.AppendSpaceLine( 1, "]});" );

        reader.DelLastChar( "," );
        reader.AppendSpaceLine( 1, "]})" );

        reader.AppendLine( ",sortData: function(f, direction) {" );
        reader.AppendLine( " var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);" );
        reader.AppendLine( " if (sortInfor != tempSort) {" );
        reader.AppendLine( "     sortInfor = tempSort;" );
        reader.AppendLine( "     gridStore.baseParams.SortInfo = sortInfor;" );
        reader.AppendLine( "     gridStore.load({ params: { limit: defaultPageSize, start: 0} });" );
        reader.AppendLine( " }" );
        reader.AppendLine( "}" );


        reader.AppendLine( "});" );

        colModel.AppendLine( reader.ToString( ) );
        colModel.AppendLine( groupModel.ToString( ) );

        #endregion

        return colModel.ToString( );
    }
    #endregion
}
