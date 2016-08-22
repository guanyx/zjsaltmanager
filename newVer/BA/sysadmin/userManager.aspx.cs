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
using System.Collections.Generic;
using ZJSIG.ADM.BusinessEntities;
using ZJSIG.ADM.BLL;
using ZJSIG.UIProcess.ADM;
using ZJSIG.Common.DataSearchCondition;

public partial class sysadmin_userManager :PageBase
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
        if ( "getUser".Equals( method ) )
        {
            UIAdmUser.getUserList( this );
        }
        else if ( "getModifyUser".Equals( method ) )
        {
            UIAdmUser.getUser( this );
        }
        else if ( "deleteUser".Equals( method ) )
        {
            UIAdmUser.deleteUser( this );
        }
        else if ( "addUser".Equals( method ) )
        {
            UIAdmUser.addUser( this );
        }
        else if ( "saveUser".Equals( method ) )
        {
            UIAdmUser.editUser( this );
        }
        else if ("getRoleByUser".Equals(method))
        {
            UIAdmRole.getRoleByUser(this);
        }
    }
}
