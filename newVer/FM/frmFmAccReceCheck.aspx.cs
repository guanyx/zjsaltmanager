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

public partial class FM_frmFmAccReceCheck : PageBase
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
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(this,"F01"));

        //业务种类
        script.Append("var dsBizType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("F06"));

        //借贷方向
        script.Append( "var dsFundType = new Ext.data.SimpleStore({" );
        script.Append( "fields:['DicsCode','DicsName','OrderIndex']," );
        script.Append( "data:[['F051','应收','1'],['F052','收款','2']],autoLoad: false});" );
        //script.Append("data:[['F051','借','1'],['F052','贷','2']],autoLoad: false}););");

        

        
        script.Append("</script>\r\n");
        return script.ToString();
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        string method =  Request.QueryString["method"];
        
        switch (method)
        {
            //主界面获取客户预收款列表
            case "getCustomerAccReceList":
                ZJSIG.UIProcess.SCM.UIScmSaleCheck.getPreMoneyList(this);
                break;         
            case "getCustomers":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleCustomerListForDropDownList(this);
                break;
             //弹出界面获取应收帐款已核信息
            case "getAccountYetReceDtl":
                ZJSIG.UIProcess.SCM.UIScmSaleCheck.getYetCheckOrderDtlList(this);
                break;
            //保存收款记录
            case "saveAdd":
                ZJSIG.UIProcess.FM.UIFmAccountRece.saveAdd(this);
                break;
            case "DeletePreAcc":
                ZJSIG.UIProcess.SCM.UIScmSaleCheck.deletePreMoney(this);
                break;
            case "DeleteSaleCheckDtl":
                ZJSIG.UIProcess.SCM.UIScmSaleCheck.deleteSaleCheck(this);
                break;
        }



    }
}
