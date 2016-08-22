using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

using ZJSIG.Common.DataSearchCondition;
using ZJSIG.ADM.BLL;
/// <summary>
/// PageBase 
/// 所有页面都必须继承
/// 实现权限验证
/// </summary>
public class PageBase : System.Web.UI.Page
{
    public PageBase()
    {
        //
        //权限校验页面构造函数
        //
       
    }

    //重写Page基类的OnLoad事件方法
    protected override void OnLoad( EventArgs e )
    {
        //权限检查
        //checkPriv( );

        //检查用户是否已经登录
        //if (this.UserID <= 0)
        //{
        //    this.Response.Redirect("~/index.html");
        //}

        try
        {
            long id = this.UserID;
        }
        catch
        {
            if (this.Request.Headers.Get("x-requested-with") != null
                && this.Request.Headers.Get("x-requested-with").Equals(    //ajax超时处理     
                    "XMLHttpRequest", StringComparison.CurrentCultureIgnoreCase))
            {
                this.Response.AppendHeader("sessionstatus", "timeout");
            }
            else
            {//http超时的处理     
                throw new Exception("登录信息已过期，请重新登录");
            }
        }
        base.OnLoad( e );
    }

    private string Check_Priv_Failure_Url = "/";

    #region 基本操作

    /// <summary>
    /// 获取Query中的Action信息
    /// </summary>
    public string Action
    {
        get
        {
            return QueryString("action");
        }
    }

    public string QueryString(string queryName)
    {
        string query = this.Request.QueryString[queryName];
        if (query == null)
            query = "";
        return query;
    }
    #endregion

    #region 获取当前登录用户的基本信息

