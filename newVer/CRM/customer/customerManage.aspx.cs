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
using System.ServiceModel;
using System.Text;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.FM;

public partial class customer_customerManage : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获企业性质
        script.Append( "var dsCorpKind =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_CORPKIND ) );

        //所在省
        script.Append( "var dsProvince =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_PROVINCE ) );

        //所在市
        script.Append( "var dsCity =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_CITY ) );

        //所在县
        script.Append( "var dsTown =" );
        script.Append(UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_TOWN ) );

        //客户性质
        script.Append( "var dsCustKind =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_CUSTKIND ) );

        //结算方式
        script.Append( "var dsSettlementWay =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_SETTLEMENTWAY ) );

        //结算类型
        script.Append( "var dsSettlementType =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_SETTLEMENTTYPE ) );

        //结算币种
        script.Append( "var dsSettlementCurrency =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_SETTLEMENTCURRENCY ) );

        //所属行业
        script.Append( "var dsTradeType =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_TRADETYPE ) );

        //开通的网结银行
        script.Append( "var dsBalanceBank=" );
        script.Append( UISysDicsInfo.getDicsInfoStore( "Z11" ) );

        //开户银行
        //script.Append( "var dsBankId =" );
        //script.Append( UIFmBankAccount.getAccountListStore(this));

        //开票类型
        script.Append( "var dsInvoice =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( "S03" ) );

        //清算组织（本地区内单位）
        script.Append("var dsClearingOrg = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmOrg.getAllAreaOrgListStoreById(this));

        //配送类型
        script.Append( "var dsDistributionType =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CUSTOMER_DISTRIBUTIONTYPE ) );

        script.Append( "var orgId = '" + this.OrgID.ToString( ) + "';" );

        script.Append( "var owner='&Owner=" + OwnerId.ToString( ) + "';" );

        script.Append( "var custManager='" + this.Request.QueryString[ "custManager" ] + "';\r\n" );

        script.Append( setToolBarVisible( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    private string setToolBarVisible( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setToolBarVisible(toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "for(var i=0;i<toolBar.items.items.length;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "switch(toolBar.items.items[i].text)\r\n" );
        script.Append( "{\r\n" );
        if ( this.Request.QueryString[ "custManager" ] == "true" )
        {
            script.Append( "case'禁用':\r\n" );
            script.Append( "case'删除':\r\n" );
            script.Append( "case'创建客户用户':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        else
        {
            if ( !ValidateControlActionRight( "客户维护" ) )
            {
                script.Append( "case'新增':\r\n" );
                script.Append( "case'编辑':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'创建客户用户':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
            }
            else if ( !ValidateControlActionRight( "客户商品信息维护" ) )
            {
                script.Append( "case'商品特殊价格':\r\n" );
                script.Append( "case'可订购商品':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
            }
            else
            {
                script.Append( "case'查看':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
            }
        }
        script.Append( "default:\r\n" );
        script.Append( "break;\r\n" );
        script.Append( "}\r\n" );

        script.Append( "}\r\n" );
        script.Append( "}\r\n" );
        script.Append( "function setToolBarButtonHidden(i,toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i);\r\n" );
        script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i);\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );

    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch(method)
        { 
            case "getCustInfo":        
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomer( this );
                break;
            case "delete":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.deleteCustomer( this );
                break;
            case "forbidden":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.forbiddenCustomer(this);
                break;
            case "saveCustomer":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.editCustomer(this);                
                break;
            case "addCustomer":        
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.addCustomer( this );
                break;
            case "getCus":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerList( this );
                break;
            case "getCusByConLike":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getCustomerListForDropDownList( this );
                break;
            case "getuserbycustomerId":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getUserByCustomerId( this );
                break;
            case "saveuserbycustomer":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.saveUserByCustomer( this );
                break;
            case "getCustomerAdd":
                ZJSIG.UIProcess.CRM.UICrmCustomerAttributes.getAttributesList(this);
                break;
            case "saveCustomerAdd":
                ZJSIG.UIProcess.CRM.UICrmCustomerAttributes.saveAttributes( this );
                break;
            case "exportData":
                ZJSIG.UIProcess.RPT.SCM.UIExportFile.ExportCrmCustomerQuery(this);
                break;
        }
    }
}
