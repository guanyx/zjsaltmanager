using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;

public partial class CRM_Contract_frmCrmContractPay : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //付款类型
        script.Append( "var dsPayType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CONTRACT_PAY_TYPE ) );

        script.Append( "</script>\r\n" );
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

        switch ( method )
        {
            case "getContracts":
                ZJSIG.UIProcess.CRM.UICrmContract.getContractListForDropDownList( this );
                break;
            case "getContract":
                ZJSIG.UIProcess.CRM.UICrmContract.getContract( this );
                break;
            case "getContractPayList":
                ZJSIG.UIProcess.CRM.UICrmContractPay.getPayList( this);
                break;
            case "deletePay":
                ZJSIG.UIProcess.CRM.UICrmContractPay.deletePay( this );
                break;
            case "getPay":
                ZJSIG.UIProcess.CRM.UICrmContractPay.getPay( this );
                break;
            case "addContractPay":
                ZJSIG.UIProcess.CRM.UICrmContractPay.addPay( this );
                break;
            case "saveContractPay":
                ZJSIG.UIProcess.CRM.UICrmContractPay.editPay( this );
                break;
        }
        
    }
}
