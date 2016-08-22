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

public partial class WMS_frmShiftPosOrderEdit : PageBase
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
        //script.Append(UIWmsWarehouse.getWarehouseListByUserIdStore(this));
        script.Append( UIWmsWarehouse.getWarehouseListInfoStoreByEmpId( this ) );

        //商品规格
        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));

        //驾驶员列表
        script.Append("\r\n");
        script.Append("var dsDriverList = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        script.Append("\r\n");
        script.Append("var dsProductUnitList = new Ext.data.Store({ ");
        script.Append("url: 'frmShiftPosOrderEdit.aspx?method=getProductUnits',  ");
        script.Append("params: {ProductId:0},");
        script.Append("reader: new Ext.data.JsonReader({ ");
        script.Append("root: 'root',");
        script.Append(" totalProperty: 'totalProperty',");
        script.Append(" id: 'ProductUnits' }, [   ");
        script.Append("{name: 'UnitId', mapping: 'UnitId'}, ");
        script.Append("{name: 'UnitName', mapping: 'UnitName'}");
        script.Append("])");
        script.Append("});");

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));
        //装卸公司
        script.Append("\r\n");
        script.Append("var dsLoadCompanyList = ");
        script.Append(UIWmsLoadCompany.getCompanyListStore(this));

        script.Append("\r\n var operId = " + this.EmployeeID.ToString() + ";\r\n");
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

            case "saveShiftPosOrderInfo":
                UIWmsShiftposOrder.saveOrder(this);
                break;
            case "getShiftPosOrderProductList":
                UIWmsShiftposOrderDetail.getDetailList(this);
                break;
            case "getShiftPosOrderInfo":
                UIWmsShiftposOrder.getOrder(this);
                break;
            case "commitShiftPosOrder":
                UIWmsShiftposOrder.saveAndCommitOrder(this);
                break;
            case "getProductUnits":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStore(this);
                break;
        }
    }
}
