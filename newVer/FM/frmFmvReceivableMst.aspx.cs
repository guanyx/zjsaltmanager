﻿using System;
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

public partial class FM_frmFmvReceivableMst : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //组织
        //script.Append( "\r\n" );
        //script.Append( "var dsOrgList = " );
        //script.Append( UIAdmOrg.getOrgListStore( this ) );

        //组织
        script.Append( "\r\n" );
        script.Append( "var orgId = '" + OrgID.ToString( ) + "';" );
        script.Append( "\r\n" );
        script.Append( "var orgName = '" + OrgName + "';" );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }


    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
            method = Request.QueryString["method"];
            switch ( method )
            {

                case "getlist":
                    ZJSIG.UIProcess.FM.UIFmAccountRece.processAccountReceMst(this, "VFmReceivableMst");
                    break;
                case "getgroupby":
                    ZJSIG.UIProcess.UIProcessBase.GetGroupStore( this, "VFmReceivableMst" );
                break;
            }
    }
}
