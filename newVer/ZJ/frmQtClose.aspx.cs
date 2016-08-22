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

public partial class ZJ_frmQtClose : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        if ( !this.IsPostBack )
        {
            setLabelInformation( );
        }
    }

    protected void btnCloseClick( object sender, EventArgs e )
    {
        try
        {
            int year = 0;
            int month = 0;
            int.TryParse( lblCloseMonth.Text.Substring( 0, 4 ), out year );
            int.TryParse( lblCloseMonth.Text.Substring( 5, lblCloseMonth.Text.Length - 6 ), out month );
            DateTime dtClose = new DateTime( year, month, 1 );
            ZJSIG.UIProcess.QT.UIClose.QtCheckClose( dtClose, this );
            setLabelInformation( );
        }
        catch
        {

        }
    }

    protected void btnCancelClick( object sender, EventArgs e )
    {
        try
        {
            int year = 0;
            int month = 0;
            int.TryParse( lblCancel.Text.Substring( 0, 4 ), out year );
            int.TryParse( lblCancel.Text.Substring( 5, lblCancel.Text.Length - 6 ), out month );
            DateTime dtClose = new DateTime( year, month, 1 );
            ZJSIG.UIProcess.QT.UIClose.QtCheckUnClose( dtClose, this );
            setLabelInformation( );
        }
        catch
        {

        }
    }

    private void setLabelInformation( )
    {
        DateTime closingMonth = ZJSIG.UIProcess.QT.UIClose.getCurrentClosingDate( );
        this.lblCloseMonth.Text = closingMonth.Year + "年" + closingMonth.Month + "月";
        try
        {
            closingMonth = ZJSIG.UIProcess.QT.UIClose.getMaxClosedDate( );
            this.lblCancel.Text = closingMonth.Year + "年" + closingMonth.Month + "月";
            this.lblCancel.Visible = true;
            this.btnCancel.Visible = true;
        }
        catch
        {
            this.lblCancel.Visible = false;
            this.btnCancel.Visible = false;
        }
    }
}
