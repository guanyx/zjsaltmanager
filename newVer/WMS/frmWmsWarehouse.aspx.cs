using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using System.Text;
using ZJSIG.UIProcess.ADM;

public partial class WMS_frmWmsWarehouse :  PageBase
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
        script.Append("var dsDistributionCenterListInfo = ");
        script.Append(UIAdmDept.getDistributionCenterStore(this));

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
            case "getWarehouseList":
                UIWmsWarehouse.getAllWarehouseListContainForbit(this);
                break;
            case "getWarehouseInfo":
                UIWmsWarehouse.getWarehouse(this);
                break;
            case "saveWarehouse":
                UIWmsWarehouse.addWarehouse(this);
                break;
            case "deleteWarehouse":
                UIWmsWarehouse.deleteWarehouse(this);
                break;
        }
    }
}
