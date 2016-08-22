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

public partial class SCM_frmScmDeliveryDtl : PageBase
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
        script.Append("var dsUnitList = ");
        script.Append(ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore());

        //获取仓库列表
        script.Append("var dsWareHouseList = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("var dsWarehousePosList = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehousePosition.getPositionSimpleStore(this));

        //驾驶员信息
        script.Append("var dsDriver = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getDeliveryDtlList":
                    ZJSIG.UIProcess.SCM.UIScmDeliveryDtl.getDeliveryDtlList(this);
                    break;
                case "deleteDtl":
                    
                    break;
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDeliveryDtl.getDrawInvInfo(this);
                    break;
                case "saveMst":
                    ZJSIG.UIProcess.SCM.UIScmDeliveryMst.saveMstInfo(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
