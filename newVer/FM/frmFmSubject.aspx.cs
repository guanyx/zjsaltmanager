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
using ZJSIG.UIProcess.FM;

public partial class FM_frmFmSubject : PageBase
{
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

            case "gettreelist":
                UIFmSubject.getFmSubjectTreeList( this );
                //string str = "[{cls:'folder',id:'1',children:[{cls:'folder',id:'2',uiProvider:'col',leaf:true,children:null,text:'2',CustomerColumn:'b2',CustomerColumn1:'',CustomerColumn2:''}],text:'1',uiProvider:'col',CustomerColumn:'a1',CustomerColumn1:'',CustomerColumn2:''}]";
                //Response.Write( str );
                //Response.End( );
                break;
            case "addSubject":
                UIFmSubject.addSubject( this );
                break;
            case "saveSubject":
                UIFmSubject.editSubject( this );
                break;


        }
    }
}
