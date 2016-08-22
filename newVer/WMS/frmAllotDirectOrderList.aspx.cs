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
using ZJSIG.UIProcess.SCM;

public partial class WMS_frmAllotDirectOrderList : PageBase
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
        script.Append("data:[['0','未出仓'],['1','已出仓']],\r\n");
        script.Append("autoLoad: false});\r\n");

        //驾驶员列表
        script.Append("\r\n");
        script.Append("var dsDriverList = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        //组织
        script.Append("\r\n");
        script.Append("var dsOrgList = ");
        //this.Request.Form.Add("OrgId","1");
        script.Append(UIAdmOrg.getOrgListStore(this));

        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            case "getAllotDirectOrderList":
                UIWmsAllotOrder.getOrderList(this);
                break;
            case "deleteAllotDirectOrder":
                UIWmsAllotOrder.deleteOrder(this);
                break;
        }
    }
}
