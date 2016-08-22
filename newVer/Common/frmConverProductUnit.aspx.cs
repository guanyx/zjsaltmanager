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

public partial class Common_frmConverProductUnit : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
            switch ( method )
            {
                case "getProductUnits":
                    ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStore( this );
                    break;
                case"getConvertData":
                    long productId = 0;
                    long unitId = 0;
                    long convertUnit = 0;
                    long.TryParse( this.Request[ "ProductId" ], out productId );
                    long.TryParse( this.Request[ "UnitId" ], out unitId );
                    long.TryParse( this.Request[ "ConvertUnit" ], out convertUnit );
                    decimal d = ZJSIG.BA.BusinessLogic.BLBaProduct.getConvertUnitRate( productId, unitId, convertUnit );
                    decimal oldData = 0;
                    decimal.TryParse( this.Request[ "ProductQty" ], out oldData );
                    ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
                    message.success = true;
                    message.errorinfo = System.Math.Round( oldData * d, 8 ).ToString();
                    this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson( message ) );
                    this.Response.End( );
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
