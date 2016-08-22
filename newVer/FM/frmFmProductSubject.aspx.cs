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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.FM;
using ZJSIG.UIProcess.BA;

public partial class FM_frmFmProductSubject : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //收款方式
        script.Append( "var dsRegexType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_REGEX_TYPE ) );

        ////开户银行
        //script.Append( "var dsBank = " );
        //script.Append( UIFmBankAccount.getAccountListStore( this ) );

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

            case "addProductSubject":
                UIFmProductSubject.addSubject( this );
                break;
            case "saveProductSubject":
                UIFmProductSubject.editSubject( this );
                break;
            case "getSubject":
                UIFmProductSubject.getSubject( this );
                break;
            case "getProductSubjectList":
                UIFmProductSubject.getSubjectList( this );
                break;
            case "deleteSubject":
                UIFmProductSubject.deleteSubject( this );
                break;
            case "getProducts":
                UIBaProduct.getProductListForDropDownList( this );
                break;
        }
    }
}
