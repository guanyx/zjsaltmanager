using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using ZJSIG.UIProcess;
using ZJSIG.UIProcess.Common;
using ZJSIG.Common.DataSearchCondition;

public partial class Common_frmDayReportUp : PageBase
{
    public string getColModel( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        switch ( this.Request.QueryString[ "formType" ] )
        {
            case"saltworkreport":
                script.Append( createReportSaltWorkUpScripts( ) );
                break;
            case "dayreport":
                script.Append(createDayReportUpScripts( ));
                break;
            case"pmsreport":
                script.Append( createPmsDayReportUpScripts( ) );
                break;
                
        }
        script.Append( "var formType = '" + this.Request.QueryString[ "formType" ] + "';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string response = "";
        string createDate = this.Request[ "CreateDate" ];
        QueryConditions query = new QueryConditions( );
        DataSet ds;
        DateTime dtCurrent = DateTime.Today;
        if(createDate!=null && createDate.Length>0)
        {
            dtCurrent = DateTime.Parse(createDate);
        }
        string orderBy = "Day_Report_ID";
        switch ( this.Request.QueryString[ "method" ] )
        {
            case "getsaltworkreportlist":
                getSaltWorkReportList( createDate );
                break;
            case "getdayreportlist":
                
                query.TableName = "TempDayReport";
                query.Condition.Add( new Condition( "OrgId",OrgID ,Condition.CompareType.Equal  ) );
                if ( createDate != null && createDate.Length > 0 )
                {
                    query.Condition.Add( new Condition( "CreateDate", createDate, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
                }
                else
                {
                    query.Condition.Add( new Condition( "CreateDate", DateTime.Today.ToShortDateString( ), Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
                }
                
                if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query ) ==0 )
                {
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", 0, Condition.CompareType.Equal ) );
                    orderBy = "";
                }
                ds = UIProcessBase.getDataSetByQuery( 1000, 0, query, orderBy );
                //需要获取期初数据
                if ( orderBy == "" )
                {
                    query.Columns = "Create_Date";
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                    query.Condition.Add( new Condition( "CreateDate", dtCurrent, Condition.CompareType.LessThan, Condition.OperateType.AND, DbType.Date ) );

                    DataSet dsLast = UIProcessBase.getDataSetByQuery( 1, 0, query, "Create_Date desc" );
                    DateTime dtLast = dtCurrent.AddDays( -1 );
                    if ( dsLast.Tables[ 0 ].Rows.Count > 0 )
                    {
                        dtLast = DateTime.Parse( dsLast.Tables[ 0 ].Rows[ 0 ][ 0 ].ToString( ) );
                    }
                    //获取最近输入的数据
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                    query.Condition.Add( new Condition( "CreateDate", dtLast, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );

                    query.Columns = "Class_Name,Product_Name,End_Qty";
                    DataSet dsO = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
                    foreach ( DataRow dr in dsO.Tables[ 0 ].Rows )
                    {
                        if ( dr[ "EndQty" ].ToString( ) == "" )
                        {
                            continue;
                        }
                        ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( "ClassName = '{0}' and ProductName='{1}'", dr[ "ClassName" ], dr[ "ProductName" ] );
                        if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
                        {
                            ds.Tables[ 0 ].DefaultView[0][ "StartQty" ] = dr[ "EndQty" ];
                        }
                    }
                    ds.Tables[ 0 ].DefaultView.RowFilter = "";
                }
                response = "{'totalProperty':'" + ds.Tables[0].Rows.Count + "','root':[";
                response += UIProcessBase.DataTableToJson( ds.Tables[ 0 ] );
                response += "]}";
                this.Response.Write( response );
                this.Response.End( );
                break;   
            case"getpmslist":
                query.TableName = "TempPmsDayReport";
                query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                if ( createDate != null && createDate.Length > 0 )
                {
                    query.Condition.Add( new Condition( "CreateDate", createDate, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
                }
                else
                {
                    query.Condition.Add( new Condition( "CreateDate", DateTime.Today.ToShortDateString( ), Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
                }

                orderBy = "Pms_Report_Id";
                if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query ) == 0 )
                {
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", 0, Condition.CompareType.Equal ) );
                    orderBy = "";
                }
                ds = UIProcessBase.getDataSetByQuery( 1000, 0, query, orderBy );
                //需要获取期初数据
                if ( orderBy == "" )
                {
                    query.Columns = "Create_Date";
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                    query.Condition.Add( new Condition( "CreateDate", dtCurrent, Condition.CompareType.LessThan, Condition.OperateType.AND, DbType.Date ) );

                    DataSet dsPmsLast = UIProcessBase.getDataSetByQuery( 1, 0, query, "Create_Date desc" );
                    DateTime dtPmsLast = dtCurrent.AddDays( -1 );
                    if ( dsPmsLast.Tables[ 0 ].Rows.Count > 0 )
                    {
                        dtPmsLast = DateTime.Parse( dsPmsLast.Tables[ 0 ].Rows[ 0 ][ 0 ].ToString( ) );
                    }

                    query.Columns = "Class_Name,Product_Name,End_Qty";
                    query.Condition.Clear( );
                    query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                    query.Condition.Add( new Condition( "CreateDate", dtPmsLast, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
                    DataSet dsO = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
                    foreach ( DataRow dr in dsO.Tables[ 0 ].Rows )
                    {
                        if ( dr[ "EndQty" ].ToString( ) == "" )
                        {
                            continue;
                        }
                        ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( "ClassName = '{0}' and ProductName='{1}'", dr[ "ClassName" ], dr[ "ProductName" ] );
                        if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
                        {
                            ds.Tables[ 0 ].DefaultView[ 0 ][ "StartQty" ] = dr[ "EndQty" ];
                        }
                    }
                    ds.Tables[ 0 ].DefaultView.RowFilter = "";
                }
                response = "{'totalProperty':'" + ds.Tables[ 0 ].Rows.Count + "','root':[";
                response += UIProcessBase.DataTableToJson( ds.Tables[ 0 ] );
                response += "]}";
                this.Response.Write( response );
                this.Response.End( );
                break;
            case "savecustomer":
                UIMessageBase message = new UIMessageBase( );
                try
                {
                    switch ( this.Request[ "formType" ] )
                    {
                        case "dayreport":
                            saveDayReport( );
                            break;
                        case "pmsreport":
                            savePmsDayReport( );
                            break;
                        case"saltworkreport":
                            saveSaleWorkReport( );
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
        }
    }

    

    #region 盐种日上报信息

    private void saveDayReport( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        if ( !dsData.Tables[ 0 ].Columns.Contains( "OrgId" ) )
            dsData.Tables[ 0 ].Columns.Add( "OrgId", typeof( System.Int64 ) );
        string createDate = this.Request[ "CreateDate" ];
        DateTime dtCreate = DateTime.Today;
        if ( createDate != null && createDate.Length > 0 )
        {
            dtCreate = DateTime.Parse(createDate);
        }
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dr[ "OrgId" ] = OrgID;
            dr[ "CreateDate" ] = dtCreate;
            dr[ "DayReportId" ] = 0;
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        
            query.Condition.Add( new Condition( "CreateDate", dtCreate.ToShortDateString( ), Condition.CompareType.Equal ) );
        query.TableName = "TempDayReport";
        DataSet ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        DataRow drEdit = null;
        string filter = "ClassName = '{0}' and ProductName = '{1}'";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( filter, dr[ "ClassName" ], dr[ "ProductName" ] );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                drEdit = ds.Tables[ 0 ].DefaultView[ 0 ].Row;
            }
            else
            {
                drEdit = ds.Tables[ 0 ].NewRow( );                
                ds.Tables[ 0 ].Rows.Add( drEdit );
                drEdit[ "DayReportId" ] = -ds.Tables[ 0 ].Rows.Count;
            }
            foreach ( DataColumn dc in ds.Tables[ 0 ].Columns )
            {
                if ( dc.ColumnName == "DayReportId" )
                    continue;
                if ( !dsData.Tables[ 0 ].Columns.Contains( dc.ColumnName ) )
                    continue;
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dc.DataType.ToString( ) == "System.Decimal" )
                    {
                        if ( dr[ dc.ColumnName ].ToString( ) == "" )
                        {
                            dr[ dc.ColumnName ] = 0;
                        }
                    }
                    if ( dr[ dc.ColumnName ].ToString( ) == "" )
                    {
                        continue;
                    }
                }
                
                drEdit[ dc.ColumnName ] = dr[ dc.ColumnName ];
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "DayReportId" ] };
        ds.Tables[ 0 ].TableName = "TempDayReport";
        try
        {
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
        }
        catch(Exception ep)
        {
            throw ep;
        }

    }

    private static string setSumValue( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setSumValue(columnName)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "var store1 = viewGrid.getStore();\r\n" );
        script.Append( "var columnValue = 0;\r\n" );
        script.Append( "for(var i=0;i<6;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "columnValue=accAdd(store1.data.items[i].get(columnName),columnValue);\r\n" );
        script.Append( "}\r\n" );
        script.Append( "store1.data.items[6].set(columnName,columnValue);\r\n" );
        script.Append( "columnValue = 0 ;\r\n" );
        script.Append( "for(var i=7;i<11;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "columnValue = accAdd(store1.data.items[i].get(columnName),columnValue);\r\n" );
        script.Append( "}\r\n" );
        script.Append( "store1.data.items[11].set(columnName,columnValue);\r\n" );
        script.Append( "columnValue = 0 ;\r\n" );
        script.Append( "for(var i=12;i<17;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "columnValue = accAdd(store1.data.items[i].get(columnName),columnValue);\r\n" );
        script.Append( "}\r\n" );
        script.Append( "store1.data.items[17].set(columnName,columnValue);\r\n" );
        script.Append( "store1.data.items[18].set(columnName,accAdd(columnValue,accAdd(store1.data.items[6].get(columnName),store1.data.items[11].get(columnName))));\r\n" );
        script.Append( "}\r\n" );

        script.Append( "function setEndQty(record)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "var endQty = 0;\r\n" );
        script.Append( "if(record.data.StartQty!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.StartQty);\r\n" );
        script.Append( "if(record.data.PurchQty!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.PurchQty);\r\n" );
        script.Append( "if(record.data.SaleQty!='')\r\n" );
        script.Append( " endQty = accSub(endQty,record.data.SaleQty);\r\n" );
        script.Append( "return endQty;" );
        script.Append( "}\r\n" );

        script.Append( "function computeSumValue()\r\n" );
        script.Append( "{\r\n" );
        script.Append( "setSumValue('StartQty');\r\n" );
        script.Append( "setSumValue('PurchQty');\r\n" );
        script.Append( "setSumValue('SaleQty');\r\n" );
        script.Append( "setSumValue('OutNoSaleQty');\r\n" );
        script.Append( "setSumValue('SaleNoOutQty');\r\n" );
        script.Append("gridStore.each(function(gridStore) {\r\n");
        script.Append( "gridStore.set('EndQty',setEndQty(gridStore));\r\n});\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );

    }

    private static string createDayReportUpScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "DayReportId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CreateDate", "结存", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "OrgId", "机构", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "ClassName", "种类", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "盐种", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "StartQty", "期初", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "PurchQty", "购进", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleQty", "销售", "", "new Ext.form.NumberField({ listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "OutNoSaleQty", "已提未销", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaleNoOutQty", "已销未提", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        //dtColumns.Rows.Add( new object[ ] { "WorksSaltWorkers", "已销未提", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "EndQty", "结存", "", "new Ext.form.NumberField({listeners:{'change': function(oppt){setSumValue('EndQty');}}})", "0" } );

        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.Append( setSumValue( ) );

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
        reader.AppendLine( "url: 'frmDayReportUp.aspx?method=getdayreportlist&type=saltworks'," );

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

    #region  定点企业日报表

    private void savePmsDayReport( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        string createDate = this.Request[ "CreateDate" ];
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        if ( !dsData.Tables[ 0 ].Columns.Contains( "OrgId" ) )
            dsData.Tables[ 0 ].Columns.Add( "OrgId", typeof( System.Int64 ) );
        DateTime dtCreate = DateTime.Today;
        if ( createDate != null && createDate.Length > 0 )
        {
            dtCreate = DateTime.Parse( createDate );
        }
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dr[ "OrgId" ] = OrgID;
            dr[ "CreateDate" ] = dtCreate;
            dr[ "PmsReportId" ] = 0;
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "CreateDate", dtCreate.ToShortDateString( ), Condition.CompareType.Equal ) );
        query.TableName = "TempPmsDayReport";
        DataSet ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        DataRow drEdit = null;
        string filter = "ClassName = '{0}' and ProductName = '{1}'";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( filter, dr[ "ClassName" ], dr[ "ProductName" ] );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                drEdit = ds.Tables[ 0 ].DefaultView[ 0 ].Row;
            }
            else
            {
                drEdit = ds.Tables[ 0 ].NewRow( );
                ds.Tables[ 0 ].Rows.Add( drEdit );
                drEdit[ "PmsReportId" ] = -ds.Tables[ 0 ].Rows.Count;
            }
            foreach ( DataColumn dc in ds.Tables[ 0 ].Columns )
            {
                if ( dc.ColumnName == "PmsReportId" )
                    continue;
                if ( !dsData.Tables[ 0 ].Columns.Contains( dc.ColumnName ) )
                    continue;
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dc.DataType.ToString( ) == "System.Decimal" )
                    {
                        if ( dr[ dc.ColumnName ].ToString( ) == "" )
                        {
                            dr[ dc.ColumnName ] = 0;
                        }
                    }
                    if ( dr[ dc.ColumnName ].ToString( ) == "" )
                    {
                        continue;
                    }
                }

                drEdit[ dc.ColumnName ] = dr[ dc.ColumnName ];
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "PmsReportId" ] };
        ds.Tables[ 0 ].TableName = "TempPmsDayReport";
        try
        {
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
        }
        catch ( Exception ep )
        {
            throw ep;
        }

    }

    private static string setPmsSumValue( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setSumValue(columnName)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "var store1 = viewGrid.getStore();\r\n" );
        script.Append( "var columnValue = 0;\r\n" );
        script.Append( "for(var i=0;i<6;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "columnValue=accAdd(store1.data.items[i].get(columnName),columnValue);\r\n" );
        script.Append( "}\r\n" );
        //script.Append( "store1.data.items[6].set(columnName,columnValue);\r\n" );
        script.Append( "var columnValue1 = 0 ;\r\n" );
        script.Append( "for(var i=6;i<13;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "columnValue1 = accAdd(store1.data.items[i].get(columnName),columnValue1);\r\n" );
        script.Append( "}\r\n" );
        script.Append( "store1.data.items[13].set(columnName,columnValue1);\r\n" );
        script.Append( "store1.data.items[14].set(columnName,accAdd(columnValue1,columnValue));\r\n" );        
        script.Append( "}\r\n" );

        script.Append( "function setEndQty(record)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "var endQty = 0;\r\n" );
        script.Append( "if(record.data.StartQty!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.StartQty);\r\n" );
        //script.Append( "if(record.data.PmsQty!='')\r\n" );
        //script.Append( " endQty = accAdd(endQty,record.data.PmsQty);\r\n" );
        script.Append( "if(record.data.ToStoreQty!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.ToStoreQty);\r\n" );
        script.Append( "if(record.data.OutStoreQty!='')\r\n" );
        script.Append( " endQty = accSub(endQty,record.data.OutStoreQty);\r\n" );
        script.Append( "return endQty;" );
        script.Append( "}\r\n" );

        script.Append( "function computeSumValue()\r\n" );
        script.Append( "{\r\n" );
        script.Append( "setSumValue('StartQty');\r\n" );
        script.Append( "setSumValue('PurchQty');\r\n" );
        script.Append( "setSumValue('PmsQty');\r\n" );
        script.Append( "setSumValue('ToStoreQty');\r\n" );
        script.Append( "setSumValue('OutStoreQty');\r\n" );
        script.Append( "gridStore.each(function(gridStore) {\r\n" );
        script.Append( "gridStore.set('EndQty',setEndQty(gridStore));\r\n});\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );

    }

    private static string createPmsDayReportUpScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "PmsReportId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CreateDate", "结存", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "OrgId", "机构", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "ClassName", "种类", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "盐种", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "StartQty", "结转库存", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "PurchQty", "预报到站（港）", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "PmsQty", "生产", "", "new Ext.form.NumberField({ listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ToStoreQty", "入库", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "OutStoreQty", "成品发出", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        //dtColumns.Rows.Add( new object[ ] { "WorksSaltWorkers", "已销未提", "", "new Ext.form.NumberField({})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "EndQty", "库存", "", "new Ext.form.NumberField({})", "0" } );

        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.Append( setPmsSumValue( ) );

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
        reader.AppendLine( "url: 'frmDayReportUp.aspx?method=getpmslist&type=saltworks'," );

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

    #region 盐场放销上报

    private void getSaltWorkReportList(string createDate )
    {
        QueryConditions query = new QueryConditions( );
        query.TableName = "ScmSaltWorkReport";
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        if ( createDate != null && createDate.Length > 0 )
        {
            query.Condition.Add( new Condition( "ReportDate", createDate, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
        }
        else
        {
            query.Condition.Add( new Condition( "ReportDate", DateTime.Today.ToShortDateString( ), Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );
        }
        string orderBy = "";
        //if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query ) == 0 )
        //{
        //    query.Condition.Clear( );
        //    query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        //    orderBy = "";
        //}
        DateTime dtCurrent = DateTime.Today;
        if ( createDate != null && createDate.Length > 0 )
        {
            dtCurrent = DateTime.Parse( createDate );
        }
        DataSet ds = UIProcessBase.getDataSetByQuery( 1000, 0, query, orderBy );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
        {
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        }

        //获取盐场信息
        query = new QueryConditions( );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.Columns = "Crm_Customer.Customer_Id,Crm_Customer.Short_Name";
        query.TableName = "CrmCustomer";
        InnerTable inner = new InnerTable( "AdmSaltWorks", "CustomerId", "CustomerId" );
        query.InnerTables.Add( inner );
        DataSet dsCustomer = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
        ds.Tables[ 0 ].Columns.Add( "CustomerName" );
        foreach ( DataRow dr in dsCustomer.Tables[ 0 ].Rows )
        {
            ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( "CustomerId = {0}", dr[ "CustomerId" ] );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                ds.Tables[ 0 ].DefaultView[ 0 ][ "CustomerName" ] = dr[ "ShortName" ];
            }
            else
            {
                DataRow drNew = ds.Tables[ 0 ].NewRow( );
                drNew[ "CustomerId" ] = dr[ "CustomerId" ];
                drNew[ "CustomerName" ] = dr[ "ShortName" ];
                ds.Tables[ 0 ].Rows.Add( drNew );
            }
        }
        //需要获取期初数据
        if ( orderBy == "" )
        {
            query = new QueryConditions( );
            query.Columns = "Report_Date";
            query.TableName = "ScmSaltWorkReport";
            query.Condition.Clear( );
            query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
            query.Condition.Add( new Condition( "ReportDate", dtCurrent, Condition.CompareType.LessThan, Condition.OperateType.AND, DbType.Date ) );

            DataSet dsLast = UIProcessBase.getDataSetByQuery( 1, 0, query, "Report_Date desc" );
            DateTime dtLast = dtCurrent.AddDays( -1 );
            if ( dsLast.Tables[ 0 ].Rows.Count > 0 )
            {
                dtLast = DateTime.Parse( dsLast.Tables[ 0 ].Rows[ 0 ][ 0 ].ToString( ) );
            }
            //获取最近输入的数据
            query.Condition.Clear( );
            query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
            query.Condition.Add( new Condition( "ReportDate", dtLast, Condition.CompareType.Equal, Condition.OperateType.AND, DbType.Date ) );

            query.Columns = "Org_Id,Customer_Id,Report_Endstore,Salt_Works_Area";
            DataSet dsO = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
            foreach ( DataRow dr in dsO.Tables[ 0 ].Rows )
            {
                if ( dr[ "ReportEndstore" ].ToString( ) == "" )
                {
                    continue;
                }
                ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( "CustomerId = {0}", dr[ "CustomerId" ] );
                if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
                {
                    ds.Tables[ 0 ].DefaultView[ 0 ][ "ReportStartstore" ] = dr[ "ReportEndstore" ];
                    ds.Tables[ 0 ].DefaultView[ 0 ][ "SaltWorksArea" ] = dr[ "SaltWorksArea" ];
                }
            }
            ds.Tables[ 0 ].DefaultView.RowFilter = "";
           
        }
        
        string response = "{'totalProperty':'" + ds.Tables[ 0 ].Rows.Count + "','root':[";
        response += UIProcessBase.DataTableToJson( ds.Tables[ 0 ] );
        response += "]}";
        this.Response.Write( response );
        this.Response.End( );
    }

    private void saveSaleWorkReport( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        if ( !dsData.Tables[ 0 ].Columns.Contains( "OrgId" ) )
            dsData.Tables[ 0 ].Columns.Add( "OrgId", typeof( System.Int64 ) );
        if ( !dsData.Tables[ 0 ].Columns.Contains( "OperId" ) )
            dsData.Tables[ 0 ].Columns.Add( "OperId", typeof( System.Int64 ) );
        string createDate = this.Request[ "CreateDate" ];
        DateTime dtCreate = DateTime.Today;
        if ( createDate != null && createDate.Length > 0 )
        {
            dtCreate = DateTime.Parse( createDate );
        }
        if ( dsData.Tables[ 0 ].Columns.Contains( "CustomerName" ) )
        {
            dsData.Tables[ 0 ].Columns.Remove( "CustomerName" );
        }
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            dr[ "OrgId" ] = OrgID;
            dr[ "ReportDate" ] = dtCreate;
            dr[ "ReportId" ] = 0;
            dr[ "OperId" ] = this.EmployeeID;
        }
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );

        query.Condition.Add( new Condition( "ReportDate", dtCreate.ToShortDateString( ), Condition.CompareType.Equal ) );
        query.TableName = "ScmSaltWorkReport";
        DataSet ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        ds.Tables[ 0 ].Columns.Remove( ds.Tables[ 0 ].Columns[ ds.Tables[ 0 ].Columns.Count - 1 ] );
        if ( ds.Tables[ 0 ].Rows.Count == 0 )
            UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
        DataRow drEdit = null;
        string filter = "CustomerId = {0}";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            ds.Tables[ 0 ].DefaultView.RowFilter = string.Format( filter, dr[ "CustomerId" ] );
            if ( ds.Tables[ 0 ].DefaultView.Count > 0 )
            {
                drEdit = ds.Tables[ 0 ].DefaultView[ 0 ].Row;
            }
            else
            {
                drEdit = ds.Tables[ 0 ].NewRow( );
                ds.Tables[ 0 ].Rows.Add( drEdit );
                drEdit[ "ReportId" ] = -ds.Tables[ 0 ].Rows.Count;
            }
            foreach ( DataColumn dc in ds.Tables[ 0 ].Columns )
            {
                if ( dc.ColumnName == "ReportId" )
                    continue;
                if ( !dsData.Tables[ 0 ].Columns.Contains( dc.ColumnName ) )
                    continue;
                if ( dc.DataType.ToString( ) != "System.String" )
                {
                    if ( dc.DataType.ToString( ) == "System.Decimal" )
                    {
                        if ( dr[ dc.ColumnName ].ToString( ) == "" )
                        {
                            dr[ dc.ColumnName ] = 0;
                        }
                    }
                    if ( dr[ dc.ColumnName ].ToString( ) == "" )
                    {
                        continue;
                    }
                }

                drEdit[ dc.ColumnName ] = dr[ dc.ColumnName ];
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "ReportId" ] };
        ds.Tables[ 0 ].TableName = "ScmSaltWorkReport";
        try
        {
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
        }
        catch ( Exception ep )
        {
            throw ep;
        }

    }


    private static string setEndQty( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setEndQty(record)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "var endQty = 0;\r\n" );
        script.Append( "if(record.data.ReportStartstore!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.ReportStartstore);\r\n" );
        script.Append( "if(record.data.ReportInstore!='')\r\n" );
        script.Append( " endQty = accAdd(endQty,record.data.ReportInstore);\r\n" );
        script.Append( "if(record.data.ReportOutstore!='')\r\n" );
        script.Append( " endQty = accSub(endQty,record.data.ReportOutstore);\r\n" );
        script.Append( "return endQty;" );
        script.Append( "}\r\n" );
        return script.ToString();
    }

    private static string getSumFunction( )
    {
        StringBuilder script = new StringBuilder( );
        return "";

    }
    private static string createReportSaltWorkUpScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "ReportId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerId", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "ReportDate", "报告日期", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "OrgId", "机构", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "CustomerName", "盐场", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "SaltWorksArea", "盐场面积","", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ReportStartstore", "期初", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ReportInstore", "生产", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ReportOutstore", "放销", "", "new Ext.form.NumberField({ listeners:{'focus': function() {this.selectText();}}})", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ReportEndstore", "期末", "", "new Ext.form.NumberField({listeners:{'focus': function() {this.selectText();}}})", "0" } );
        DataView dvColumn = dtColumns.DefaultView;


        StringPlus colModel = new StringPlus( );
        StringPlus groupModel = new StringPlus( );


        #region 创建GroupHeader

        groupModel.Append( setSumValue( ) );

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
        reader.AppendLine( "url: 'frmDayReportUp.aspx?method=getsaltworkreportlist&type=saltworks'," );

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
}
