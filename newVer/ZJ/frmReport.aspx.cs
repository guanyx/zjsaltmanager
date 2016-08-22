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
using System.Xml.Linq;

public partial class RPT_SCM_frmReport : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "var excelName='" + this.getMBName( ) + "';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        if ( !IsPostBack )
        {
            //this.ddlStore.AutoPostBack = false;
                bindYearAndMonthList( );
                btnBindReportType( );
                bindOrgList( );
         }
    }

    protected void btnBindReportType( )
    {
        string reportType = this.Request.QueryString[ "ReportType" ];
        //this.txtReportType.Visible = false;
        this.ddlReportType.Items.Add( new ListItem( "年报", "4" ) );
        this.ddlReportType.Items.Add( new ListItem( "季报", "3" ) );
        this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
        this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
        this.ddlReportType.SelectedValue = "1";
        this.txtDate.Visible = false;
        this.btnBack.Visible = true;

        ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "ParentsCode", "Q09", ZJSIG.Common.DataSearchCondition.Condition.CompareType.BeginWith ) );
        query.TableName = "SysDicsInfo";
        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 20, 0, query, "" );
        foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
        {
            this.ddlCheckType.Items.Add( new ListItem( dr[ "DicsName" ].ToString( ), dr[ "DicsCode" ].ToString( ) ) );
        }
    }


    protected void bindOrgList( )
    {
        if (this.OrgID==1|| this.ValidateControlActionRight( "allOrg" ) )
        {
            System.Data.DataSet ds = ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgData( this );
            //ds.Tables[ 0 ].DefaultView.Sort = "OrgCode";
            this.ddlOrg.DataSource = ds.Tables[ 0 ].DefaultView;
            this.ddlOrg.DataTextField = "OrgShortName";
            this.ddlOrg.DataValueField = "OrgId";
            this.ddlOrg.DataBind( );
            this.ddlOrg.Visible = true;
            this.lblOrg.Visible = true;

            //添加定点企业和销售型企业类别信息
            if ( OrgID == 1 )
            {
                this.ddlOrg.Items.Insert( 0, new ListItem( "定点生产企业",
                    ZJSIG.UIProcess.ADM.UIAdmOrg.getPointOrg( )
                    + ",108"));//质检子系统宁波要求将晶泰108分开，他们单独登录晶泰帐号进行登记 jianggl 2013-03-01
                this.ddlOrg.Items.Insert( 0, new ListItem( "销售型企业",
                    ZJSIG.UIProcess.ADM.UIAdmOrg.getSaleOrg( ) ) );
            }
        }
    }

    /// <summary>
    /// 从江来配置的报表存货分类与组织对应关系表中获取
    /// added by Jianggl 2011-4-5
    /// </summary>
    /// <param name="productType">报表存货分类编号</param>
    protected void bindOrgByProductTypeList(string productType)
    {
        if (this.OrgID == 1 || this.ValidateControlActionRight("allOrg"))
        {
            System.Data.DataSet ds = ZJSIG.UIProcess.BA.UIBaReportTypeOrg.getOrgData(this,productType);
             this.ddlOrg.DataSource = ds.Tables[0].DefaultView;
            this.ddlOrg.DataTextField = "OrgShortName";
            this.ddlOrg.DataValueField = "OrgId";
            this.ddlOrg.DataBind();
            this.ddlOrg.Visible = true;
            this.lblOrg.Visible = true;
        }
    }
   

    
    

    
    protected void btnSearchClick( object sender, EventArgs e )
    {
        DateTime dt = DateTime.Now;
        if ( this.txtDate.Visible )
        {
            if ( this.txtDate.Text.Trim( ) != "" )
            {
                dt = DateTime.Parse( this.txtDate.Text.Trim( ) );
            }
        }
        else if(this.ddlMonth.Visible)
        {
            dt = new DateTime( int.Parse( this.ddlYear.Text ), int.Parse( this.ddlMonth.SelectedValue ), 1 );
        }
        else if ( this.ddlQ.Visible )
        {
            dt = new DateTime( int.Parse( this.ddlYear.SelectedValue ), int.Parse( this.ddlQ.SelectedValue ) * 3 + 1, 1 );
        }
        else
        {
            dt = new DateTime( int.Parse( this.ddlYear.SelectedValue ), 1, 1 );
        }
        this.Session[ "OutString" ] = this.getReportData( dt );

        this.divBoxing.Controls.Clear( );
        this.divBoxing.Controls.Add( new LiteralControl( this.Session[ "OutString" ].ToString( ) ) );
    }

    protected DateTime getEndDate(DateTime dtStart )
    {
        //日报
        if ( this.txtDate.Visible )
        {
            if ( this.txtEndDate.Visible )
            {
                if ( this.txtEndDate.Text.Trim( ).Length > 0 )
                {
                    DateTime dtEnd = DateTime.Parse( this.txtEndDate.Text.Trim( ) );
                    return dtEnd.AddDays( 1 );
                }
            }
            return dtStart.AddDays( 1 );
        }
            //月报
        else if ( this.ddlMonth.Visible )
        {
            return dtStart.AddMonths( 1 );
        }
            //季报
        else if ( this.ddlQ.Visible )
        {
            return dtStart.AddMonths( 3 );
        }
        return dtStart.AddYears( 1 );
    }


    private string getReportData( DateTime dt )
    {
        ZJSIG.UIProcess.Report.QtReport report = new ZJSIG.UIProcess.Report.QtReport( );
        report.reportType = "Salt";
        report.StartDate = dt;
        report.EndDate = getEndDate( dt );
        if ( this.ddlOrg.Visible)
        {
            if(this.ddlOrg.SelectedValue=="0")
                report.OrgIds = "";//为了配合后台逻辑，如果全省数据那么将0变成空 jianggl 2013-03-01
            else
                report.OrgIds = this.ddlOrg.SelectedValue;
        }
        else
        {
            report.OrgIds = this.OrgID.ToString( );
        }
        report.CheckType = this.ddlCheckType.SelectedValue;
        report.ShowOrg = this.chbOrg.Checked;
        return report.createReport( );
        return "";
    }

    /// <summary>
    /// 绑定日期和时间
    /// </summary>
    protected void bindYearAndMonthList( )
    {
        for ( int i = 2008; i < DateTime.Today.Year + 10; i++ )
        {
            this.ddlYear.Items.Add( new ListItem(i.ToString()+"年",i.ToString()));
        }
        //this.ddlYear.SelectedIndex = DateTime.Today.Year - 2008;

        for ( int i = 1; i < 13; i++ )
        {
            this.ddlMonth.Items.Add( new ListItem(i.ToString()+"月",i.ToString( ) ));
        }
        this.ddlYear.SelectedIndex = DateTime.Today.Year - 2008;
        this.ddlMonth.SelectedIndex = DateTime.Today.AddMonths( -1 ).Month;

        this.ddlQ.Items.Add( new ListItem( "第一季度", "0" ) );
        this.ddlQ.Items.Add( new ListItem( "第二季度", "1" ) );
        this.ddlQ.Items.Add( new ListItem( "第三季度", "2" ) );
        this.ddlQ.Items.Add( new ListItem( "第四季度", "3" ) );
    }

    protected void btnExport_Click( object sender, EventArgs e )
    {
        Response.AppendHeader( "Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode( this.getDefaultExportFielName( ), System.Text.Encoding.UTF8 ) + ".xls" );
        Response.ContentEncoding = System.Text.Encoding.GetEncoding( "utf-8" );


        //Response.ContentType指定文件類型 可以為application/ms-excel,application/ms-word ,application/ms-txt,application/ms-html或其他瀏覽器可直接支持文檔　 
        Response.ContentType = "application/ms-excel";

        System.IO.StringWriter oStringWriter = new System.IO.StringWriter( );
        System.Web.UI.HtmlTextWriter oHtmlTextWriter = new System.Web.UI.HtmlTextWriter( oStringWriter );

        //將目標數據綁定到輸入流輸出　　 
        //this 表示輸出本頁，你也可以綁定datagrid,或其他支持obj.RenderControl()屬性的控件　
        string htmlHeader = "<html xmlns:o=\"urn:schemas-microsoft-com:office:office\"\r\n xmlns:x=\"urn:schemas-microsoft-com:office:excel\"\r\n xmlns=\"http://www.w3.org/TR/REC-html40\">";
        oHtmlTextWriter.Write( htmlHeader + "<body>" + this.Session[ "OutString" ].ToString( ).Replace("href='#'","") + "</body></html>" );
        //this.DataBind.RenderControl(oHtmlTextWriter); 
        Response.Write( oStringWriter.ToString( ) );
        Response.End( );

    }

    protected string getDefaultExportFielName( )
    {
        string reportType = this.Request.QueryString[ "ReportType" ];
        switch ( reportType )
        {
            case "xsbill":
            case "xs":
                return "销售报表";
            case "ck":
                return "仓库报表";
            case "jxc":
                return "进销存报表";
                break;
            case "factory":
                return "生产企业报表";
            case "org":
                return "各地区计划完成表";
        }
        return "报表";
    }
    protected void ddlReportType_SelectedIndexChanged( object sender, EventArgs e )
    {
        this.txtEndDate.Visible = false;
        switch ( this.ddlReportType.SelectedValue )
        {
            case"1":                
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = true;
                this.ddlYear.Visible = true;
                this.ddlQ.Visible = false;
                break;
            case"2":
                if ( this.Request.QueryString[ "ReportType" ] != "yxwt")
                {
                    this.txtEndDate.Visible = true;
                }
                this.txtDate.Visible = true;
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlQ.Visible = false;
                break;
                //季报
            case"3":
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlQ.Visible = true;
                this.ddlYear.Visible = true;
                break;
                //年报
            case"4":
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlQ.Visible = false;
                this.ddlYear.Visible = true;
                break;
        }
    }
    protected void ddlOrg_SelectedIndexChanged( object sender, EventArgs e )
    {
        //bindStore( );
    }

    #region 获取模板文件

    private string getMBName( )
    {
        string reportType = this.Request.QueryString[ "ReportType" ];
        string[ ] strs = this.reportType.Value.Split( ':' );
        switch ( reportType )
        {
            case"xsbill":
            case "xs":
                switch ( strs[ 0 ] )
                {
                    case "product":
                        return "xs1";
                    case "customer":
                        return "xs2";
                    case "bank":
                        return "xs3";
                    case "paytype":
                        return "xs3";
                    default:
                        return "xs";
                }
            case "ZB":
            case "SC":
                switch ( strs[ 0 ] )
                {
                    case "product":
                        break;
                    case "orgId":
                        break;
                    default:
                        break;
                }
                break;
            case "pmsdayreport":
                break;
            case "dayreport":
                break;
            case "trans":
                switch ( strs[ 0 ] )
                {
                    case "province":
                        break;
                    case "supplier":
                        break;
                    default:
                        break;
                }
                break;
            case "ck":
                switch ( strs[ 0 ] )
                {
                    case "product":
                        return "ck1.xls";
                    default:
                        return "ck.xls";
                }
                break;
            case "saltworks":
                break;
            case "saltprocessing":
                break;
            case "yuanyan":
                switch ( strs[ 0 ] )
                {
                    case "OrgId":
                        break;
                    default:
                        break;
                }
                break;
            case "yxwt":
                switch ( strs[ 0 ] )
                {
                    case "NoOut":
                    case "NoSale":
                        return "yxwt1.xls";
                    default:
                        return "yxwt.xls";
                }
                break;
            case "jxc":
                switch ( strs[ 0 ] )
                {
                    case "org":
                        break;
                    case "operType":
                        break;
                    case "product":
                        break;
                    default:
                        break;
                }
                break;
            case "org":
                switch ( strs[ 0 ] )
                {
                    case "orgId":
                        break;
                    default:
                        break;
                }
                break;
            case "factory":
                //switch ( types[ 0 ] )
                //{
                //    case "Supplier":
                //        break;
                //    default:
                //        break;
                //}

                break;
            case "sell":
                switch ( strs[ 0 ] )
                {
                    case "product":
                        break;
                    case "org":
                        break;
                    default:
                        break;
                }
                break;
            //供应商调运情况
            case "purchsalt":
                switch ( strs[ 0 ] )
                {
                    case "transtype":
                        break;
                    default:
                        break;
                }
                break;
        }
        return "row4.xls";
    }

    #endregion
}
