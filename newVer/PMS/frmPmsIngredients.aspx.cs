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

public partial class PMS_frmPmsIngredients : PageBase
{

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "deleteIngredients":
                ZJSIG.UIProcess.PMS.UIPmsIngredients.deleteIngredients( this );
                break;
            case "getingredientsdtllist"://查同一接口
            case "getingredientslist":
                ZJSIG.UIProcess.PMS.UIPmsIngredients.getIngredientsList( this );
                break;
        }
    }
}
