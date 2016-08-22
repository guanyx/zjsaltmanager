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
using ZJSIG.Common.DataSearchCondition;

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

        //权限
        script.Append(checkPrivilege());

        //单位
        script.Append( "\r\n" );
        script.Append( "var dsUnitList = " );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( ) );

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "provide", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        System.Data.DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printPageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printPageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printStyleXml = 'jsprovideprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =355;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append( initToolBar( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    /// <summary>
    /// 权限
    /// </summary>
    /// <returns></returns>
    private string checkPrivilege()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function checkPrivilege(_dataGrid)\r\n");
        script.Append("{\r\n");
        if (!ValidateControlActionRight("采购价格修改"))
        {
            script.Append(" var cm = _dataGrid.getColumnModel();\r\n");
            script.Append(" cm.setEditable(5, false);;\r\n");
        }
        script.Append("}\r\n");
        return script.ToString();
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

        string iconUrl = "imageUrl + \"images/extjs/customer/{0}\"";
        ToolBarButton tb = null;
        switch ( Action )
        {
            //新增采购订单
            case "":
                tb = new ToolBarButton( "addNew", "新增", string.Format( iconUrl, "add16.gif" ), "Toolbar" );
                script.Append( tb.createButton( ) );
                script.Append( new ToolBarButton( "editMessage", "编辑", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "delMessage", "删除", string.Format( iconUrl, "delete16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "sendMessage", "确认", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "printMessage", "打印", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                break;
            //订单到入仓
            case "check":
                script.Append( new ToolBarButton( "viewMessage", "查看", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "cancleMessage", "取消确认", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "createStoreOrder", "生成入仓进货单", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "printMessage", "打印", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                break;
            //查看
            case "my":
                script.Append( new ToolBarButton( "viewMessage", "查看", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "printMessage", "打印", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                break;
           

        }
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

            case "add":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.addMessage( this );
                break;
            case"edit":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.editMessage( this );
                break;
            case "getmessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessage( this );
                break;
            case "getmessagelist":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getMessageList( this );
                break;
            case "savemessagedetail":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.SaveDetail( this );
                break;
            case "confirmmessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.ConfirmProvide( this );
                break;
            case "editmst":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.editMessage( this );
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
            case"deletemessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.deleteMessage( this );
                break;
            case"createstore":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.confirmTransmitData( this );
                break;
            case "getsuppiler":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSuppilerAndInnerCustomerListForDropDownList(this);
                break;
            case"cancleMessage":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.CancleMessage( this );
                break;
            case"getdtlinfo":
                //ZJSIG.UIProcess.SCM.UIScmProvideMessage.getPurchOrderState( this );
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getDetailInfo ( this );
                break;
            case"getpuchstate":
                ZJSIG.UIProcess.SCM.UIScmProvideMessage.getPurchOrderState( this );
                break;
            case "getprintdata":
                System.Data.DataSet ds = ZJSIG.UIProcess.SCM.UIScmProvideMessage.getProvideMessagePrintData( this );
                string str = ToDataSetString( ds );
                this.Response.Write( str );
                this.Response.End( );
                break;
        }

    }
}
