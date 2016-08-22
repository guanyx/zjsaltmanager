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
using System.Xml.Linq;

using ZJSIG.Common.DataSearchCondition;
using ZJSIG.Common;
using ZJSIG.ADM.BLL;
using ZJSIG.UIProcess;
using ZJSIG.UIProcess.Common;
using ZJSIG.BA.BusinessLogic;
using ZJSIG.BA.BusinessEntities;

public partial class Common_frmOtherUpdate :PageBase
{
    public string getColModel( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        switch ( this.Request.QueryString[ "formType" ] )
        {
                //商品成本调整
            case "productcost":
                script.Append( createCostUpdateScripts( ) );
                break;

        }
        script.Append( "var formType = '" + this.Request.QueryString[ "formType" ] + "';\r\n" );
        script.Append( "var ids ='" + this.Request.QueryString[ "ids" ] + "';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }

    public string doFinish( )
    {
        StringBuilder script = new StringBuilder();
         switch ( this.Request.QueryString[ "formType" ] )
        {
                //商品成本调整
            case "productcost":
                script.Append("viewGrid.getTopToolbar().hide();");
                script.Append("viewGrid.setWidth(580);");
                script.Append("viewGrid.setHeight(350);");
                break;
        }                
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        QueryConditions query = new QueryConditions( );
        DataSet ds;

        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
                //获取选择的商品成本信息
            case "getcostlist":
                query.TableName = "WmsProductCost";
                query.Condition.Add( new Condition( "Id", this.Request[ "Ids" ], Condition.CompareType.SelectIn ) );
                ds = UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
                ds.Tables[ 0 ].Columns.Add( "ProductName" );
                ds.Tables[ 0 ].Columns.Add("ProductNo");
                ds.Tables[ 0 ].Columns.Add( "WhName" );
                foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                {
                    ZJSIG.BA.BusinessEntities.BusinessBaProduct itemProduct =
                        ZJSIG.BA.BusinessLogic.BLBaProduct.GetProduct( long.Parse( dr[ "ProductId" ].ToString( ) ) );
                    ZJSIG.WMS.BusinessEntities.WmsWarehouse itemWh =
                        ZJSIG.WMS.BLL.BLWmsWarehouse.GetModel( long.Parse( dr[ "WhId" ].ToString( ) ) );
                    dr[ "ProductName" ] = itemProduct.ProductName;
                    dr["ProductNo"] = itemProduct.ProductNo;
                    dr[ "WhName" ] = itemWh.WhName;
                }
                string response = "{'totalProperty':'" + ds.Tables[ 0 ].Rows.Count + "','root':[";
                response += UIProcessBase.DataTableToJson( ds.Tables[ 0 ] );
                response += "]}";
                this.Response.Write( response );
                this.Response.End( );
                break;
                //保存数据信息
            case"save":
                UIMessageBase message = new UIMessageBase( );
                try
                {
                    saveProductCost( );
                    message.success = true;
                    message.errorinfo = "数据修改成功！";
                }
                catch(Exception ep)
                {
                    message.success = false;
                    message.errorinfo = "数据修改失败！" + ep.Message;
                }
                this.Response.Write( UIProcessBase.ObjectToJson( message ) );
                this.Response.End( );
                break;
        }
    }

    #region 商品成本价格调整

    private void saveProductCost( )
    {
        string xml = this.Request[ "xml" ];
        xml = Server.UrlDecode( xml );
        System.IO.StringReader objReader = new System.IO.StringReader( xml );//, Encoding.GetEncoding( "GB2312" ) ) );
        DataSet dsData = new DataSet( );
        dsData.ReadXml( objReader );
        string ids = "";
        foreach ( DataRow dr in dsData.Tables[ 0 ].Rows )
        {
            if ( ids.Length > 0 )
                ids += ",";
            ids += dr[ "Id" ].ToString( );
        }
        QueryConditions query = new QueryConditions( );
        query.Columns = "Id,Cost_Price,Pure_Cost_Price,Spec_Cost_Price,Spec_Unit_Id";
        query.Condition.Add( new Condition( "Id", ids, Condition.CompareType.SelectIn ) );
                
        query.TableName = "WmsProductCost";
        DataSet ds = UIProcessBase.getDataSetByQuery(int.MaxValue, 0, query, "");

        query.Columns = "";
        DataSet dsHis = UIProcessBase.getDataSetByQuery(int.MaxValue, 0, query, "");

        if (ds.Tables[0].Columns.Count > 5)
        {
            ds.Tables[0].Columns.Remove(ds.Tables[0].Columns[5]);
            dsHis.Tables[0].Columns.RemoveAt(dsHis.Tables[0].Columns.Count-1);
        }
        foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
        {
            dsData.Tables[ 0 ].DefaultView.RowFilter = "Id=" + dr[ "Id" ].ToString( );
            if (dsData.Tables[0].DefaultView.Count > 0)
            {
                dr["PureCostPrice"] = dsData.Tables[0].DefaultView[0]["PureCostPrice"];
                //计算含税成本单价
                BusinessBaProduct bbp = BLBaProduct.GetProduct(long.Parse(dsData.Tables[0].DefaultView[0]["ProductId"].ToString()));
                dr["CostPrice"] = Math.Round(decimal.Parse(dr["PureCostPrice"].ToString())
                                * (1 + bbp.SalesTax.Value), 8);
                //自定义单位成本单价
                dr["SpecCostPrice"] = Math.Round(
                    BLBaProduct.getConvertUnitQty(bbp.ProductId, long.Parse(dr["SpecUnitId"].ToString())
                    , bbp.StoreUnitId, decimal.Parse(dr["PureCostPrice"].ToString())), 8);
            }
            else
            {
                dsHis.Tables[0].Rows.Remove(dsHis.Tables[0].Rows.Find(dr["Id"]));
            }
        }
        ds.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { ds.Tables[ 0 ].Columns[ "Id" ] };
        ds.Tables[ 0 ].TableName = "WmsProductCost";
        try
        {
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
            if (dsHis.Tables[0].Rows.Count > 0)
            {
                dsHis.Tables[0].TableName = "WmsProductCostHis";
                DataSet dsHisInsert = dsHis.Clone();
                foreach (DataRow drHis in dsHis.Tables[0].Rows)
                {
                    drHis["UpdateDate"] = DateTime.Now;//记录调整时间
                    dsHisInsert.Tables[0].Rows.Add(drHis.ItemArray);
                }
                ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet(dsHisInsert);
            }
        }
        catch ( Exception ep )
        {
            throw ep;
        }

    }

    
    private static string createCostUpdateScripts( )
    {
        DataTable dtColumns = new DataTable( );
        dtColumns.Columns.Add( "HeaderMapcolumn" );
        dtColumns.Columns.Add( "HeaderText" );
        dtColumns.Columns.Add( "ColumnType" );
        dtColumns.Columns.Add( "Editor" );
        dtColumns.Columns.Add( "Hidden" );

        dtColumns.Rows.Add( new object[ ] { "Id", "标识", "", "", "1" } );
        dtColumns.Rows.Add( new object[ ] { "YearMonth", "日期", "date", "", "0" } );
        dtColumns.Rows.Add( new object[]  { "WhName", "仓库", "", "", "0" });
        dtColumns.Rows.Add( new object[]  { "ProductId", "编号", "", "", "1" });
        dtColumns.Rows.Add( new object[ ] { "ProductNo", "存货编号", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "ProductName", "存货名称", "", "", "0" } );
        dtColumns.Rows.Add( new object[ ] { "PureCostPrice", "去税单价", "", "new Ext.form.NumberField({decimalPrecision:8,listeners:{'focus': function() {this.selectText();}}})", "0" } );
        
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
        reader.AppendLine( "url: 'frmOtherUpdate.aspx?method=getcostlist'," );

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
