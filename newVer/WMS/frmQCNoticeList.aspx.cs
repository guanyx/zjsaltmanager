using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.CRM;
using ZJSIG.UIProcess.QT;

public partial class WMS_frmQCNoticeList : PageBase
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
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));

        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        script.Append("data:[['0','未入仓'],['1','预入仓'],['2','已入仓']],\r\n");
        script.Append("autoLoad: false});\r\n");

        script.Append("\r\n");
        script.Append("var dsSuppliesListInfo = ");
        script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        //----------------
        //质检类型
        script.Append("\r\n");
        script.Append("var dsCheckType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("Q09"));
        //----------------

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            case "getQCNoticeList":
                UIQtQualityCheckNotify.getQCNoticeList(this);
                break;
            case "showQCNotice":
                UIQtQualityCheckNotify.showrsult(this);
                break;
        }
    }
}
