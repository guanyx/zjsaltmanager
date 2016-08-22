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

public partial class SCM_frmDrawInvCheck : PageBase
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

        //驾驶员信息
        script.Append("var dsDriver = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        //获取车辆信息
        script.Append("var dsVehicle = ");
        script.Append(UIScmVehicleAttr.getVehicleAttrStore(this));

        
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
                //可到货确认的领货单列表
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawInvCheck.getDrawList(this);
                    break;
                //到货确认单据，实收数量与订货数量一致的情况
                case "checkDrawInv":
                    ZJSIG.UIProcess.SCM.UIScmDrawInvCheck.checkDrawInv(this);                    
                    break;
                //到货确认单据，实收数量与订货数量不一致时的明细情况
                case "getDrawDtlListByDrawInvId":
                    ZJSIG.UIProcess.SCM.UIScmDrawInvCheck.getDrawDtlListByDrawInvId(this);                    
                    break;
                //到货确认单据，实收数量与订货数量不一致时的保存
                case "saveUpdate":
                    ZJSIG.UIProcess.SCM.UIScmDrawInvCheck.saveUpdate(this);
                    break;
                    
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

}
