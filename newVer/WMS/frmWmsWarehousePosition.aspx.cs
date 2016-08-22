using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using System.Text;

public partial class WMS_frmWmsWarehousePosition : PageBase
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
        script.Append(UIWmsWarehouse.getAllWarehouseListInfoStore(this));

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
                UIWmsWarehousePosition.getPositionList(this);
                break;
            case "getWarehousePos":
                UIWmsWarehousePosition.getPosition(this);
                break;
            case "saveWarehousePos":
                UIWmsWarehousePosition.savePosition(this);
                break;
            case "deleteWarehousePos":
                UIWmsWarehousePosition.deletePosition(this);
                break;
        }
    }
}
