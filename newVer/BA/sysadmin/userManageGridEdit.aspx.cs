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
using ZJSIG.Common.DataSearchCondition;

public partial class sysadmin_userManagerGridEdit : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
           // ADM_UIProcess.doProcess( method, Request );
        }
        catch ( Exception ex )
        {
            throw (ex);
        }
        if ( "getUser".Equals( method ) )
        {
            string USER_ID = Request.Params["USER_ID"];
            string USER_NAME = Request.Params["USER_NAME"];
            string USER_REALNAME = Request.Params["USER_REALNAME"];
            int limit = int.Parse( Request.Form["limit"] );
            int start = int.Parse( Request.Form["start"] );

            string response = string.Empty;

            int recordCount = 0;

            int pageIndex = start / limit + 1;//页码
            int pageSize = limit;//每页行数
            QueryConditions query = new QueryConditions();
            List<AdmUser> list = BLAdmUser.GetPageList( pageIndex, pageSize, query, "USER_ID", out recordCount );

            response = "{'totalProperty':'" + recordCount + "','root':[";

            if ( list != null )
            {
                foreach ( AdmUser user in list )
                {
                    response += "{'USER_ID':'" + user.UserId + "'" +
                        ",'USER_NAME':'" + user.UserName + "'" +
                        ",'USER_REALNAME':'" + user.UserRealname + "'" +
                        ",'USER_ISLOCKED':'" + user.UserIslocked + "'" +
                        ",'USER_BINDIP':'" + user.UserBindip + "'" +
                        ",'USER_IPADDRESS':'" + user.UserIpaddress + "'" +
                        ",'CREATE_DATE':'" + user.CreateDate.ToString( ) + "'},";
                }
                response = response.Substring( 0, response.Length - 1 );
            }
            response += "]}";
            Response.Write( response );
            Response.End( );
        }
        else if ( "getModifyUser".Equals( method ) )
        {
            string USER_ID = Request.Params["USER_ID"];
    
            AdmUser user = BLAdmUser.GetModel( long.Parse(USER_ID) );

            string reponse = string.Empty;
            reponse = "{USER_ID:'" + user.UserId + "',USER_NAME:'" + user.UserName
                + "',USER_REALNAME:'" + user.UserRealname + "',USER_PASSWORD:'" + user.UserPassword
                + "',USER_IPADDRESS:'" + user.UserIpaddress + "',USER_ISLOCKED:'" + user.UserIslocked
                + "',USER_BINDIP:'" + user.UserBindip + "'}";

            Response.Write( reponse );
            Response.End( );
        }
        else if ( "deleteUser".Equals( method ) )
        {
            string USER_ID = Request.Params["USER_ID"];

            string reponse = string.Empty;
            BLAdmUser.Delete( long.Parse(USER_ID) );

            Response.Write( reponse );
            Response.End( );

        }
        else if ( "addUser".Equals( method ) )
        {
            string USER_ISLOCKED = Request.Params["USER_ISLOCKED"];
            string USER_BINDIP = Request.Params["USER_BINDIP"];
            //string USER_ID = Request.Params["USER_ID"]; //这个没有
            string USER_NAME = Request.Params["USER_NAME"];
            string USER_REALNAME = Request.Params["USER_REALNAME"];
            string USER_PASSWORD = Request.Params["USER_PASSWORD"];
            string USER_IPADDRESS = Request.Params["USER_IPADDRESS"];

            AdmUser user = new AdmUser();
            user.UserName = USER_NAME;
            user.UserRealname = USER_REALNAME;
            user.UserPassword = USER_PASSWORD;
            user.UserIpaddress =USER_IPADDRESS;
            user.UserBindip = bool.Parse(USER_BINDIP);
            user.UserIslocked = bool.Parse( USER_ISLOCKED );

            BLAdmUser.Add( user );
           
            Response.Write( "" );
            Response.End( );
        }
        else if ( "saveUser".Equals( method ) )
        {
            string USER_ISLOCKED = Request.Params["USER_ISLOCKED"];
            string USER_BINDIP = Request.Params["USER_BINDIP"];
            string USER_ID = Request.Params["USER_ID"]; 
            string USER_NAME = Request.Params["USER_NAME"];
            string USER_REALNAME = Request.Params["USER_REALNAME"];
            string USER_PASSWORD = Request.Params["USER_PASSWORD"];
            string USER_IPADDRESS = Request.Params["USER_IPADDRESS"];

            AdmUser user = new AdmUser( );
            user.UserId = long.Parse(USER_ID);
            user.UserName = USER_NAME;
            user.UserRealname = USER_REALNAME;
            user.UserPassword = USER_PASSWORD;
            user.UserIpaddress = USER_IPADDRESS;
            user.UserBindip = bool.Parse( USER_BINDIP );
            user.UserIslocked = bool.Parse( USER_ISLOCKED );

            BLAdmUser.Update( user );

            Response.Write( "" );
            Response.End( );
        }else if ( "getCustType".Equals( method ) )
        {
            //模拟数据
            System.Collections.ArrayList al = new System.Collections.ArrayList( );
            al.Add( new string[] { "1", "内部客户" } );
            al.Add( new string[] { "2", "外部客户" } );
            al.Add( new string[] { "3", "客商" } );
            al.Add( new string[] { "4", "其他客商" } );

            string response = string.Empty;
            response = "{'totalProperty':'" + al.Count + "','root':[";

            foreach ( String[] itator in al )
            {
                response += "{'custId':'" + itator[0] + "'" +
                    ",'custName':'" + itator[1] + "'},";
            }
            response = response.Substring( 0, response.Length - 1 );
            response += "]}";
            Response.Write( response );
            Response.End( );
        }
    }
}
