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

public partial class SCM_frmProvidePurch : PageBase
{

    public string getColModel()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取发运类型
        script.Append( "var SendTypeStore =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(
            ZJSIG.UIProcess.Common.CommonDefinition.ADM_SEND_TYPE ) );

        script.Append(ZJSIG.UIProcess.SCM.UIScmPurch.createHeaderAndRows(this));

        

        script.Append("</script>");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"saveprovide":
                ZJSIG.UIProcess.SCM.UIScmPurch.saveProvide( this );
                break;
            case"exportExcel":
                break;
        }
    }

    private void exportExcel( )
    {

    }
}
