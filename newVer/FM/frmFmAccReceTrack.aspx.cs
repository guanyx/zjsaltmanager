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
using System.Text;

public partial class FM_frmFmAccRece : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //付款类型
        script.Append("var dsPayType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("F01"));

        //借贷方向
        script.Append("var dsFundType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("F05"));

        //业务种类
        script.Append("var dsBizType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("F06"));

        
        script.Append("</script>\r\n");
        return script.ToString();
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        string method =  Request.QueryString["method"];
        
        switch (method)
        {
            //主界面获取客户列表
            case "getCustomerList":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerList(this);
                break;         
             //弹出界面获取应收帐款信息
            case "getAccountReceDtl":
                ZJSIG.UIProcess.FM.UIFmAccountRece.getAccountReceDtl(this);
                break;
            //保存收款记录
            case "saveAdd":
                ZJSIG.UIProcess.FM.UIFmAccountRece.saveAdd(this);
                break;
        }



    }
}
