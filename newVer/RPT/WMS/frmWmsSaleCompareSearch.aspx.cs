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

public partial class RPT_WMS_frmWmsSaleCompareSearch : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //仓库
        script.Append( "\r\n" );
        //script.Append( "var dsWarehouseList = " );
        //script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        script.Append("\r\n");
        script.Append("var orgId = '" + OrgID.ToString() + "';");
        script.Append("\r\n");
        script.Append("var orgName='" + OrgName + "';");

        //组织
        //script.Append("\r\n");
        //script.Append("var dsOrgListInfo = ");
        //script.Append(UIAdmOrg.getOrgListStore(this));

        //客户和内部客户
        script.Append("\r\n");
        //script.Append("var dsCustomerListInfo = ");
        //script.Append(UIBusinessCrmCustomer.getCustAndInCustListByOrgInfoStore(this));

        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIWmsStockDayStat.getSaleCompareSearchReport( this );
                break;
        }
    }
}
