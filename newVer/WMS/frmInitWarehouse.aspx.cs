using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using System.Text;
using ZJSIG.UIProcess.ADM;

public partial class WMS_frmInitWarehouse : PageBase
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
        script.Append(UIWmsWarehouse.getAllWarehouseListInfoStore(this));
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
            case "getInitWarehouseList":
                UIWmsInventoryOrder.getOrderList(this);
                break;
            case "getInitWarehouse":
                UIWmsInventoryOrder.getOrder(this);
                break;
            case "deleteInitWarehouse":
                UIWmsInventoryOrder.deleteOrder(this);
                break;
            case "commitInitWarehouse":
                UIWmsInventoryOrder.commitInitWarehouseOrderByOrderId(this);
                break;
        }
    }
}
