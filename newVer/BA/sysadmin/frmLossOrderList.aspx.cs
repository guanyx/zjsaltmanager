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
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmLossOrderList : PageBase
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
        script.Append(UIWmsWarehouse.getWarehouseListInfoStoreByEmpId(this));

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));
   
        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        switch (Request.QueryString["role"])
        {
            case "leader":
                script.Append("data:[['2','领导确认'],['3','已确认']],\r\n");
                break;
            case "center":
                script.Append("data:[['1','配送中心确认'],['2','领导确认'],['3','已确认']],\r\n");
                break;
            default:
                script.Append("data:[['0','草稿'],['1','配送中心确认'],['2','领导确认'],['3','已确认']],\r\n");
                break;
        }
        script.Append("autoLoad: false});\r\n");

    
        script.Append("\r\n");
        script.Append("var dsLossTypeList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W02"));
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));



        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        switch ( this.Request.QueryString[ "billtype" ] )
        {
            case"1":
                query.Condition.Add( new Condition( "PrintType", "loss", Condition.CompareType.Equal ) );
                break;
            default:
                query.Condition.Add( new Condition( "PrintType", "rise", Condition.CompareType.Equal ) );
                break;
        }
        
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
            script.Append( "var printStyleXml = 'ckyhdprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            case "eraserLossOrder":
                UIWmsLossOrder.eraserLossOrder(this);
                break;
            case "getLossOrderList":
                UIWmsLossOrder.getOrderList(this);
                break;
        }
    }
}
