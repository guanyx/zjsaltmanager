using System;
using System.Collections;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class RPT_SCM_frmReportHtml : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "var excelName='导出报表.xls';\r\n" );
        script.Append( "</script>" );
        return script.ToString( );
    }

    protected void setReportType(ZJSIG.UIProcess.Report.ReportHtml reportHtml )
    {
        this.ddlReportType.Items.Clear( );
        if ( reportHtml.ReportStatype.IndexOf( "Day" ) != -1 )
        {
            this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
        }
        if ( reportHtml.ReportStatype.IndexOf( "Month" ) != -1 || reportHtml.ReportStatype =="")
        {
            this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
        }
        if ( reportHtml.ReportStatype.IndexOf( "Quarterly" ) != -1 || reportHtml.ReportStatype == "" )
        {
            this.ddlReportType.Items.Add( new ListItem( "季报", "3" ) );
        }
        if ( reportHtml.ReportStatype.IndexOf( "Year" ) != -1 || reportHtml.ReportStatype == "" )
        {
            this.ddlReportType.Items.Add( new ListItem( "年报", "4" ) );
        }

        if ( reportHtml.CanFilterCustomer.Split( ':' )[ 0 ] == "1" )
        {
        }
        if ( reportHtml.CanFilterProduct.Split( ':' )[ 0 ] == "1" )
        {
            this.txtProduct.Visible = true;
            this.lblProduct.Visible = true;
        }
        else
        {
            this.txtProduct.Visible = false;
            this.lblProduct.Visible = false;
        }
        if(reportHtml.CanOther.IndexOf("Wh:")==-1)
        {
            this.lblWhGroup.Visible = false;
            this.chbWhGroupBy.Visible = false;

            this.lblWh.Visible = false;
            this.txtWh.Visible = false;
        }
        if ( reportHtml.CanOther.IndexOf( "CusName" ) != -1 )
        {
            this.lblCustomerName.Visible = true;
            this.txtCustomerName.Visible = true;
        }
        if ( reportHtml.CanOther.IndexOf( "RouteId" ) != -1 )
        {
            this.lblRouteName.Visible = true;
            this.txtRouteName.Visible = true;
        }
        if ( reportHtml.IsBi == "1" )
        {
            this.chbFinanceDate.Checked = true;
            this.chbFinanceDate.Visible = false;
            this.lblFinanceDate.Visible = false;
        }
        //this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        if ( !this.IsPostBack )
        {
            ZJSIG.UIProcess.Report.ReportHtml report = new ZJSIG.UIProcess.Report.ReportHtml( );
            report.ReportId = long.Parse( this.Request.QueryString[ "ReportId" ] );
            setReportType( report );
            bindYearAndMonthList( );
            ddlReportType_SelectedIndexChanged( null, null );
            //btnSearchClick( null, null );

            bindOrgList( );
        }
        if ( this.reportType.Value != "" )
        {
            this.btnBack.Visible = true;
        }
        else
        {
            this.btnBack.Visible = false;
        }
    }

    protected void bindOrgList( )
    {
        if ( this.OrgID == 1 || this.ValidateControlActionRight( "allOrg" ) )
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
            //if ( OrgID == 1 )
            //{
            //    this.ddlOrg.Items.Insert( 0, new ListItem( "定点生产企业",
            //        ZJSIG.UIProcess.ADM.UIAdmOrg.getPointOrg( ) ) );
            //    this.ddlOrg.Items.Insert( 0, new ListItem( "销售型企业",
            //        ZJSIG.UIProcess.ADM.UIAdmOrg.getSaleOrg( ) ) );
            //}
        }
    }

    /// <summary>
    /// 绑定日期和时间
    /// </summary>
    protected void bindYearAndMonthList( )
    {
        for ( int i = 2008; i < DateTime.Today.Year + 10; i++ )
        {
            this.ddlYear.Items.Add( new ListItem( i.ToString( ) + "年", i.ToString( ) ) );
        }
        //this.ddlYear.SelectedIndex = DateTime.Today.Year - 2008;

        for ( int i = 1; i < 13; i++ )
        {
            this.ddlMonth.Items.Add( new ListItem( i.ToString( ) + "月", i.ToString( ) ) );
            this.ddlEndMonth.Items.Add( new ListItem( i.ToString( ) + "月", i.ToString( ) ) );
        }
        this.ddlYear.SelectedIndex = DateTime.Today.Year - 2008;
        this.ddlMonth.SelectedIndex = DateTime.Today.AddMonths( -1 ).Month;
        this.ddlEndMonth.SelectedIndex = DateTime.Today.AddMonths( -1 ).Month;

        this.ddlQ.Items.Add( new ListItem( "第一季度", "0" ) );
        this.ddlQ.Items.Add( new ListItem( "第二季度", "1" ) );
        this.ddlQ.Items.Add( new ListItem( "第三季度", "2" ) );
        this.ddlQ.Items.Add( new ListItem( "第四季度", "3" ) );
    }

    protected void ddlReportType_SelectedIndexChanged( object sender, EventArgs e )
    {
        this.txtEndDate.Visible = false;
        switch ( this.ddlReportType.SelectedValue )
        {
            case "1":
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = true;
                this.ddlEndMonth.Visible = true;
                this.ddlYear.Visible = true;
                this.ddlQ.Visible = false;
                break;
            case "2":
                this.txtEndDate.Visible = true;
                this.txtDate.Visible = true;
                this.ddlMonth.Visible = false;
                this.ddlEndMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlQ.Visible = false;
                break;
            //季报
            case "3":
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlEndMonth.Visible = false;
                this.ddlQ.Visible = true;
                this.ddlYear.Visible = true;
                break;
            //年报
            case "4":
                this.txtDate.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlEndMonth.Visible = false;
                this.ddlQ.Visible = false;
                this.ddlYear.Visible = true;
                break;
        }
    }

    //private 

    protected void btnCreateClick( object sender, EventArgs e )
    {
        string reportType = this.reportType.Value;
        long reportId = 0;
        long.TryParse( this.Request[ "ReportId" ], out reportId );
        DateTime dt = DateTime.Now;
        if ( this.txtDate.Visible )
        {
            if ( this.txtDate.Text.Trim( ) != "" )
            {
                dt = DateTime.Parse( this.txtDate.Text.Trim( ) );
            }
        }
        else if ( this.ddlMonth.Visible )
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

        ZJSIG.UIProcess.Report.ReportHtml html = new ZJSIG.UIProcess.Report.ReportHtml( );
        if ( reportType.Length > 0 )
        {
            html.ReportType = reportType;
        }
        else
        {
            html.ReportId = reportId;
        }
        ZJSIG.UIProcess.Common.IReport htmlReport = null;
        if ( html.IsBi=="1" )
        {
            htmlReport = new ZJSIG.UIProcess.BI.BIReport( );
        }
        else
        {
            htmlReport = new ZJSIG.UIProcess.Report.ReportHtml( );
        }

        //Assembly asm = Assembly.GetExecutingAssembly();   

        //Type t = typeof(ZJSIG.UIProcess.Report.ReportHtml);
        //t.
        
        //ZJSIG.UIProcess.Report.ReportHtml factory = new ZJSIG.UIProcess.Report.ReportHtml( );
        //factory.ReportId = reportId;
        //if ( htmlReport.IsBi == "1" )
        //{
        //    htmlReport = new ZJSIG.UIProcess.BI.BIReport( );
        //}
        //else
        //    htmlReport = new ZJSIG.UIProcess.Report.ReportHtml( );
        //ZJSIG.UIProcess.BI.BIReport 
        htmlReport.StartDate = dt;
        htmlReport.EndDate = getEndDate( dt );
        //htmlReport.OrgIds = this.OrgID.ToString( );
        htmlReport.OrgIds = this.ddlOrg.SelectedValue;
        if ( htmlReport.OrgIds == "0" )
            htmlReport.OrgIds = "";
        //htmlReport.OrgIds = "";
        
        htmlReport.OrgId = this.OrgID;
        htmlReport.OtherConditions = getOtherConditions( );
        if ( reportType.Length > 0 )
        {
            htmlReport.ReportType = reportType;
        }
        else
        {
            htmlReport.ReportId = reportId;
        }
        if ( chbFinanceDate.Visible )
        {
            htmlReport.FinanceDate = chbFinanceDate.Checked;
        }
        if ( html.IsBi == "1" )
        {
            htmlReport.FinanceDate = true;
        }
        if ( this.hiddenWh.Value.Length > 0 )
        {
            htmlReport.WhIds = this.hiddenWh.Value;
        }
        htmlReport.WhGroupBy = this.chbWhGroupBy.Checked;
        htmlReport.ProductType = this.hiddenProduct.Value;
        htmlReport.CustomerName = this.txtCustomerName.Text.Trim( );
        htmlReport.createReportFile( Server.MapPath( "rpt" ) );
        
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
        else if ( this.ddlMonth.Visible )
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

    private string getReportData( DateTime dt )
    {
        string reportType= this.reportType.Value;
        long reportId = 0;
        long.TryParse( this.Request[ "ReportId" ], out reportId );
        //ZJSIG.UIProcess.Report.ReportHtml htmlReport = new ZJSIG.UIProcess.Report.ReportHtml( );
        ZJSIG.UIProcess.Report.ReportHtml html = new ZJSIG.UIProcess.Report.ReportHtml( );
        if ( reportType.Length > 0 )
        {
            html.ReportType = reportType;
        }
        else
        {
            html.ReportId = reportId;
        }
        ZJSIG.UIProcess.Common.IReport htmlReport = null;
        if ( html.IsBi=="1" )
        {
            htmlReport = new ZJSIG.UIProcess.BI.BIReport( );
        }
        else
        {
            htmlReport = new ZJSIG.UIProcess.Report.ReportHtml( );
        }
        htmlReport.StartDate = dt;
        htmlReport.EndDate = getEndDate( dt );
        //htmlReport.OrgIds = this.OrgID.ToString( );
        htmlReport.OrgIds = this.ddlOrg.SelectedValue;
        if ( htmlReport.OrgIds == "0" )
            htmlReport.OrgIds = "";
        //htmlReport.OrgIds = "";
        htmlReport.OrgId = this.OrgID;
        htmlReport.OtherConditions = getOtherConditions( );
        if ( reportType.Length > 0 )
        {
            htmlReport.ReportType = reportType;
        }
        else
        {
            htmlReport.ReportId = reportId;            
        }
        if ( chbFinanceDate.Visible )
        {
            htmlReport.FinanceDate = chbFinanceDate.Checked;
        }
        if ( html.IsBi == "1" )
        {
            htmlReport.FinanceDate = true;
        }
        htmlReport.WhGroupBy = chbWhGroupBy.Checked;
        htmlReport.ProductType = this.hiddenProduct.Value;
        htmlReport.CustomerName = this.txtCustomerName.Text.Trim( );
        if ( this.txtRouteName.Visible )
        {
            htmlReport.RouteId = long.Parse( this.hidRouteId.Value );
        }
        if ( this.hiddenWh.Value.Length > 0 )
        {
            htmlReport.WhIds = this.hiddenWh.Value;
        }

        return htmlReport.getMulReport( Server.MapPath( "rpt" ) );
        //return htmlReport.createMulReport( );
    }

    protected List<ZJSIG.Common.DataSearchCondition.Condition> getOtherConditions( )
    {

        List<ZJSIG.Common.DataSearchCondition.Condition> conditions = new List<ZJSIG.Common.DataSearchCondition.Condition>( );
        try
        {
            string[ ] columns = this.Request.QueryString[ "FilterName" ].Split( '$' );
            string[ ] values = this.Request.QueryString[ "FilterValue" ].Split( '$' );
            ZJSIG.Common.DataSearchCondition.Condition condition = null;
            for ( int i = 0; i < columns.Length; i++ )
            {
                if ( columns[ i ].Length > 0 )
                {
                    if ( values[ i ].IndexOf( "," ) != -1 )
                    {
                        condition = new ZJSIG.Common.DataSearchCondition.Condition(
                            columns[ i ], values[ i ], ZJSIG.Common.DataSearchCondition.Condition.CompareType.SelectIn );
                        conditions.Add( condition );
                    }
                    else
                    {
                        condition = new ZJSIG.Common.DataSearchCondition.Condition(
                            columns[ i ], values[ i ], ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal );
                        conditions.Add( condition );
                    }

                }
            }
        }
        catch
        {
        }
        return conditions;
    }

    #region 报表导出
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
        oHtmlTextWriter.Write( htmlHeader + "<body>" + this.Session[ "OutString" ].ToString( ).Replace( "href='#'", "" ) + "</body></html>" );
        //this.DataBind.RenderControl(oHtmlTextWriter); 
        Response.Write( oStringWriter.ToString( ) );
        Response.End( );

    }

    protected string getDefaultExportFielName( )
    {
        return "报表";
    }
    #endregion

    protected DateTime getEndDate( DateTime dtStart )
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
            int startIndex = int.Parse( this.ddlMonth.SelectedValue );
            int endIndex = int.Parse( this.ddlEndMonth.SelectedValue );
            if ( endIndex < startIndex )
                endIndex = startIndex;
            return dtStart.AddMonths( endIndex-startIndex+1 );
        }
        //季报
        else if ( this.ddlQ.Visible )
        {
            return dtStart.AddMonths( 3 );
        }
        return dtStart.AddYears( 1 );
    }
}