    public bool HaveLogin
    {
        get
        {
            if (UserID > 0)
                return true;
            return false;
        }
    }
    /// <summary>
    /// 获取当前登录的用户ID信息
    /// </summary>
    public long UserID
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.UserID(this) ;
        }
    }

    /// <summary>
    /// 获取当前登录的用户名信息
    /// </summary>
    public string UserName
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.UserName(this);
        }
    }

    /// <summary>
    /// 获取当前登录的员工ID信息
    /// </summary>
    public long EmployeeID
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeID(this);
        }
    }

    /// <summary>
    /// 获取当前登录的员工的客户ID信息（暂不能区分是供应商还是客商）
    /// </summary>
    public long CustomerId
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.CustomerId(this);
        }
    }

    /// <summary>
    /// 获取当前登录的部门ＩＤ信息
    /// </summary>
    public long DeptID
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.DeptID(this);
        }
    }

    /// <summary>
    /// 获取当前登录的机构ID信息
    /// </summary>
    public long OrgID
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this);
        }
    }

    /// <summary>
    /// 获取当前登录的机构ID信息
    /// </summary>
    public string OrgName
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.OrgName( this );
        }
    }

    /// <summary>
    /// 获取业务拥有者ID
    /// </summary>
    public long OwnerId
    {
        get
        {
            long ownerId =0;
            long.TryParse(this.Request["Owner"],out ownerId);
            if ( ownerId == 0 )
                return EmployeeID;
            return ownerId;
        }
    }

    public string EmpName
    {
        get
        {
            return ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeName(this);
        }
    }
    #endregion

    public bool ValidateControlActionRight(string actionName)
    {
        return ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, actionName);
    }

    public static string ToDataSetString(DataSet dsData)
    {
        System.IO.MemoryStream objStream = new System.IO.MemoryStream();
        dsData.WriteXml(objStream,XmlWriteMode.WriteSchema);
        System.Xml.XmlTextWriter objXmlWriter = new System.Xml.XmlTextWriter(objStream, System.Text.Encoding.UTF8);
        objStream = (System.IO.MemoryStream)objXmlWriter.BaseStream;

        System.Text.UTF8Encoding objEncoding = new System.Text.UTF8Encoding();

        return System.Web.HttpUtility.UrlEncode(objEncoding.GetString(objStream.ToArray()), System.Text.Encoding.GetEncoding("GB2312"));
    }


    #region 业务逻辑数据权限控制

    public DateTime CheckDate
    {
        get
        {
            return ZJSIG.UIProcess.UIProcessBase.CheckDate( this );
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                dt.DefaultView[ 0 ][ "CheckDate" ] = value;
            }
        }
    }

    /// <summary>
    /// 采购分割是否实行自动分割
    /// </summary>
    public bool AutoSplitPurch
    {
        get
        {
            return ZJSIG.UIProcess.UIProcessBase.AutoSplitPurch( this );
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "AutoSplitPurch" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "AutoSplitPurch" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 判断下销售订单的时候是否可以查看库存信息
    /// </summary>
    public  bool SaleCanSeeStore
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "SaleStore" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "SaleStore" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "SaleStore" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 判断销售的时候是否需要对仓库进行过滤
    /// </summary>
    public bool SaleStoreFilter
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "SaleConfig" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "SaleConfig" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "SaleConfig" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 判断是否需要对仓库进行作业时，人员是否需要仓库过滤？
    /// </summary>
    public bool StoreFilter
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "StoreConfig" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "StoreConfig" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "StoreConfig" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 设置营业报表是否需要合计数量
    /// </summary>
    public bool AutoSumqtyForSalerpt
    {

        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "AutoSumqtyForSalerpt" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "AutoSumqtyForSalerpt" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "AutoSumqtyForSalerpt" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    public bool CustomerServer
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "CustomerServer" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "CustomerServer" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "CustomerServer" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 启用lodop打印
    /// </summary>
    public bool LodopPrintOn
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( dt.DefaultView[ 0 ][ "LodopPrintOn" ].ToString( ) == "1" )
                    return true;
            }
            return false;
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( value )
                {
                    dt.DefaultView[ 0 ][ "LodopPrintOn" ] = 1;
                }
                else
                {
                    dt.DefaultView[ 0 ][ "LodopPrintOn" ] = 0;
                }
                Application[ "OrgConfig" ] = dt;
            }
        }
    }

    /// <summary>
    /// 启用个性化打印标题
    /// </summary>
    public string PrintTitle
    {
        get
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                return dt.DefaultView[ 0 ][ "PrintTitle" ].ToString( ) ;
            }
            return "";
        }
        set
        {
            DataTable dt = getConfigData( );
            dt.DefaultView.RowFilter = "OrgId=" + OrgID.ToString( );
            if ( dt.DefaultView.Count > 0 )
            {
                if ( !string.IsNullOrEmpty(value) )
                {
                    dt.DefaultView[ 0 ][ "PrintTitle" ] = value;
                    Application[ "OrgConfig" ] = dt;
                }
            }
        }
    }

    public void UpdateConfig( )
    {
        DataTable dt = getConfigData( );
        if ( dt.DataSet.HasChanges( ) )
        {
            if ( dt.PrimaryKey == null || dt.PrimaryKey.Length==0)
                dt.PrimaryKey = new DataColumn[ ] { dt.Columns[ "OrgId" ] };
            if ( dt.Columns.Contains( "SortIndexfieldalias" ) )
            {
                dt.Columns.Remove( "SortIndexfieldalias" );
            }
            dt.TableName = "AdmOrgConfig";
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dt.DataSet );
            dt.AcceptChanges( );
            Application[ "OrgConfig" ] = dt;
        }
    }
    private DataTable getConfigData()
    {
        DataTable dt = Application[ "OrgConfig" ] as DataTable;
        if ( dt == null )
        {
            QueryConditions query = new QueryConditions( );
            query.TableName = "AdmOrgConfig";
            DataSet dsOrgConfig = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
            dt = dsOrgConfig.Tables[ 0 ];
            dt.Columns.RemoveAt( dt.Columns.Count - 1 );
            Application[ "OrgConfig" ] = dsOrgConfig.Tables[ 0 ];
        }
        return dt;
    }
    #endregion
}
