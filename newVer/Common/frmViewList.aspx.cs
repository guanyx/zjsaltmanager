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
using System.Text;

using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess;

public partial class Common_frmViewList : System.Web.UI.Page
{
    public string getColModel( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        string viewName = Uri.UnescapeDataString(this.Request.QueryString["viewName"] + "");
        if ( viewName == null || viewName == "" )
        {
            viewName = "统计报表1";
        }
        script.Append(UIAdmStaticReport.createHeadModel(viewName));// this.Request[ "ReportName" ] ));
        string columns = script.ToString();
        script.Append( "var schemeStore = " );
        script.Append( UIAdmStaticReport.getSchemeStore( this ) );
        if ( columns.IndexOf( "ProductName" ) != -1 )
        {
            script.Append( "\r\nvar needProductType=true;\r\n" );
        }
        else
        {
            script.Append( "\r\nvar needProductType=false;\r\n" );
        }
        if ( columns.IndexOf( "WhName" ) != -1 || script.ToString().IndexOf("OutStorName")!=-1)
        {
            //获取仓库信息
            script.AppendLine( "var dsWareHouse = " );
            script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListNameInfoStoreByEmpId( this ) );
        }
        //配送方式
        if ( columns.IndexOf( "DlvTypeName" ) != -1 )
        {
            script.AppendLine( "var dsDlvType = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "S04", "DicsName" ) );
        }
        //支付方式
        if ( columns.IndexOf( "PayTypeName" ) != -1 )
        {
            script.AppendLine( "var dsPayType = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "S02", "DicsName" ) );
        }
        //发票类型
        if ( columns.IndexOf( "BillModeName" ) != -1 )
        {
            script.AppendLine( "var dsBillMode = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "S03", "DicsName" ) );
        }
        //企业性质
        if ( columns.IndexOf( "CorpKindName" ) != -1 )
        {
            script.AppendLine( "var dsCorpKind = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "C03", "DicsName" ) );
        }
        //所属行业
        if ( columns.IndexOf( "TradeTypeName" ) != -1 )
        {
            script.AppendLine( "var dsTradeType = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "Z07", "DicsName" ) );
        }
        //所属行业
        if ( columns.IndexOf( "CustomerKindName" ) != -1 )
        {
            script.AppendLine( "var dsCustomerKind = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( this, "C04", "DicsName" ) );
        }
        if ( columns.IndexOf( "ProductUseName" ) != -1 )
        {
            script.AppendLine( " var dsProductUse = " + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoTreeStore( 1, UIProcessBase.OrgID( this ) ) );
        }
        if ( columns.IndexOf( "RouteName" ) != -1 )
        {
            script.AppendLine( "var dsRoute = " + ZJSIG.UIProcess.SCM.UIScmDistributionRoute.getRouteStore( this, "RouteName" ) );
        }
        //script.Append( "\r\n reportViewName = 'VWmsStockCurrent';\r\n" );
        script.AppendLine( "</script>" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIAdmStaticReport.getViewList( this );
                break;
            case"getstaticcolumn":
                UIAdmStaticReport.getStaticColumn( this );
                break;
            case"getstaticvalue":
                UIAdmStaticScheme.getStaticValue( this );
                break;
            case"getgraphvalue":
                UIAdmStaticScheme.getStaticGraphValue( this );
                break;
            case "getgroupby":
                long reportId = 0;
                long.TryParse( this.Request[ "otherParams" ], out reportId );
                    UIProcessBase.GetGroupStore( this, reportId );
                break;
            case "exportData":
                ZJSIG.UIProcess.RPT.SCM.UIExportFile.ExportViewList( this );
                break;
            case"getSchemeList":
                UIAdmStaticScheme.getStaticSchemeList( this );
                break;
            case"getGroupList":
                UIAdmStaticScheme.getStaticSchemeList( this );
                break;
            case"saveScheme":
                UIAdmStaticScheme.saveStaticScheme( this );
                break;
            case"deletscheme":
                UIAdmStaticScheme.deleteScheme( this );
                break;
        }
    }
}
