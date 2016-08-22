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

public partial class Common_frmCurrentBusinessInformation : System.Web.UI.Page
{
    protected int moveNoInCount = 0;
    protected int purchNoStore = 0;
    protected int orderNoPayNoBillCount = 0;
    protected int orderNoPayCount = 0;
    protected int orderNoBillCount = 0;
    protected int purchCheckNoPayCount = 0;
    protected int storeLosingCount = 0;
    protected int storeOverCount = 0;
    protected int returnNoRedCount = 0;
    protected int returnNoPayedCount = 0;
    protected int returnNoInCount = 0;
    
    protected void Page_Load( object sender, EventArgs e )
    {
        moveNoInCount = ZJSIG.UIProcess.Report.BusinessInformation.getMoveNoIn( this );
        purchNoStore = ZJSIG.UIProcess.Report.BusinessInformation.getPurchNoStore( this );
        orderNoPayNoBillCount = ZJSIG.UIProcess.Report.BusinessInformation.getOrderNoPayNoBillCount( this );
        orderNoPayCount = ZJSIG.UIProcess.Report.BusinessInformation.getOrderNoPayCount( this );
        orderNoBillCount = ZJSIG.UIProcess.Report.BusinessInformation.getOrderNoBillCount( this );
        purchCheckNoPayCount = ZJSIG.UIProcess.Report.BusinessInformation.getPurchSaleNoPay( this );
        storeLosingCount = ZJSIG.UIProcess.Report.BusinessInformation.getLosingCount( this );
        storeOverCount = ZJSIG.UIProcess.Report.BusinessInformation.getOverFlowCount( this );
        returnNoPayedCount = ZJSIG.UIProcess.Report.BusinessInformation.getReturnPayed( this );
        returnNoRedCount = ZJSIG.UIProcess.Report.BusinessInformation.getReturnRed( this );
        returnNoInCount = ZJSIG.UIProcess.Report.BusinessInformation.getReturnNoIn(this);
    }
}
