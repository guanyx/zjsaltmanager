using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.Common;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }
        switch (method)
        {
            case "getValidateCode":
                Response.ContentType = "image/Png";
                var ValidateNum = new ValidateCodeImg(4, 80, 25);

                var validateCode = ValidateNum.GetValidateCode();
                Session[string.Format("session_validatecode_{0}", method)] = validateCode;
                Session.Timeout = 20;

                Response.ClearContent();
                Response.ContentType = "image/Png";
                Response.BinaryWrite(ValidateNum.GetImgWithValidateCode());
                Response.End();
                break;
            case "Login":
                //验证码校验
                string errorMessage = "";
                var txtValidateCode = Request.Form["ValidateCode"];
                if (Session["session_validatecode_getValidateCode"] == null)
                {
                    errorMessage = "验证码过期！";
                }
                else if (txtValidateCode.ToLower() != Session["session_validatecode_getValidateCode"].ToString().ToLower())
                {
                    errorMessage = "验证码输入有误，请重新输入！";
                }
                else
                {
                    if (ZJSIG.UIProcess.ADM.UIAdmUser.userLogin(this))
                    {
                        Response.Redirect("QT/Frames/DeskTop.aspx");
                    }
                    else
                    {
                        errorMessage = "登录失败，请检查输入内容！";
                    }
                }

                if (!string.IsNullOrEmpty(errorMessage))
                {
                    Response.Write("<script   language='javascript'>");
                    Response.Write("alert('" + errorMessage + "');");
                    Response.Write("window.history.go(-1);");
                    Response.Write("</" + "script>");
                    Response.End();
                }
                break;
            case "logout":
                Session.Clear();
                Session.Clear();
                Response.Write("<script   language='javascript'>");
                Response.Write("top.location.href='../../Default.aspx';");
                Response.Write("</" + "script>");
                Response.End();
                break;
        }
    }
}
