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

public partial class CRM_customer_frmCrmCustomreSpeakfor : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getCustomers":
                //获取所有客户信息（接受传入条件）
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerList( this );
                break;
            case "getCfg":
                //得到所有已经配置的存货分类对应关系
                ZJSIG.UIProcess.CRM.UICrmCustomerSpeakfor.getSpeakforList( this );
                break;
            case "deleteCfgInfo":
                //循环删除已经配置的存货分类对应关系（支持多条）
                ZJSIG.UIProcess.CRM.UICrmCustomerSpeakfor.deleteSpeakfor( this );
                break;
            case "getNewNoneCfg":
                //获取还没有配置过的存货分类列表
                //ZJSIG.UIProcess.CRM.UICrmCustomerSpeakfor.getNoneCfgSpeakforList( this );
                ZJSIG.UIProcess.CRM.UICrmCustomerBuyClass.getClassList( this );
                break;
            case "saveNewCfgInfo":
                //循环添加选择的存货分类，建立配置对应关系
                ZJSIG.UIProcess.CRM.UICrmCustomerSpeakfor.saveSpeakforList( this );
                break;
        }
    }
}
