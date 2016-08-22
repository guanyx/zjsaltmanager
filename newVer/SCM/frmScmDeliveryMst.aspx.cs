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
using ZJSIG.UIProcess.SCM;

public partial class SCM_frmScmDeliveryMst : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //单位
        script.Append("\r\n");
        //script.Append("var dsUnitList = ");
        //script.Append(ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore());

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
                case "getDeliveryMstList":
                    UIScmDeliveryMst.getMstList(this);
                    break;
                case "getDeliveryMst":
                    UIScmDeliveryMst.getMst(this);
                    break;
                case "deleteMst":
                    UIScmDeliveryMst.deleteMst(this);
                    break;
                case "directStockOutMst":
                    UIScmDeliveryMst.derectStockOut(this);
                    break;
                case "settleFee":
                    UIScmDeliveryMst.settleFee(this);
                    break;
                case "getDeliveryProdctList":
                    UIScmDeliveryMst.getDeliveryProdctList(this);
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
        
    }
}
