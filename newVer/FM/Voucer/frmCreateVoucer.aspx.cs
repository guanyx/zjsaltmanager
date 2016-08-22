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

public partial class FM_Voucer_frmCreateVoucer : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取部门列表
        //script.Append("var dsDept = ");
        //script.Append(ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore(ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)));

        //获取仓库列表
        script.Append("var dsWareHouse = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {

            method = Request.QueryString["method"];
            switch ( method )
            {
                case "buildePZ":
                    ZJSIG.UIProcess.FM.XMLSendHelper.BuildPZ(this);
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
        
    }
}
