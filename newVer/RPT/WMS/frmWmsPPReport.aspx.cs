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

public partial class RPT_WMS_frmWmsPPReport : PageBase
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

        ////组织
        //script.Append("\r\n");
        //script.Append("var dsOrgListInfo = ");
        //script.Append(UIAdmOrg.getOrgListStore(this));

        //script.Append("\r\n");
        //script.Append("var dsProductList = ");
        //script.Append(UIBaProduct.getProductListInfoStore(this));

        script.Append( "\r\n" );
        script.Append( "var orgId = '" + OrgID.ToString( ) + "';" );
        script.Append( "\r\n" );
        script.Append( "var orgName = '" + OrgName + "';" );
        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                ZJSIG.UIProcess.UIProcessBase.getPageList( this, "VWmsRptPprReport" );
                //UIWmsStockDayStat.getWarehousePPReport(this);
                break;
            case "getgroupby":
                ZJSIG.UIProcess.UIProcessBase.GetGroupStore( this, "VWmsRptPprReport" );
                break;
        }
    }
}
