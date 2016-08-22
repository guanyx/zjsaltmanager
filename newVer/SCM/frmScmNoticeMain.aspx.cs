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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;

public partial class SCM_frmScmNoticeMain : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //发运方式  
        script.Append("var dsTransType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A40"));

        //到站信息
        script.Append("var dsDestination = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.GetAllDestinationsStore(this));

        //单位
        script.Append("\r\n");
        script.Append("var dsUnitList = ");
        script.Append(ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore());

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
            switch ( method )
            {
                case "getnoticelist":
                    ZJSIG.UIProcess.SCM.UIScmNoticeMst.getNoticeMstDtlList( this );
                    break;
                case "saveNotice":
                    ZJSIG.UIProcess.SCM.UIScmNoticeMst.saveNoticePrice(this);
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
        
    }

}
