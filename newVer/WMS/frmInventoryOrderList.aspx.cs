using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using System.Text;
using ZJSIG.UIProcess.ADM;
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmInventoryOrderList : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //仓库数据源
        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStoreByEmpId(this));

        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        script.Append("data:[['0','草稿'],['1','已提交']],\r\n");
        script.Append("autoLoad: false});\r\n");
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));
        

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "pd", Condition.CompareType.Equal ) );
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
            script.Append( "var printStyleXml = 'ckpdprint.xml';\r\n" );
            script.Append( "var printPageWidth =819;\r\n" );
            script.Append( "var printPageHeight =1158;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append( "</script>\r\n" );
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch
        {
        }

        switch (method)
        {
            case "getInventoryOrderList":
                UIWmsInventoryOrder.getOrderList(this);
                break;
            case "getInventoryOrderInfo":
                UIWmsInventoryOrder.getOrder(this);
                break;
            case "deleteInventoryOrder":
                UIWmsInventoryOrder.deleteOrder(this);
                break;
            case "commitInventoryOrder":
                UIWmsInventoryOrder.commitInventoryOrderByOrderId(this);
                break;
            case "printdate":
                DataSet ds = UIWmsInventoryOrder.getPrintData( this );
                string str = ToDataSetString( ds );
                this.Response.Write( str );
                this.Response.End( );
                break;
            case "getdetailinfo":
                UIWmsInventoryOrder.getInventoryDetailInfo( this );
                break;
        }
    }
}
