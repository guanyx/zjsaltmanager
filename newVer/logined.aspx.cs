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
using ZJSIG.UIProcess.Common;

public partial class logined : System.Web.UI.Page
{

    public string LoginName = "";
    public string LoginDepart = "";
    public string LoginOrg = "";
    public string UserName = "";

    protected void Page_Load( object sender, EventArgs e )
    {
        string Action = Request.QueryString[ "method" ];
        if ( "logout".Equals( Action ) )
        {//注销
            ZJSIG.UIProcess.Log.WriteLog("用户：" + ZJSIG.UIProcess.ADM.UIAdmUser.UserName(this)
            + "，注销系统", this.Server.MapPath("") + "\\log" + DateTime.Now.ToString("yyyyMMdd") + ".txt");
            Session.Clear( );
            Response.Write("<script   language='javascript'>");
            Response.Write( "top.location.href='login.html';" );
            Response.Write( "</" + "script>" );
            Response.End( );
           // Response.Redirect( "index.html" );
        }
        if ("exit".Equals(Action))
        {
            ZJSIG.UIProcess.Log.WriteLog("用户：" + ZJSIG.UIProcess.ADM.UIAdmUser.UserName(this)
            + "，退出系统", this.Server.MapPath("") + "\\log" + DateTime.Now.ToString("yyyyMMdd") + ".txt");
            return;
        }
        if ( "getNews".Equals( Action ) )
        {
            string response = string.Empty;
            //如果是供应商就不要消息提醒
            if (ZJSIG.UIProcess.ADM.UIAdmUser.IsCustomer(this))
            {
                response = "无新公告！";
            }
            else
            {
                response = ZJSIG.UIProcess.BA.UISysMessage.getValidMessageList(this);
            }
            Response.Write( response );
            Response.End( );
        }
        if ( "chgpwd".Equals( Action ) )
        {
            ChangeUserPassword( );
        }

        if ( "fastCheckPriv".Equals( Action ) )
            fastCheckPriv( );

        //登录权限验证
        checkPriv();
    }

    /**
     * 修改用户密码 
     */
    private void ChangeUserPassword( )
    {
        string user = Request.Form[ "login_user" ];
        string oldp = Request.Form[ "old_login_password" ];
        string newp = Request.Form[ "login_password" ];
        string cfirmp = Request.Form[ "confirm_login_password" ];

        if ( newp != cfirmp )
        {
            Response.Write( "<script   language='javascript'>" );
            Response.Write( "alert('新密码和确认密码不一致，请修改！');" );
            Response.Write( "</" + "script>" );
            Response.End( );
        }
        long userId= ZJSIG.UIProcess.ADM.UIAdmUser.UserID( this );
        ZJSIG.ADM.BusinessEntities.AdmUser amduser = ZJSIG.ADM.BLL.BLAdmUser.GetModel( userId );
        if ( amduser == null )
        {
            Response.Write( "<script   language='javascript'>" );
            Response.Write( "alert('请先登录系统，在修改密码！');" );
            Response.Write( "</" + "script>" );
            Response.End( );
        }
        amduser.UserPassword = ZJSIG.UIProcess.MD5.md5( newp );
        ZJSIG.ADM.BLL.BLAdmUser.Update( amduser );
        Response.Write( "<script   language='javascript'>" );
        Response.Write( "alert('密码修改成功！');" );
        Response.Write( "window.close();" );
        Response.Write( "</" + "script>" );
        Response.End( );
    }

    /**
     * 权限校验，校验不通过显示错误页面 
     */
    private void checkPriv()
    {        
        bool haspass = true;

        //if ("login".Equals(Request.Form["actionName"]))
        //{
        //    //获取用户名和密码
        //    loginUser = Request.Form["login_user"];
        //    loginPwd = Request.Form["login_password"];
        //    //获取mac地址
        //    loginMacAddr = Request.Form["login_MacAddr"];
        //    if (loginMacAddr == null)
        //        loginMacAddr = "";
        //    loginMacAddr = loginMacAddr.Replace("%3a", "-");
        //}
        //else
        //{
        //    haspass = Session["HasPass"] == null ? false : Boolean.Parse(Session["HasPass"].ToString());
        //}


        /*
         * 调用wcf后台
         */
        /*
        if("ture".Equals(Session["HasPass"].ToString().ToLower()))
         return ;
        
         hear is the call ckeak code,bla bla bla ...
         haspass == backClass.check_priv();
        */
        try
        {
            if ( ZJSIG.UIProcess.ADM.UIAdmUser.userLogin( this ) )
            {
                haspass = true;
            }
            else
            {
                haspass = false;
            }
            // haspass = true;
        }
        catch ( UICommonException ex )
        {
            string errMsg1 = ex.Message;
            Response.Redirect( "errorPage.aspx" + "?errCode=1003&errMessage=" + errMsg1 );
        }

        ZJSIG.UIProcess.Log.WriteLog("用户：" + Request.Form["login_user"]
            + "尝试登录，校验通过：" + haspass + "，用户ip：" 
            + ZJSIG.UIProcess.ADM.UIAdmUser.getUserIPAddress( this ), this.Server.MapPath( "" ) + "\\log" + DateTime.Now.ToString( "yyyyMMdd" ) + ".txt" );

        if (haspass)
        {
            //假设登录成功
            //Session.Add( "HasPass", haspass.ToString() );
            //Session.Add("LoginUser",loginUser);
            //Session.Add("LoginPwd",loginPwd);
            //Session.Add( "LoginMacAddr", loginMacAddr );
            try
            {
                LoginName = ZJSIG.ADM.BLL.BLAdmUser.GetModel( ZJSIG.UIProcess.ADM.UIAdmUser.UserID( this ) ).UserRealname;
                UserName = Request.Form[ "login_user" ];
                try
                {
                    long depId = ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this);
                    if (depId > 0)
                        LoginDepart = ZJSIG.ADM.BLL.BLAdmDept.GetModel(depId).DeptName;
                    LoginOrg = ZJSIG.ADM.BLL.BLAdmOrg.GetModel(ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)).OrgName;
                }
                catch (Exception eee) { };
            }
            catch(Exception ep)
            {
                string errMsg1 = ep.Message;
                Response.Redirect( "errorPage.aspx" + "?errCode=1001&errMessage=" + errMsg1 );
            }
        }
        else
        {
            string errMsg = "权限验证错误,请验证用户名和密码正确后重新登录系统！";
            Response.Redirect("errorPage.aspx" + "?errCode=1001&errMessage=" + errMsg);
        }
    }
    /**
     * 异步权限校验，校验不通过显示错误页面 
     */
    private void fastCheckPriv( )
    {
        if ( ZJSIG.UIProcess.ADM.UIAdmUser.userLogin( this ) )
        {
            Response.Write( "true" );
            Response.End( );
        }
        else
        {
            Response.Write("false");
            Response.End( );
        }
    }
}
