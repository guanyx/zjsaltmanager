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

public partial class ZJ_frmQtSaltList : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getSaltList":
                ZJSIG.UIProcess.QT.UIQtSalt.getSaltList( this );                
                break;
            case"saveSalt":
                ZJSIG.UIProcess.QT.UIQtSalt.saveSalt( this );
                break;
            case"delSalt":
                ZJSIG.UIProcess.QT.UIQtSalt.delSalt( this );
                break;
            case"getTemplateItems":
                ZJSIG.UIProcess.QT.UIQtSalt.getTemplateItems( this );
                break;
            case"saveSaltLevel":
                ZJSIG.UIProcess.QT.UIQtSalt.saveSaltStandard( this );
                break;
            case"getSaltLevelStandard":
                ZJSIG.UIProcess.QT.UIQtSalt.getSaltLevelList( this );
                break;
            case"delLevel":
                ZJSIG.UIProcess.QT.UIQtSalt.delSaltLevel( this );
                break;
        }
    }
}
