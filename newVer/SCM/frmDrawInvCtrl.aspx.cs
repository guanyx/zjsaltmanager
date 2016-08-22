using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using ZJSIG.UIProcess;
using System.Text;
using ZJSIG.UIProcess.SCM;

public partial class SCM_frmDrawInvCtrl : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //领货单类型
        script.Append("var dsDrawType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S10"));

        //获取车辆信息
        //script.Append("var dsVehicle = ");
        //script.Append(UIScmVehicleAttr.getVehicleAttrStore(this));

        //驾驶员信息
        script.Append("var dsDriver = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        //获取仓库列表
        script.Append("var dsWareHouse = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("\r\n");

        script.Append("</script>\r\n");
        return script.ToString();
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                //领货单列表
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawListForCtrl(this);
                    break;               
                //保存
                case "saveUpdate":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.saveDrawInvCtrl(this);
                    break;
                case"getCurrentStockList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getCurrentStockList(this);
                    break;
                case "getVehicle":
                    ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getDriverAttrsByDriver(this);
                    break;

            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }


}
