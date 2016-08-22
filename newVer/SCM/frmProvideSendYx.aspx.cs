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
using ZJSIG.UIProcess.BA;
using System.Text;
using ZJSIG.UIProcess.Common;

public partial class SCM_frmProvideSendYx : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //发运单状态
        script.Append("var dsStatus = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_PROVIDE_SEND_TYPE));

        //发运方式  
        script.Append("var dsTransType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A40"));

        //到站信息
        script.Append("var dsDestination = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmOrgDestinationCfg.GetAllDestinationsStore(this));

        //获取商品列表(管理进去供应商)
        script.Append("\r\n");
        script.Append("var dsSupplier = ");
        //script.Append( ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppliesListInfoStore( this ) );
        script.Append(ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppliesListInfoStore(1));

        script.Append("\r\n");
        script.Append("var dsOrg = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgListStore(this));

        script.Append("var cmbDoneYearList = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getYearList());

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
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getProvideSendList"://这里应该添加登录供应商的id来过滤
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getMstAndDtlYxList(this);
                    break;
                case "getProvideSend":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getMst(this);
                    break;           
                case "saveProvideSend":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.saveProvideDataYx(this);
                    break;
                case "confirmProvideSend"://省公司应付
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.confirmProvideData(this);
                    break;
                case "submitProvideSend":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.submitProvideDataYx(this);
                    break;
                case "deleteProvideSend":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.deleteMstDataYx(this);
                    break;
                case "getProvideSendDtl":
                    ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getDtlList(this);
                    break;
                case "getSppierProducts":
                    ZJSIG.UIProcess.BA.UIBaProduct.getSuppierProductSpecialListForDropDownList(this);
                    break;
                case "getProductUnits":
                    ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStore(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
