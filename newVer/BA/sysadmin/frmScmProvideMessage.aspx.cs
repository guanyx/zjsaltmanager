using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using ZJSIG.UIProcess.Common;

public partial class SCM_frmScmProvideMessage : PageBase
{
    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //获取采购计划类型信息数据
        script.Append( "var cmbPlanTypeList =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S20" ) );

        script.Append( "var cmbStatusList =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S28" ) );

        //设置默认过滤条件
        script.Append( "var action='" + Action + "';\r\n" );
        //获取发运类型
        script.Append( "var SendTypeStore =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(
            ZJSIG.UIProcess.Common.CommonDefinition.ADM_SEND_TYPE ) );


        //设置默认过滤条件
        script.Append( "var action='" + Action + "';\r\n" );
        if ( Action == "" )
        {
            script.Append( "var view = false;\r\n" );
        }
        else
        {
            script.Append( "var view = true;\r\n" );
        }

        //单位
        script.Append( "\r\n" );
        script.Append( "var dsUnitList = " );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( ) );

        script.Append( initToolBar( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    /// <summary>
    /// 初始化ToolBar信息
    /// </summary>
    /// <returns></returns>
    private string initToolBar( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function iniToolBar(Toolbar)\r\n" );
        script.Append( "{\r\n" );

        string iconUrl = "imageUrl + \"/images/extjs/customer/{0}\"";
        ToolBarButton tb = null;

        script.Append(new ToolBarButton("eraserMessage", "清除", string.Format(iconUrl, "cross.gif"), "Toolbar").createButton());                
         
        script.Append( "Toolbar.render();\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";

        method = Request.QueryString[ "method" ];

        switch ( method )
        {

            case "getmessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessage( this );
                break;
            case "getmessagelist":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessageList( this );
                break;            
            case "getmstlist":
                ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getMstList( this );
                break;
            case "getdtllist":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessageDetailList( this );
                break;
            case"getProductInfoList":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getProductList( this );
                break;
            case"createstore":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.confirmTransmitData( this );
                break;
            case "getsuppiler":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppilerAndInnerCustomerListForDropDownList(this);
                break;
            case "eraserMessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.EraserMessage(this);
                break;
        }

    }
}
