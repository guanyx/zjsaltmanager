using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmWmsRateList : PageBase
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //费用类型
        script.Append("var RateTypeStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("W11"));

        //单据状态
        script.Append("var RateStatusStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("W12"));

        script.Append("var RateCompanyStore=");
        script.Append( ZJSIG.UIProcess.WMS.UIWmsLoadCompany.getAllCompanyListStore( this ) );
        script.AppendLine( );
        script.Append( "var dsWarehouseList = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );
        script.AppendLine( );
        script.Append( "var dsBillTypeList = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "W02" ) );
        script.AppendLine( );
        string detailId = this.Request.QueryString["detailId"];
        if (detailId == null || detailId == "")
            detailId = "-1";
        script.Append("var detailId = " + detailId + ";\r\n");
        ZJSIG.Common.DataSearchCondition.QueryConditions query;
        if ( long.Parse(detailId) > 0 )
        {
            query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
            query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "OrderDetailId", detailId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
            query.TableName = "VWmsStockInoutDetail";
            System.Data.DataSet ds1 = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
            script.AppendLine( "var fromBillType = '" + ds1.Tables[ 0 ].Rows[ 0 ][ "FromBillType" ].ToString( ) + "';" );
            script.AppendLine( "var whId = '" + ds1.Tables[ 0 ].Rows[ 0 ][ "whId" ].ToString( ) + "';" );
            //script.AppendLine( "var whId = '" + ds.Tables[ 0 ].Rows[ 0 ][ "whId" ].ToString( ) + "';" );            
        }
        else
        {
            script.AppendLine( "var fromBillType='';" );
            script.AppendLine( "var whId='';" );
        }

        script.Append("\r\n");

        script.Append(setToolBarVisible());

        query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "otherrate", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printPageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printPageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printStyleXml = 'jxotherrateprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }
        script.Append("</script>\r\n");
        return script.ToString();
    }

    private string setToolBarVisible()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function setToolBarVisible(toolBar)\r\n");
        script.Append("{\r\n");
        switch (Action)
        {
            default:
                script.Append("for(var i=0;i<toolBar.items.items.length;i++)\r\n");
                script.Append("{\r\n");
                script.Append("switch(toolBar.items.items[i].text)\r\n");
                script.Append("{\r\n");
                script.Append("case'新增':\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("break;\r\n");
		script.Append("case'结算':\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("break;\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                break;
            case"add":
                script.Append("for(var i=0;i<toolBar.items.items.length;i++)\r\n");
                script.Append("{\r\n");
                script.Append("switch(toolBar.items.items[i].text)\r\n");
                script.Append("{\r\n");
                script.Append("case'结算':\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("break;\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                break;
            case"pay":
                script.Append("for(var i=0;i<toolBar.items.items.length;i++)\r\n");
                script.Append("{\r\n");
                script.Append("switch(toolBar.items.items[i].text)\r\n");
                script.Append("{\r\n");
                script.Append("case'新增':\r\n");
                script.Append("case'编辑':\r\n");
                script.Append("case'删除':\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("toolBar.items.items[i].setVisible(false);\r\n");
                script.Append("toolBar.items.removeAt(i);\r\n");
                script.Append("break;\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                script.Append("}\r\n");
                break;
        }
        return script.ToString();

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch (Exception ex)
        {
        }
        switch (method)
        {
            //获取角色列表信息
            case "getratelist":
                ZJSIG.UIProcess.WMS.UIWmsRate.getRateList(this);
                break;
            //新增角色信息
            case "addrate":
                ZJSIG.UIProcess.WMS.UIWmsRate.addRate(this);
                break;
            //获取角色信息
            case "getrate":
                ZJSIG.UIProcess.WMS.UIWmsRate.getRate(this);
                break;
            //删除角色信息
            case "deleterate":
                ZJSIG.UIProcess.WMS.UIWmsRate.deleteRate(this);
                break;
            //编辑角色信息
            case "editrate":
                ZJSIG.UIProcess.WMS.UIWmsRate.editRate(this);
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore(this, "VWmsRate");
                break;
            case "getgraphvalue":
                ZJSIG.UIProcess.ADM.UIAdmStaticScheme.getStaticGraphValue( this );
                break;
            case"gettype":
                string detailId = this.Request[ "DetailId" ];
                ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
                query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "OrderDetailId", detailId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                query.TableName = "VWmsStockInoutDetail";
                System.Data.DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                //ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
                string json = ZJSIG.UIProcess.UIProcessBase.DataTableToJson( ds.Tables[ 0 ], "WhId,FromBillType" );
                this.Response.Write( json );
                this.Response.End( );
                break;
            case "settlerate":
                ZJSIG.UIProcess.WMS.UIWmsRate.settleWmsRate(this);
                break;
            case "printdate":
                QueryConditions queryPrint = new QueryConditions( );
                queryPrint.Condition.Add( new Condition( "RateId", this.Request[ "RateId" ], Condition.CompareType.SelectIn ) );
                queryPrint.TableName = "VWmsRate";
                DataSet dsPrint = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 100, 0, queryPrint, "" );
               
                dsPrint.Tables[ 0 ].Columns.Add( "PJName" );
                dsPrint.Tables[ 0 ].Columns.Add( "OrderNumber" );
                dsPrint.Tables[ 0 ].Columns.Add( "RateBusiness" );
                QueryConditions q2 = new QueryConditions( );
                q2.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
                q2.TableName = "AdmOrg";
                DataSet dsOrg = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, q2, "" );
                DataColumn dc = new DataColumn( "OrgName" );
                dc.DefaultValue = dsOrg.Tables[ 0 ].Rows[ 0 ][ "OrgName" ].ToString( );
                dsPrint.Tables[ 0 ].Columns.Add( dc );
                foreach ( DataRow dr in dsPrint.Tables[ 0 ].Rows )
                {
                    dr[ "OrderNumber" ] = dr[ "RateId" ].ToString( );
                    dr[ "PjName" ] = dr[ "OrgName" ] + dr[ "RateTypeName" ].ToString( ) + "单";
                    dr[ "RateBusiness" ] = dr[ "BusinessType" ].ToString( ) + dr[ "RateTypeName" ].ToString( ) ;
                }
                DataTable dt = dsPrint.Tables[ 0 ].Copy( );
                dt.TableName = "detail";
                dsPrint.Tables.Add( dt );
                string str = ToDataSetString( dsPrint );
                this.Response.Write( str );
                this.Response.End( );
                break;
        }
    }
}
