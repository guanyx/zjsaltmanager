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

public partial class ZJ_frmSaltLevelList : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        return "";
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getlevel":
                ZJSIG.UIProcess.QT.UIQtSalt.getLevelList( this );
                break;
            case"getlevelstandard":
                ZJSIG.UIProcess.QT.UIQtSalt.getLevelStandardList( this );
                break;
            case "savelevelstandardmemo":
                ZJSIG.UIProcess.QT.UIQtSalt.saveLevelStandardMemo( this );
                break;
        }
    }
}
