using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.CRM;
using ZJSIG.UIProcess.SCM;
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmAllotOutOrderList : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));

        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        script.Append("data:[['0','未出仓'],['1','已出仓']],\r\n");
        script.Append("autoLoad: false});\r\n");

        //驾驶员列表
        script.Append("\r\n");
        script.Append("var dsDriverList = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        //组织
        script.Append("\r\n");
        script.Append("var dsOrgList = ");
        //this.Request.Form.Add("OrgId","1");
        script.Append(UIAdmOrg.getOrgListStore(this));

        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        //调拨打印信息

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "dbd", Condition.CompareType.Equal ) );
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
            script.Append( "var printStyleXml = 'ckdbdprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "stock", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printOutStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printOutPageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printOutPageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printOutOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printOutOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printOutStyleXml = 'jsstockprint.xml';\r\n" );
            script.Append( "var printOutPageWidth =931;\r\n" );
            script.Append( "var printOutPageHeight =365;\r\n" );
            script.Append( "var printOutOnlyData = false;\r\n" );
        }

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            case "getAllotOutOrderList":
                UIWmsAllotOrder.getOrderList(this);
                break;
            case "deleteAllotOrder":
                UIWmsAllotOrder.deleteOrder(this);
                break;
            case "printdate":
                System.Data.DataSet ds = UIWmsAllotOrder.getPrintData( this );
                //ds.WriteXml( @"C:\zjsalt\WebSite\ZJSIGSite\xml\data.xml", XmlWriteMode.WriteSchema );
                ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
                ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 1] );

                string strOut = ToDataSetString( ds );
                this.Response.Write( strOut );
                this.Response.End( );
                break;
            case "outprintdate":
                System.Data.DataSet dsOut = UIWmsAllotOrder.getOutStorePrintData( this );
                //ds.WriteXml( @"C:\zjsalt\WebSite\ZJSIGSite\xml\data.xml", XmlWriteMode.WriteSchema );
                //ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
                //ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 1 ] );

                string str = ToDataSetString( dsOut );
                this.Response.Write( str );
                this.Response.End( );
                break;
            case "getdetailinfo":
                UIWmsAllotOrder.getAlotDetailInfo( this );
                break;
            case "eraserOrder":
                UIWmsAllotOrder.eraserOrder(this);
                break;
        }
    }
}
