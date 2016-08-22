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

public partial class SCM_frmSaleQuery : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取组织
        //script.Append( "var dsOrg = " );  //这个变量名界面combobox需要使用，保持一致
        ////可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        ////其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        //script.Append( ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore( this ) );

        //订单类型
        script.Append( "var dsOrderType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S01" ) );

        //配送方式
        script.Append( "var dsDlvType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S04" ) );

        //获取仓库信息
        script.AppendLine( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStoreByEmpId( this ) );

        script.Append("var orgId = '" + OrgID.ToString() + "';");

        script.Append("var orgName='" + OrgName + "';");
                

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {

            method = Request.QueryString["method"];
            switch ( method )
            {
                case "getOrderList":
                    ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.getSalequeryList( this );
                    break;
                case "getWhSimple"://根据公司得到仓库列表
                    ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListByOrgId( this );
                    break;
                case "exportData":
                    ZJSIG.UIProcess.RPT.SCM.UIExportFile.ExportScmSaleQuery(this);
                    break;

            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
