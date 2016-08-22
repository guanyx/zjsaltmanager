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
using ZJSIG.UIProcess.BA;
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmReturnPurchaseOrderList : PageBase
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
        script.Append("var dsReturnStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['ReturnStatusId','ReturnStatusName'],\r\n");
        script.Append("data:[['0','未退货'],['1','已退货']],\r\n");
        script.Append("autoLoad: false});\r\n");
        //单据状态
        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        script.Append("data:[['0','草稿'],['1','已确认'],['2','已出仓']],\r\n");
        script.Append("autoLoad: false});\r\n");
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        //script.Append("\r\n");
        //script.Append("var dsSuppliesListInfo = ");
        //script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        //商品规格
        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));

        //退货类型
        //script.Append("\r\n");
        //script.Append("var dsReturnTypeList = ");
        //script.Append(UISysDicsInfo.getDicsInfoStore("W09"));
        script.Append("\r\n");
        script.Append("var dsReturnTypeList = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['DicsCode','DicsName','OrderIndex'],\r\n");
        script.Append("data:[['W0204','销售退货','0'],['W0209','采购退货','1'],['W0210','生产退货','2']],\r\n");
        script.Append("autoLoad: false});");

        //单位
        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());
        //商品列表
        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "stock", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
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
            case "getWarehousePositionList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                break;
            case "getReturnOrderList":
                UIWmsReturnOrder.getOrderList(this);
                break;
            //case "deleteReturnOrder":
            //    UIWmsShiftposOrder.deleteOrder(this);
            //    break;
            case "commitShiftPosOrder":
                UIWmsShiftposOrder.commitOrder(this);
                break;
            case "getPurchaseOrderList":
                UIWmsPurchaseOrder.getOrderList(this);// getOrderList(this);
                break;
            case "getPurchaseOrderProductList":
                UIWmsPurchaseOrderDetail.getDetailList(this);
                break;
            case "saveReturnOrderInfo"://保存退货单
                UIWmsReturnOrder.saveOrder(this);
                break;
            case "deleteReturnOrder":
                UIWmsReturnOrder.deleteOrder(this);
                break;
            case "confirmReturnOrder"://采购退货单确认
                UIWmsReturnOrder.confirmOrder(this);
                break;
        }
    }
}
