using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.ADM;
using System.Text;
using ZJSIG.UIProcess.SCM;

public partial class WMS_frmReturnOrderEdit : PageBase
{
    
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        string strId = Request.QueryString["id"];
        bool isEdit = (strId != null && strId.Trim().Length > 0) ? true : false;
        StringBuilder script = new StringBuilder();

        script.Append("<script>\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        //用户权限下的仓库。
        script.Append("\r\n");
        script.Append("var dsWarehouseListByUserId = ");
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

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



        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        script.Append("</script>\r\n");
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
            case "getWarehousePosList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                break;
            case "getWarehousePositionList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                break;
            case "getReturnOrderProductList":
                UIWmsReturnOrderDetail.getDetailList(this);
                break;
            case "getReturnOrderInfo":
                UIWmsReturnOrder.getOrder(this);
                break;

            case "saveReturnOrderInfo"://保存退货单
                UIWmsReturnOrder.updateOrder(this);
                break;
        }
    }
}
