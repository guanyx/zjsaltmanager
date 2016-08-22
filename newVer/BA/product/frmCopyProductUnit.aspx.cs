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
using System.Text;

public partial class BA_product_frmCopyProductUnit : System.Web.UI.Page
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        

        script.Append( "var productId=\"" + this.Request.QueryString[ "productId" ] + "\";\r\n" );
        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request[ "method" ];
        switch ( method )
        {
            case"copyunit":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.copyUnit( this );
                break;
        }
    }
}
