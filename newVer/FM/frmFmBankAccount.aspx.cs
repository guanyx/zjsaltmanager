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
using ZJSIG.UIProcess.FM;

public partial class FM_frmFmBankAccount : PageBase
{
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
            case "getBankAccountList":
                UIFmBankAccount.getAccountList( this );
                break;
            case "deleteBankAccount":
                UIFmBankAccount.deleteAccount( this );
                break;
            case "addBankAccount":
                UIFmBankAccount.addAccount( this );
                break;
            case "saveBankAccount":
                UIFmBankAccount.editAccount( this );
                break;
            case "getBankAccount":
                UIFmBankAccount.getAccount( this );
                break;
        }
    }
}
