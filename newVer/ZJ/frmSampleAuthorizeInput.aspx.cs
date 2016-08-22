using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class ZJ_frmSampleAuthorizeInput : System.Web.UI.Page
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        script.AppendLine( "var checkTypeStore=" + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "Q09" ) );
        //获取委托Id
        script.AppendLine( "var AuthorizeId='" + this.Request.QueryString[ "id" ] + "';" );
        script.AppendLine( "var fromBillType='" + this.Request.QueryString[ "FromBillType" ] + "';" );
        script.AppendLine( "var fromBillId='" + this.Request.QueryString[ "FromBillId" ] + "';" );
        //获取组织
        script.Append( "var dsOrg = " );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmOrg.getAllAreaTopOrgListStoreById( this ) );
        script.AppendLine( "</script>" );
        return script.ToString();
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
                //保存委托信息
            case"save":
                ZJSIG.UIProcess.QT.UIQtAuthorize.saveAuthorize( this );
                break;
            case"getauthorize":
                ZJSIG.UIProcess.QT.UIQtAuthorize.getAutorizeByFromBill( this );
                break;
            case"del":
                ZJSIG.UIProcess.QT.UIQtAuthorize.deleteAuthorize( this );
                break;
        }
    }
}
