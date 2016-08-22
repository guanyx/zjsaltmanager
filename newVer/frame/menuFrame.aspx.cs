using System;
using System.Collections;
using System.Collections.Generic;
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
using ZJSIG.UIProcess.ADM;

using ZJSIG.Common.DataSearchCondition;

public partial class frame_menuFrame : PageBase
{

    protected string soPoolPassWord( )
    {
        ZJSIG.ADM.BusinessEntities.AdmUser item= Session[ "LoginUser" ] as ZJSIG.ADM.BusinessEntities.AdmUser;
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        if ( item.UserPassword == "96e79218965eb72c92a549dd5a330112" )
        {
            script.Append( "var soPoolPass = true;\r\n" );
        }
        else
        {
            script.Append( "var soPoolPass = false;\r\n" );
        }

        script.AppendLine( "var sId = '" + this.Session.SessionID + "';" );
        script.Append( "</script>" );
        return script.ToString( );
    }

    public List<string[]> menus = new List<string[]>( );
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "savetouse":
                //检查是否已经存在
                QueryConditions query = new QueryConditions( );
                query.Condition.Add( new Condition( "EmpId", EmployeeID, Condition.CompareType.Equal ) );
                query.Condition.Add( new Condition( "ResourceId", this.Request[ "ResourceId" ], Condition.CompareType.Equal ) );
                query.TableName = "AdmEmpResource";
                if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query ) == 0 )
                {
                    DataTable dt = new DataTable( "AdmEmpResource" );
                    dt.Columns.Add( "EmpId", typeof( System.Int32 ) );
                    dt.Columns.Add( "ResourceId", typeof( System.Int32 ) );
                    dt.PrimaryKey = new DataColumn[ ] { dt.Columns[ "EmpId" ], dt.Columns[ "ResourceId" ] };
                    DataRow dr = dt.NewRow( );
                    dr[ "EmpId" ] = EmployeeID;
                    dr[ "ResourceId" ] = this.Request[ "ResourceId" ];
                    dt.Rows.Add( dr );
                    DataSet ds = new DataSet( );
                    ds.Tables.Add( dt );
                    ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
                }
                ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
                message.success = true;
                this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson( message ) );
                this.Response.End( );
                break;
            case "deluseresource":
                long delId = long.Parse( this.Request[ "ResourceId" ] );
                delId = delId - 50000;
                QueryConditions query1 = new QueryConditions( );
                query1.Condition.Add( new Condition( "EmpId", EmployeeID, Condition.CompareType.Equal ) );
                query1.Condition.Add( new Condition( "ResourceId", delId, Condition.CompareType.Equal ) );
                query1.TableName = "AdmEmpResource";
                if ( ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query1 ) > 0 )
                {
                    DataTable dt = new DataTable( "AdmEmpResource" );
                    dt.Columns.Add( "EmpId", typeof( System.Int32 ) );
                    dt.Columns.Add( "ResourceId", typeof( System.Int32 ) );
                    dt.PrimaryKey = new DataColumn[ ] { dt.Columns[ "EmpId" ], dt.Columns[ "ResourceId" ] };
                    DataRow dr = dt.NewRow( );
                    dr[ "EmpId" ] = EmployeeID;
                    dr[ "ResourceId" ] = delId;
                    dt.Rows.Add( dr );
                    DataSet ds = new DataSet( );
                    ds.Tables.Add( dt );
                    ds.AcceptChanges( );
                    ds.Tables[ 0 ].Rows[ 0 ].Delete( );
                    ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( ds );
                }
                //ZJSIG.UIProcess.UIMessageBase message1 = new ZJSIG.UIProcess.UIMessageBase( );
                //message1.success = true;
                //this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson( message1 ) );
                this.Response.End( );
                break;
            default:
                getMenus( );
                break;
        }
    }

    /**
     *获取菜单 
     */
    private void getMenus()
    {  
        //(id, pid, name, url, title, target, icon, iconOpen, open)

        //通过权限从后台去组装数据
        menus = UIAdmResource.getResourceMenuList( this );    
        
        /*
        menus.Add( new string[9] { "1", "0", "基础档案", "example01.html", "", "contentFrme", "", "", "" } );
        menus.Add( new string[9] { "2", "0", "客户管理", "CRM/customer/customerManage.aspx", "", "", "", "", "" } );
        menus.Add( new string[9] { "3", "1", "存货档案", "example01.html", "", "contentFrme", "", "", "" } );
        menus.Add( new string[9] { "4", "0", "配送管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "5", "3", "价格管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "6", "5", "商品价格管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "7", "0", "仓库管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "8", "1", "客户经理管理", "example01.html", "", "", "", "", "" } );
        /*特殊制定打开的图片，包括* /
        menus.Add( new string[9] { "9", "0", "My Pictures", "example01.html", "Pictures I\'ve taken over the years", "", "", "../images/tree_pic/imgfolder.gif", "" } );
        /*使用默认target配置* /
        menus.Add( new string[9] { "10", "9", "The trip to Iceland", "example01.html", "Pictures of Gullfoss and Geysir", "", "", "", "" } );
        menus.Add( new string[9] { "11", "0", "用户管理", "BA/sysadmin/userManager.aspx", "", "", "", "", "" } );
        menus.Add( new string[9] { "12", "0", "Recycle Bin", "example01.html", "Pictures of Gullfoss and Geysir", "", "", "../images/tree_pic/trash.gif", "" } );
        */
    }
}
