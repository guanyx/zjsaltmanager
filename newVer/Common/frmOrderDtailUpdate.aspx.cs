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

public partial class Common_frmOrderDtailUpdate : PageBase
{
    public string getColModel( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        switch ( this.Request.QueryString[ "formType" ] )
        {
            case "productuse":
                script.Append( createScripts( ) );
                break;
            case "returnproductuse":
                script.Append(createReturnScripts());
                break;
            case"productprice":
                script.Append( createPriceScripts( ) );
                break;
        }
        script.Append( "var formType = '" + this.Request.QueryString[ "formType" ] + "';\r\n" );
        script.Append( "var orderIds ='" + this.Request.QueryString[ "OrderIds" ] + "';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }


    protected void Page_Load( object sender, EventArgs e )
    {
        string response = "";
        string orderIds = this.Request[ "OrderId" ];
        switch ( this.Request.QueryString[ "method" ] )
        {
            case "getorderdtllist":
                this.getOrderDtlList( );
                break;
            case "getreturnorderdtllist":
                this.getReturnOrderDtlList();
                break;
            case "save":
                UIMessageBase message = new UIMessageBase( );
                try
                {
                    switch ( this.Request[ "formType" ] )
                    {
                        case "productuse":
                            saveOrderProduct( );
                            break;
                        case "returnproductuse":
                            saveReturnOrderProduct();
                            break;
                        case"productprice":
                            saveOrderProductPrice( );
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
                    this.Response.Write( UIProcessBase.ObjectToJson( message ) );
                    this.Response.End( );
                }
                break;
            default:
                break;
        }
    }

    #region 订单价格调整

    private void getOrderDtlPriceList( )
    {
        string orderIds = this.Request[ "OrderIds" ];
        QueryConditions tempQuery = new QueryConditions( );

        tempQuery.Condition.Add( new Condition( "OrderId", orderIds, Condition.CompareType.SelectIn ) );
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

    private void saveOrderProductPrice( )
    {

        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        
        ZJSIG.UIProcess.SCM.UIScmOrderMst.changeOrderPrice( dsData, long.Parse( dsData.Tables[ 0 ].Rows[ 0 ][ "OrderId" ].ToString( ) ) );
    }

    private string createPriceScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );


        dtColumns.Rows.Add( new object[ ] { "OrderDtlId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "OrderId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "客户名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerNo", "客户编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "产品名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductId", "产品名称", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "ProductNo", "产品编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "UnitName", "单位", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleQty", "订单数量", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "TaxRate", "税率", "", "", "0" } );
        string numberValue = "new Ext.form.NumberField({allowBlank: false,align: 'right',decimalPrecision:8,listeners: { 'focus':function(){  this.selectText();}}})";
        dtColumns.Rows.Add( new object[ ] { "SalePrice", "价格", "", numberValue, "0" } );

        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );

        colModel.AppendSpaceLine( 0, "var dsProductUse = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A22" ) );
        //colModel.AppendSpaceLine( 0, "var cmbProductUse=new Ext.form.ComboBox({store: dsProductUse,displayField: 'DicsName'," +
        //    "valueField: 'DicsCode',id:'cmbProductUse',typeAhead: true, triggerAction: 'all',selectOnFocus: true,mode:'local'," +
        //    "emptyText: '',selectOnFocus: false,editable: false});" );
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
        reader.AppendLine( "url: 'frmOrderDtailUpdate.aspx?method=getorderdtllist&type=orderdtllist'," );

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

    #region 订单细项信息

    private void getOrderDtlList( )
    {
        string orderIds = this.Request[ "OrderIds" ];
        QueryConditions tempQuery = new QueryConditions( );

        tempQuery.Condition.Add( new Condition( "OrderId", orderIds, Condition.CompareType.SelectIn ) );
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

    private void getReturnOrderDtlList()
    {
        string orderIds = this.Request["OrderIds"];
        QueryConditions tempQuery = new QueryConditions();

        tempQuery.Condition.Add(new Condition("ReturnId", orderIds, Condition.CompareType.SelectIn));
        tempQuery.TableName = "VScmReturndtl";
        DataSet dsProduct = UIProcessBase.getDataSetByQuery(100, 0, tempQuery, "");
        dsProduct.Tables[0].Columns.Add("CustomerName");
        dsProduct.Tables[0].Columns.Add("CustomerNo");
        foreach (DataRow dr in dsProduct.Tables[0].Rows)
        {
            tempQuery = new QueryConditions();
            tempQuery.Condition.Add(new Condition("ReturnId", dr["ReturnId"].ToString(), Condition.CompareType.Equal));
            tempQuery.Columns = "Customer_Name,Customer_Code";
            tempQuery.TableName = "VScmReturnmst";
            DataSet dsTemp = UIProcessBase.getDataSetByQuery(1, 0, tempQuery, "");
            if (dsTemp.Tables[0].Rows.Count == 1)
            {
                dr["CustomerName"] = dsTemp.Tables[0].Rows[0][0];
                dr["CustomerNo"] = dsTemp.Tables[0].Rows[0][1];
            }
        }

        //设置数据的json格式
        string response = "{'totalProperty':'" + dsProduct.Tables[0].Rows.Count + "','root':[";
        response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson(dsProduct.Tables[0]);

        response += "]}";
        this.Response.Write(response);
        this.Response.End();
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
        dtProductUse.Columns.Add( "ProductUse" );
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

    private void saveReturnOrderProduct()
    {

        string xml = this.Request["xml"];
        xml = Server.UrlDecode(xml);
        System.IO.StringReader objReader = new System.IO.StringReader(xml);//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet();
        dsData.ReadXml(objReader);
        DataTable dtProductUse = new DataTable();
        dtProductUse.Columns.Add("ReturnDtlId", typeof(System.Int64));
        dtProductUse.Columns.Add("ProductUse");
        foreach (DataRow dr in dsData.Tables[0].Rows)
        {
            dtProductUse.Rows.Add(new object[] { dr["ReturnDtlId"], null });
        }
        dtProductUse.AcceptChanges();
        foreach (DataRow dr in dsData.Tables[0].Rows)
        {
            dtProductUse.DefaultView.RowFilter = "ReturnDtlId = " + dr["ReturnDtlId"].ToString();
            dtProductUse.DefaultView[0]["ProductUse"] = dr["ProductUse"].ToString();
        }
        dtProductUse.TableName = "ScmReturnDtl";
        dtProductUse.PrimaryKey = new DataColumn[] { dtProductUse.Columns["ReturnDtlId"] };
        DataSet ds = new DataSet();
        ds.Tables.Add(dtProductUse);
        ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet(ds);
    }


    private string createScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );
        

        dtColumns.Rows.Add( new object[ ] { "OrderDtlId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "客户名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerNo", "客户编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "产品名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductNo", "产品编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "UnitName", "单位", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleQty", "订单数量", "", "", "0" } );
        string cmbValue = "new Ext.form.ComboBox({store: dsProductUse,displayField: 'CodeName'," +
            "valueField: 'CodeId',id:'cmbProductUse',typeAhead: true, triggerAction: 'all',selectOnFocus: true,mode:'local'," +
            "emptyText: '',selectOnFocus: false,editable: false})";
        dtColumns.Rows.Add( new object[ ] { "ProductUse", "商品用途", "", cmbValue, "0" } );

        dtColumns.Columns.Add( "Renderer" );
        dtColumns.Rows[ dtColumns.Rows.Count - 1 ][ "Renderer" ] = " function(value){if(typeof(value)=='undefined'){return '';}var index = dsProductUse.findBy(function(record, id) {return record.get('CodeId')==value;});if(index==-1) return '';var record1 = dsProductUse.getAt(index); return record1.data.CodeName;}";
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );

        colModel.AppendSpaceLine( 0, "var dsProductUse = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoTreeStore(1,this.OrgID ) );
        //colModel.AppendSpaceLine( 0, "var cmbProductUse=new Ext.form.ComboBox({store: dsProductUse,displayField: 'DicsName'," +
        //    "valueField: 'DicsCode',id:'cmbProductUse',typeAhead: true, triggerAction: 'all',selectOnFocus: true,mode:'local'," +
        //    "emptyText: '',selectOnFocus: false,editable: false});" );
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
        reader.AppendLine( "url: 'frmOrderDtailUpdate.aspx?method=getorderdtllist&type=orderdtllist'," );

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
            gridColum.Renderer = drv[ "Renderer" ].ToString( );

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
    
    private string createReturnScripts()
    {
        DataTable dtColumns = new DataTable();
        dtColumns.Columns.Add("HeaderMapcolumn");
        dtColumns.Columns.Add("HeaderText");
        dtColumns.Columns.Add("ColumnType");
        dtColumns.Columns.Add("Editor");
        dtColumns.Columns.Add("Hidden");


        dtColumns.Rows.Add(new object[] { "ReturnDtlId", "标识", "", "", "1" });
        dtColumns.Rows.Add(new object[] { "CustomerName", "客户名称", "", "", "0" });
        dtColumns.Rows.Add(new object[] { "CustomerNo", "客户编号", "", "", "0" });
        dtColumns.Rows.Add(new object[] { "ProductName", "产品名称", "", "", "0" });
        dtColumns.Rows.Add(new object[] { "ProductCode", "产品编号", "", "", "0" });
        dtColumns.Rows.Add(new object[] { "UnitName", "单位", "", "", "0" });
        dtColumns.Rows.Add(new object[] { "ReturnQty", "订单数量", "", "", "0" });
        string cmbValue = "new Ext.form.ComboBox({store: dsProductUse,displayField: 'CodeName'," +
            "valueField: 'CodeId',id:'cmbProductUse',typeAhead: true, triggerAction: 'all',selectOnFocus: true,mode:'local'," +
            "emptyText: '',selectOnFocus: false,editable: false})";
        dtColumns.Rows.Add(new object[] { "ProductUse", "商品用途", "", cmbValue, "0" });

        dtColumns.Columns.Add("Renderer");
        dtColumns.Rows[dtColumns.Rows.Count - 1]["Renderer"] = " function(value){if(typeof(value)=='undefined'){return '';}var index = dsProductUse.findBy(function(record, id) {return record.get('CodeId')==value;});if(index==-1) return '';var record1 = dsProductUse.getAt(index); return record1.data.CodeName;}";
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus();
        StringPlus groupModel = new StringPlus();

        colModel.AppendSpaceLine(0, "var dsProductUse = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoTreeStore(1, this.OrgID));
        //colModel.AppendSpaceLine( 0, "var cmbProductUse=new Ext.form.ComboBox({store: dsProductUse,displayField: 'DicsName'," +
        //    "valueField: 'DicsCode',id:'cmbProductUse',typeAhead: true, triggerAction: 'all',selectOnFocus: true,mode:'local'," +
        //    "emptyText: '',selectOnFocus: false,editable: false});" );
        #region 创建GroupHeader

        groupModel.AppendSpaceLine(0, "var headerModel = new Ext.ux.plugins.GroupHeaderGrid({");
        groupModel.AppendSpaceLine(1, "rows: [");
        //groupModel.AppendSpace( 2, "[" );
        GroupHeadColumn item = new GroupHeadColumn();
        item.align = "center";
        item.Header = "单位信息";
        item.Colspan = 11;
        groupModel.AppendSpaceLine(3, "{" + ConvertString.ConvertToString(1, item) + "}");
        groupModel.AppendSpaceLine(1, "]});");

        #endregion

        #region 创建ColModel
        //创建GridStore

        StringPlus reader = new StringPlus();
        reader.AppendLine("var gridStore = new Ext.data.Store({");
        reader.AppendLine("url: 'frmOrderDtailUpdate.aspx?method=getreturnorderdtllist&type=orderdtllist',");

        reader.AppendLine(" reader :new Ext.data.JsonReader({");
        reader.AppendLine("totalProperty: 'totalProperty',");
        reader.AppendLine("root: 'root',");

        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine("fields: [");

        //需要创建的Grid显示列
        colModel.Append("var colModel = new Ext.grid.ColumnModel({\r\n");
        colModel.AppendSpaceLine(1, "columns: [");
        colModel.AppendSpaceLine(2, "new Ext.grid.RowNumberer(),");
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn();
        foreach (DataRowView drv in dvColumn)
        {
            gridColum.editor = "";
            gridColum.DataIndex = drv["HeaderMapcolumn"].ToString();
            gridColum.Header = drv["HeaderText"].ToString();

            gridColum.Id = drv["HeaderMapcolumn"].ToString();
            gridColum.Tooltip = drv["HeaderText"].ToString();
            gridColum.Sortable = true;
            gridColum.Renderer = drv["Renderer"].ToString();

            string type = "string";
            if (drv["ColumnType"].ToString() != "")
            {
                type = drv["ColumnType"].ToString();
                if (type == "date")
                {
                    gridColum.Renderer = "Ext.util.Format.dateRenderer('Y-m-d')";
                }
            }
            if (type == "string" || type == "date")
            {
                gridColum.Width = 100;
            }
            else
            {
                gridColum.Width = 60;
            }
            if (drv["Editor"].ToString() != "")
            {
                gridColum.editor = drv["Editor"].ToString();
            }
            if (drv["Hidden"].ToString() == "1")
                gridColum.Hidden = true;
            else
                gridColum.Hidden = false;
            colModel.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");

            reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", drv["HeaderMapcolumn"].ToString(), type) + "},");
        }
        colModel.DelLastChar(",");
        colModel.AppendSpaceLine(1, "]});");

        reader.DelLastChar(",");
        reader.AppendSpaceLine(1, "]})");

        reader.AppendLine(",sortData: function(f, direction) {");
        reader.AppendLine(" var tempSort = Ext.util.JSON.encode(gridStore.sortInfo);");
        reader.AppendLine(" if (sortInfor != tempSort) {");
        reader.AppendLine("     sortInfor = tempSort;");
        reader.AppendLine("     gridStore.baseParams.SortInfo = sortInfor;");
        reader.AppendLine("     gridStore.load({ params: { limit: defaultPageSize, start: 0} });");
        reader.AppendLine(" }");
        reader.AppendLine("}");


        reader.AppendLine("});");

        colModel.AppendLine(reader.ToString());
        colModel.AppendLine(groupModel.ToString());

        //colModel.AppendLine( " var reportView='" + itemReport.ReportView + "';" );
        //colModel.AppendLine( " var staticReportId='" + itemReport.ReportId.ToString( ) + "';" );
        #endregion

        return colModel.ToString();
    }
    #endregion
}
