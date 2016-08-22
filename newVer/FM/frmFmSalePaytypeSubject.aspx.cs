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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.FM;
using System.Text;

public partial class FM_frmFmSalePaytypeSubject : PageBase
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
        script.Append( "var dsSalePayType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_SALE_PAY_TYPE ) );

        //开户银行
        script.Append( "var dsBank = " );
        script.Append( UIFmBankAccount.getAccountListStore(this) );

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

            case "deleteSubject":
                UIFmSalePaytypeSubject.deleteSubject( this );
                break;
            case "addSalePaytype":
                UIFmSalePaytypeSubject.addSubject( this );
                break;
            case "saveSalePaytype":
                UIFmSalePaytypeSubject.editSubject( this );
                break;
            case "getSubject":
                UIFmSalePaytypeSubject.getSubject( this );
                break;
            case "getSubjectList":
                UIFmSalePaytypeSubject.getSubjectList( this );
                break;
        }
    }
}
