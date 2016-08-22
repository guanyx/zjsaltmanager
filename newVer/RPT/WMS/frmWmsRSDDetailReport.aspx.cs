using System;
using System.Collections;
using System.Collections.Generic;
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
using ZJSIG.UIProcess.RPT.WMS;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;
using System.Text;
using ZJSIG.UIProcess.CRM;
using ZJSIG.UIProcess.BA;

public partial class RPT_WMS_frmWmsRSDDetailReport : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //仓库
        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        //组织
        script.Append("\r\n");
        script.Append("var dsOrgListInfo = ");
        script.Append(UIAdmOrg.getOrgListStore(this));

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append(UIBaProduct.getProductListInfoStore(this));

        script.Append("\r\n");
        script.Append("var dsDrawListInfo = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("S10"));//

        script.Append("\r\n");
        script.Append("var dsRSDBillTypeListInfo = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['DicsCode','DicsName'],\r\n");
        script.Append("data:[['0','--全部--'],['W0201','采购入库'],['W0202','销售出仓']],\r\n");
        script.Append("autoLoad: false});\r\n");

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIWmsStockDayStat.getWarehouseRSDDetailSearchReport(this);
                break;
        }
    }
}
