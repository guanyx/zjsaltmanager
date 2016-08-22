using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using System.Text;
using ZJSIG.UIProcess.ADM;

public partial class WMS_frmWmsClosedAccount : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //script.Append("\r\n");
        //script.Append("var dsWarehouseList = ");
        //script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        //分公司
        script.Append("\r\n");
        script.Append("var dsOrgList = ");

        script.Append(UIAdmOrg.getOrgListStore(this));

        //关帐状态
        script.Append("\r\n");
        script.Append("var dsBillTypeList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W10"));


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
            case "getCloseAccountListInfo":
                UIWmsClosedAccount.getAccountList(this);
                break;
            case "getWarehouseList":
                UIWmsWarehouse.getAllWarehouseListByOrgId(this);
                break;
            case "updateWarehouseAccount":
                UIWmsClosedAccount.updateWarehouseAccount(this);
                break;
            case "updateCloseAccountTime":
                UIWmsClosedAccount.updateWarehouseAccountTime(this);
                break;
        }
    }
}
