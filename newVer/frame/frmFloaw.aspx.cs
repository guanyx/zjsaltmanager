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
using ZJSIG.UIProcess.ADM;

public partial class frame_frmFloaw : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {

    }

    protected string getImageUrl( )
    {
        string action = this.Request.QueryString[ "Action" ];
        switch ( action )
        {
            case"base":
                return "basedata.JPG";
            case"sale":
                return "";
            case"system":
                return "systemfloaw.bmp";
        }
        return "basedata.JPG";
    }

    protected string getMap( )
    {
        StringBuilder sbMap = new StringBuilder( );


        sbMap.Append( "<map  name=\"Map\" id=\"Map\">\r\n" );
        switch(this.Request.QueryString["Action"])
        {
            case"system":
                sbMap.Append(getSystemMap());
                break;
            default:
                sbMap.Append( getBaseMap( ) );
                break;
        }     

        sbMap.Append( "</map>\r\n" );
        return sbMap.ToString( );
    }

    #region 设置图表热点信息

    /// <summary>
    /// 获取基础信息热点信息
    /// </summary>
    /// <returns></returns>
    protected string getBaseMap( )
    {
        StringBuilder sbMap = new StringBuilder( );
        string url = UIAdmResource.getOperatorResource( UserID, 10000 );
        sbMap.Append( this.getAreaStreing( "41,21,141,80", url, "可购商品维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 443 );
        sbMap.Append( this.getAreaStreing( "262,21,361,80", url, "销售基准价维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 5 );
        sbMap.Append( this.getAreaStreing( "41,240,141,300", url, "客户维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 15 );
        sbMap.Append( this.getAreaStreing( "262,181,362,240", url, "销售特殊定价" ) );

        url = UIAdmResource.getOperatorResource( UserID, 17 );
        sbMap.Append( this.getAreaStreing( "442,110,540,170", url, "客商商品类别维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 16 );
        sbMap.Append( this.getAreaStreing( "441,242,540,300", url, "客户可订类别维护" ) );
        return sbMap.ToString( );
    }

    /// <summary>
    /// 获取系统设置热点信息
    /// </summary>
    /// <returns></returns>
    protected string getSystemMap( )
    {
        StringBuilder sbMap = new StringBuilder( );
        string url = UIAdmResource.getOperatorResource( UserID, 127 );
        sbMap.Append( this.getAreaStreing( "20,27,113,82", url, "机构维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 129 );
        sbMap.Append( this.getAreaStreing( "180,27,273,82", url, "部门维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 500 );
        sbMap.Append( this.getAreaStreing( "320,27,413,82", url, "岗位维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 130 );
        sbMap.Append( this.getAreaStreing( "320,140,413,196", url, "员工维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 125 );
        sbMap.Append( this.getAreaStreing( "180,140,273,196", url, "用户维护" ) );

        url = UIAdmResource.getOperatorResource( UserID, 21 );
        sbMap.Append( this.getAreaStreing( "20,140,113,196", url, "角色维护" ) );

        return sbMap.ToString( );
    }

    #endregion
    
    private string getAreaStreing( string coords, string url, string alt )
    {
        if ( url.Length == 0 )
            return "";
        System.Text.StringBuilder area = new StringBuilder( );
        area.Append( "<area shape=\"" );
        if ( coords.Split( ',' ).Length > 4 )
        {
            area.Append( "poly" );
        }
        else
        {
            area.Append( "rect" );
        }
        area.Append( "\" coords=\"" );
        area.Append( coords );
        area.Append( "\" href=\"javascript:dosomething('" + alt + "','" + url + "');" );
        //area.Append(url);
        area.Append( "\" alt=\"" );
        area.Append( alt );
        area.Append( "\"/>\r\n" );
        return area.ToString( );
    }
}
