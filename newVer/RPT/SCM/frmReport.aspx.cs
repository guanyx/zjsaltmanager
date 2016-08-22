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
            this.ddlStore.AutoPostBack = false;
                bindYearAndMonthList( );
                btnBindReportType( );
         }
    }

    protected void btnBindReportType( )
    {
        string reportType = this.Request.QueryString[ "ReportType" ];
        this.txtReportType.Visible = false;
        switch ( reportType )
        {
            case"smallreport":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                lblStore.Visible = false;

                //this.txtProduct.Text = "盐类";
                //this.hiddenProduct.Value = "type1!盐类!1";
                //bindStore( );
                //bindOrgList( );
                pnlProduct.Visible = false;
                //bindReportType( reportType );
                break;
            case"xsbill":
                //this.ddlReportType.Visible = false;
                //this.lblReportType.Visible = false;
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.lblStore.Visible = true;
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                //bindStore( );
                bindOrgList( );
                bindDeptList( );
                pnlProduct.Visible = true;
                this.lblStore.Visible = false;
                this.ddlStore.Visible = false;
                break;
            case"xs":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                //this.ddlReportType.Visible = false;
                //this.lblReportType.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.lblStore.Visible = true;
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                bindStore( );
                bindOrgList( );
                pnlProduct.Visible = true;
                this.txtRouteName.Visible = true;
                this.lblRoute.Visible = true;
                break;
            case"dayreport":
                //this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                lblStore.Visible = false;
                //bindStore( );
                bindOrgList( );
                pnlProduct.Visible = false;
                this.ddlOrg.AutoPostBack = false;
                break;
            case "pmsdayreport":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );

                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                lblStore.Visible = false;
                //bindStore( );
                bindOrgList( );
                pnlProduct.Visible = false;
                this.ddlOrg.AutoPostBack = false;
                break;
            case"trans":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                lblStore.Visible = false;

                this.txtProduct.Text = "盐类";
                this.hiddenProduct.Value = "type1!盐类!1";
                //bindStore( );
                //bindOrgList( );
                pnlProduct.Visible = true;
                bindReportType( reportType );
                break;
                break;
            case"ck":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                //lblStore.Visible = true;
                bindStore( );
                bindOrgList( );
                pnlProduct.Visible = true;
                bindReportType( reportType );
                this.txtReportType.Visible = true;
                this.lblSaleUnit.Visible = true;
                this.chbSaleUnit.Visible = true;
                break;
            case "jtck":
                this.ddlReportType.Items.Add(new ListItem("日报", "2"));
                this.ddlReportType.Items.Add(new ListItem("月报", "1"));
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                //lblStore.Visible = true;
                //bindStore();
                //bindOrgList();
                //pnlProduct.Visible = true;
                bindReportType(reportType);                
                break;
            case"ZB":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "3";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                //lblStore.Visible = true;
                bindStore( );
                break;
            case"SC":
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add(new ListItem("月报","1"));
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "2";
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                this.ddlStore.Visible = true;
                this.ddlUnit.Visible = false;
                this.txtEndDate.Visible = true;
                this.btnBack.Visible = true;
                //lblStore.Visible = true;
                bindStore( );                
                //bindOrgList( );
                break;
            case"yxwt":
                this.ddlReportType.Visible = false;
                this.lblReportType.Visible = false;
                this.ddlMonth.Visible = false;
                this.ddlYear.Visible = false;
                //this.ddlStore.Visible = false;
                //this.lblStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                this.txtDate.Visible = true;
                this.lblStatDate.Visible = true;
                bindOrgList( );
                bindStore( );
                this.ddlOrg.AutoPostBack = false;
                pnlProduct.Visible = true;
                break;
            case"saltworks":
                this.ddlReportType.Visible = false;
                this.lblReportType.Visible = false;
                this.ddlMonth.Visible = true;
                this.ddlYear.Visible = true;
                this.ddlStore.Visible = false;
                this.lblStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                this.txtDate.Visible = false;
                this.lblStatDate.Visible = false;
                bindOrgList( );
                break;
            case"jxc":
                this.ddlReportType.Items.Add( new ListItem( "年报", "4" ) );
                this.ddlReportType.Items.Add( new ListItem( "季报", "3" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.SelectedValue = "1";
                this.txtDate.Visible = false;
                this.btnBack.Visible = true;
                bindReportType( reportType );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                break;
            case"org":
            case"factory":
                this.lblReportType.Visible = false;
                this.ddlReportType.Visible = false;
                this.txtDate.Visible = false;
                this.ddlStore.Visible = false;
                this.lblStore.Visible = false;
                this.ddlQ.Visible = false;
                this.btnBack.Visible = true;
                bindUnit( );
                break;
            case"sell":
                this.ddlReportType.Items.Add( new ListItem( "年报", "4" ) );
                this.ddlReportType.Items.Add( new ListItem( "季报", "3" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.SelectedValue = "1";
                this.txtDate.Visible = false;
                this.btnBack.Visible = true;
                bindReportType( reportType );
                break;
                //原盐产量统计表
            case"saltwork":
            case"saltprocessing":
            case"yuanyan":
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.lblUnit.Visible = false;
                this.ddlReportType.SelectedValue = "1";
                this.ddlMonth.Visible = true;
                this.ddlYear.Visible = true;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtDate.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                this.lblStore.Visible = false;
                break;
            case"mainreport":
            case "saltpurch":
                //this.ddlReportType.Items.Add( new ListItem( "日报", "2" ) );
                this.ddlReportType.Items.Add( new ListItem( "月报", "1" ) );
                this.ddlUnit.Visible = false;
                this.ddlReportType.SelectedValue = "1";
                this.ddlMonth.Visible = true;
                this.ddlYear.Visible = true;
                this.ddlStore.Visible = false;
                this.ddlUnit.Visible = false;
                this.txtDate.Visible = false;
                this.txtEndDate.Visible = false;
                this.btnBack.Visible = true;
                this.lblStore.Visible = false;
                lblStore.Visible = false;
                pnlProduct.Visible = true;
                bindReportType( reportType );
                bindOrgList( );
                break;
        }
    }



    protected void bindDeptList( )
    {
        this.txtWh.Visible = true;
        this.lblWh.Visible = true;
        //DataTable dt = ZJSIG.UIProcess.ADM.UIAdmDept.getSaleDeptData( this );
        //this.ddlDept.DataSource = dt;
        //this.ddlDept.DataTextField = "DeptName";
        //this.ddlDept.DataValueField = "DeptIds";
        //this.ddlDept.DataBind( );
        //this.ddlDept.Visible = true;

        //this.ddlDept.Items.Insert( 0, new ListItem( "全部", "" ) );
        //this.lblDept.Visible = true;

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
                    ZJSIG.UIProcess.ADM.UIAdmOrg.getPointOrg( ) ) );
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

    private DataSet getReportTypeData()
    {
        DataSet ds = new DataSet( );
        ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "ClassNo", "010", ZJSIG.Common.DataSearchCondition.Condition.CompareType.BeginWith ) );
        query.TableName = "BaReportType";
        ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( int.MaxValue, 0, query, "Class_No" );
        foreach ( DataRow dr in ds.Tables[0].Rows )
        {
            //if ( dr[ "ClasssNo" ].ToString( ).Length == 2 )
            //{
            //    dr.Delete( );
            //    continue;
            //}

            int length = dr[ "ClassNo" ].ToString( ).Length / 2 - 2;
            for ( int i = 0; i < length; i++ )
            {
                dr[ "ClassName" ] = "--" + dr[ "ClassName" ].ToString( );
            }
        }
        return ds;
    }
    protected void bindReportType(string reportType )
    {
        DataSet ds = new DataSet( );
        
        ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        switch ( reportType )
        {
            case "jtck": //集团公司的仓库进出报表
                ds = getReportTypeData();
                this.ddlStore.DataSource = ds.Tables[0].DefaultView;
                this.ddlStore.DataTextField = "ClassName";
                this.ddlStore.DataValueField = "ClassId";
                this.ddlStore.DataBind();
                this.lblStore.Text = "统计项目";
                this.ddlStore.AutoPostBack = true;
                //this.ddlStore.SelectedIndexChanged += new EventHandler( bindUnitEvent );
                bindOrgByProductTypeList(this.ddlStore.SelectedValue);//根据选择类别重新刷新前面的组织列表
                break;
            case "jxc":
                //query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "ParentClassId", 1, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                //query.TableName = "BaReportType";
                //ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
                //ds.Tables[ 0 ].DefaultView.Sort = "ClassId";
                ds = getReportTypeData( );
                this.ddlStore.DataSource = ds.Tables[ 0 ].DefaultView;
                this.ddlStore.DataTextField = "ClassName";
                this.ddlStore.DataValueField = "ClassId";
                this.ddlStore.DataBind( );
                this.lblStore.Text = "统计项目";
                this.ddlStore.AutoPostBack = true;
                //this.ddlStore.SelectedIndexChanged += new EventHandler( bindUnitEvent );
                bindUnit( );
                break;
            case "sell":
                //query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "ParentClassId", 1, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                //query.TableName = "BaReportType";
                //ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
                //ds.Tables[ 0 ].DefaultView.Sort = "ClassId";
                ds = getReportTypeData( );
                this.ddlStore.DataSource = ds.Tables[ 0 ].DefaultView;
                this.ddlStore.DataTextField = "ClassName";
                this.ddlStore.DataValueField = "ClassId";
                this.ddlStore.DataBind( );
                this.lblStore.Text = "统计项目";
                this.ddlStore.AutoPostBack = true;
                //this.ddlStore.SelectedIndexChanged += new EventHandler( bindUnitEvent );
                bindUnit( );
                break;

        }
    }

    protected void bindUnitEvent( object sender, EventArgs e )
    {
        bindUnit( );
    }
    protected void bindUnit( )
    {
        string reportType = this.Request.QueryString[ "ReportType" ];
        if (reportType == "jtck")
        {
            //根据选择的项目更新组织列表
            bindOrgByProductTypeList(this.ddlStore.SelectedValue);
            this.reportType.Value = "";
            return;
        }
        else if ( reportType == "sell" )
        {
            this.ddlUnit.Items.Clear( );
            this.ddlUnit.Items.Add( new ListItem( "万元", "10000" ) );
            this.ddlUnit.Items.Add( new ListItem( "元", "1" ) );
        }
        else
        {
            if (this.ddlStore.Visible)
            {
                DataSet ds = ZJSIG.UIProcess.BA.UIBaReportType.dsGetSameUnit(long.Parse(this.ddlStore.SelectedValue));
                this.ddlUnit.DataTextField = "UnitName";
                this.ddlUnit.DataValueField = "UnitId";
                this.ddlUnit.DataSource = ds.Tables[0].DefaultView;
                this.ddlUnit.DataBind();
            }
            else
            {
                this.ddlUnit.Items.Add(new ListItem("吨", "3"));
                this.ddlUnit.Items.Add(new ListItem("公斤", "8"));
            }
        }
        this.ddlUnit.Visible = true;
    }
    protected void bindStore( )
    {
        ZJSIG.Common.DataSearchCondition.QueryConditions query = null;
        if ( this.ddlStore.Visible )
        {
            switch ( this.Request.QueryString[ "ReportType" ] )
            {
                case"ZB":
                    query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
                    query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "WhType", "02", ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                    query.TableName = "WmsWarehouse";
                    query.Columns = "Wh_ID,WH_Name";
                    DataSet dsWhZB = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( int.MaxValue, 0, query, "" );
                    this.ddlStore.DataSource = dsWhZB.Tables[ 0 ].DefaultView;
                    this.ddlStore.DataTextField = "WhName";
                    this.ddlStore.DataValueField = "WhId";
                    this.ddlStore.DataBind( );
                    this.ddlStore.Items.Insert( 0, new ListItem( "全部", "0" ) );
                    break;
                case"SC":
                    query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
                    query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "WhType", "03", ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                    query.TableName = "WmsWarehouse";
                    query.Columns = "Wh_ID,WH_Name";
                    DataSet dsWhSC = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( int.MaxValue, 0, query, "" );
                    this.ddlStore.DataSource = dsWhSC.Tables[ 0 ].DefaultView;
                    this.ddlStore.DataTextField = "WhName";
                    this.ddlStore.DataValueField = "WhId";
                    this.ddlStore.DataBind( );
                    this.ddlStore.Items.Insert( 0, new ListItem( "全部", "0" ) );
                    break;
                case "jtck":
                    break;
                default:
                    DataSet ds = ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseDataByEmpId( this );
                    string allWhId = "0";
                    if ( ds.Tables[ 0 ].Rows.Count == 0 )
                    {
                        long orgId = this.OrgID;
                        if ( this.ddlOrg.Visible )
                        {
                            long.TryParse( this.ddlOrg.SelectedValue, out orgId );
                        }
                        ds = ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListByOrgId( orgId );
                    }
                    else
                    {
                        allWhId = "";
                        foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                        {
                            if ( allWhId.Length > 0 )
                            {
                                allWhId += ",";
                            }
                            allWhId += dr[ "WhId" ].ToString( );
                        }
                    }
                    this.ddlStore.DataSource = ds.Tables[ 0 ].DefaultView;
                    this.ddlStore.DataTextField = "WhName";
                    this.ddlStore.DataValueField = "WhId";
                    this.ddlStore.DataBind( );
                    this.ddlStore.Items.Insert( 0, new ListItem( "全部", allWhId ) );
                    break;
            }
            
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
        string reportType = this.Request.QueryString[ "ReportType" ];
        string[ ] strs = this.reportType.Value.Split( ':' );
        switch ( reportType )
        {
            case"saltwork":
                ZJSIG.UIProcess.Report.IReport saltWork = new ZJSIG.UIProcess.Report.SaltWorkUpReport( );
                saltWork.StartDate = dt;
                saltWork.EndDate = getEndDate( dt );
                saltWork.ReportType = this.reportType.Value;
                string saltHtml = saltWork.createReport( );
                divBoxing.Width = saltWork.Width;
                return saltHtml;
            case"xsbill":
                long orgIdBill = this.OrgID;
                string selectedOrg = "";
                if ( this.ddlOrg.Visible )
                {
                    if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                    {
                        selectedOrg = this.ddlOrg.SelectedValue;
                        orgIdBill = 0;
                    }
                    else
                    {
                        long.TryParse( this.ddlOrg.SelectedValue, out orgIdBill );
                    }
                }

                //long.TryParse( this.ddlOrg.SelectedValue, out orgId );
                ZJSIG.UIProcess.Report.SaleBillDayReport saleBill = new ZJSIG.UIProcess.Report.SaleBillDayReport( orgIdBill, dt, this.getEndDate( dt ) );
                saleBill.IsSmall = this.chbClass.Checked;
                saleBill.orgIds = selectedOrg;
                saleBill.DeptId = this.ddlDept.SelectedValue;
                saleBill.DeptId = this.hiddenWh.Value;
                saleBill.productType = this.hiddenProduct.Value;
                //设置选择的仓库信息
                //saleBill.WhId = long.Parse( this.ddlStore.SelectedValue );
                string scriptBill = "";

                if ( this.ddlReportType.SelectedValue != "2" )
                {
                    saleBill.FinanceDate = true;
                }
                //sale.                
                switch ( strs[ 0 ] )
                {
                    case "product":
                        scriptBill = saleBill.createSaleProductReport( long.Parse( strs[ 1 ] ) );
                        this.divBoxing.Width = saleBill.Width;
                        return scriptBill;
                    case "customer":
                        scriptBill = saleBill.createSaleCustomerReport( long.Parse( strs[ 1 ] ) );
                        this.divBoxing.Width = saleBill.Width;
                        return scriptBill;
                    case "bank":
                        scriptBill = saleBill.createBankReport( );
                        this.divBoxing.Width = saleBill.Width;
                        return scriptBill;
                    case "paytype":
                        scriptBill = saleBill.createBankListByPayType( strs[ 1 ] );
                        this.divBoxing.Width = saleBill.Width;
                        return scriptBill;
                    default:
                        scriptBill = saleBill.createSaleDayReport( );
                        this.divBoxing.Width = saleBill.Width;
                        return scriptBill;
                }
                try
                {
                    return saleBill.createSaleDayReport( );
                }
                catch
                {
                    return "";
                }
                break;
            case"xs":
                long orgId = this.OrgID;
                string orgIds = "";
                if ( this.ddlOrg.Visible )
                {
                    if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                    {
                        orgIds = this.ddlOrg.SelectedValue;
                        orgId = 0;
                    }
                    else
                    {
                        long.TryParse( this.ddlOrg.SelectedValue, out orgId );
                    }
                }
                //long.TryParse( this.ddlOrg.SelectedValue, out orgId );
                ZJSIG.UIProcess.Report.SaleDayReport sale = new ZJSIG.UIProcess.Report.SaleDayReport( orgId, dt, this.getEndDate( dt ) );
                sale.IsSmall = this.chbClass.Checked;
                sale.orgIds = orgIds;
                
                sale.productType = this.hiddenProduct.Value;
                //设置选择的仓库信息
                sale.WhId = this.ddlStore.SelectedValue ;
                if ( this.ddlStore.SelectedValue == "0" )
                    sale.WhId = "";
                string script = "";
                sale.RouteIds = this.hiddenRoute.Value;
                if ( this.ddlReportType.SelectedValue != "2" )
                {
                    sale.FinanceDate = true;
                }
                //sale.                
                switch ( strs[ 0 ] )
                {
                    case "product":
                        script = sale.createSaleProductReport( long.Parse( strs[ 1 ] ) );
                        this.divBoxing.Width = sale.Width;
                        return script;
                    case"customer":
                        script= sale.createSaleCustomerReport( long.Parse( strs[ 1 ] ) );
                        this.divBoxing.Width = sale.Width;
                        return script;
                    case"bank":
                        script = sale.createBankReport( );
                        this.divBoxing.Width = sale.Width;
                        return script;
                    case"paytype":
                        script = sale.createBankListByPayType( strs[ 1 ] );
                        this.divBoxing.Width = sale.Width;
                        return script;
                    default:
                        script = sale.createSaleDayReport( );
                        this.divBoxing.Width = sale.Width;
                        return script;
                }
                try
                {
                    return sale.createSaleDayReport( );
                }
                catch
                {
                    return "";
                }
            case "SC":
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport storeSC = new ZJSIG.UIProcess.Report.StoreDayReport( );
                    storeSC.reportType = "sc";
                    storeSC.whId = this.ddlStore.SelectedValue;
                    if ( storeSC.whId == "" )
                    {
                        string whids = "";
                        for ( int i = 1; i < this.ddlStore.Items.Count; i++ )
                        {
                            if ( whids.Length > 0 )
                                whids += ",";
                            whids += this.ddlStore.Items[ i ].Value;
                        }
                        storeSC.WhCy = whids;
                    }
                    else
                        storeSC.WhCy = storeSC.whId.ToString( );
                    storeSC.orgId = this.OrgID;
                    string tempscriptZB = "";
                    if ( this.ddlOrg.Visible )
                    {
                        long.TryParse( this.ddlOrg.SelectedValue, out storeSC.orgId );
                    }
                    storeSC.dtCurrent = dt;
                    if ( strs[ 0 ].IndexOf("product") !=-1 )
                    {
                        if ( strs[ 0 ].IndexOf( "point" ) != -1 )
                            storeSC.reportType = "point";
                        storeSC.whName = this.ddlStore.SelectedItem.Text + " ";
                        storeSC.EndDate = this.getEndDate( dt );
                        storeSC.orgId = long.Parse( strs[ 2 ] );
                        long productId = 0;
                        long.TryParse( strs[ 1 ], out productId );
                        tempscriptZB = storeSC.createStoreDayProductReport( productId );
                        this.divBoxing.Width = storeSC.Width;
                        return tempscriptZB;
                    }
                    else
                    {
                        switch ( strs[ 0 ] )
                        {
                            default:
                                storeSC.whName = this.ddlStore.SelectedItem.Text + " ";
                                storeSC.EndDate = this.getEndDate( dt );
                                tempscriptZB = storeSC.createMainZbStoreReport( );
                                this.divBoxing.Width = storeSC.Width;
                                return tempscriptZB;
                            case "orgId":
                                storeSC.orgId = long.Parse( strs[ 1 ] );
                                storeSC.EndDate = this.getEndDate( dt );
                                tempscriptZB = storeSC.createStoreDayReport( );
                                this.divBoxing.Width = storeSC.Width;
                                return tempscriptZB;
                                break;
                            case"point":
                                storeSC.reportType = "point";
                                storeSC.orgId = long.Parse( strs[ 1 ] );
                                storeSC.EndDate = this.getEndDate( dt );
                                tempscriptZB = storeSC.createStoreDayReport( );
                                this.divBoxing.Width = storeSC.Width;
                                return tempscriptZB;
                        }


                    }
                }
                catch
                {
                    return "";
                }
                break;
            case"ZB":
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport storeZB = new ZJSIG.UIProcess.Report.StoreDayReport( );
                    storeZB.reportType = "zb";
                    storeZB.whId =this.ddlStore.SelectedValue ;
                    if ( storeZB.whId =="" )
                    {
                        string whids = "";
                        for ( int i = 1; i < this.ddlStore.Items.Count; i++ )
                        {
                            if ( whids.Length > 0 )
                                whids += ",";
                            whids += this.ddlStore.Items[ i ].Value;
                        }
                        storeZB.WhCy = whids;
                    }
                    else
                        storeZB.WhCy = storeZB.whId.ToString();
                    storeZB.orgId = this.OrgID;
                    string tempscriptZB = "";
                    if ( this.ddlOrg.Visible )
                    {
                        long.TryParse( this.ddlOrg.SelectedValue, out storeZB.orgId );
                    }
                    storeZB.dtCurrent = dt;
                    if ( strs[ 0 ] == "product" )
                    {
                        storeZB.whName = this.ddlStore.SelectedItem.Text + " ";
                        storeZB.EndDate = this.getEndDate( dt );
                        storeZB.orgId = long.Parse( strs[ 2 ] );
                        long productId = 0;
                        long.TryParse( strs[ 1 ], out productId );
                        tempscriptZB = storeZB.createStoreDayProductReport( productId );
                        this.divBoxing.Width = storeZB.Width;
                        return tempscriptZB;
                    }
                    else
                    {
                        switch ( strs[ 0 ] )
                        {
                            default:
                                storeZB.whName = this.ddlStore.SelectedItem.Text + " ";
                                storeZB.EndDate = this.getEndDate( dt );
                                tempscriptZB = storeZB.createMainZbStoreReport( );
                                this.divBoxing.Width = storeZB.Width;
                                return tempscriptZB;
                            case"orgId":
                                storeZB.orgId = long.Parse( strs[ 1 ] );
                                storeZB.EndDate = this.getEndDate( dt );
                                tempscriptZB = storeZB.createStoreDayReport( );
                                this.divBoxing.Width = storeZB.Width;
                                return tempscriptZB;
                                break;
                        }
                        
                        
                    }
                }
                catch
                {
                    return "";
                }
                break;
            case "pmsdayreport":
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport reportPms = new ZJSIG.UIProcess.Report.StoreDayReport( );
                    //store.productType = this.hiddenProduct.Value;
                    //store.whId = long.Parse( this.ddlStore.SelectedValue );
                    reportPms.orgId = this.OrgID;
                    string tempscriptPms = "";
                    if ( this.ddlOrg.Visible )
                    {
                        if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                        {
                            reportPms.orgIds = this.ddlOrg.SelectedValue;
                        }
                        else
                        {
                            long.TryParse( this.ddlOrg.SelectedValue, out reportPms.orgId );
                        }
                    }
                    reportPms.dtCurrent = dt;

                    tempscriptPms = reportPms.createDayPmsUpReport( );
                    this.divBoxing.Width = reportPms.Width;
                    return tempscriptPms;
                }
                catch
                {
                    return "";
                }
                break;
            case"dayreport":
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport upReport = new ZJSIG.UIProcess.Report.StoreDayReport( );
                    //store.productType = this.hiddenProduct.Value;
                    //store.whId = long.Parse( this.ddlStore.SelectedValue );
                    upReport.orgId = this.OrgID;
                    string tempscriptUp = "";
                    if ( this.ddlOrg.Visible )
                    {
                        if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                        {
                            upReport.orgIds = this.ddlOrg.SelectedValue;
                        }
                        else
                        {
                            long.TryParse( this.ddlOrg.SelectedValue, out upReport.orgId );
                        }
                    }
                    upReport.dtCurrent = dt;

                    tempscriptUp = upReport.createDaySaleUpReport( );
                    this.divBoxing.Width = upReport.Width;
                    return tempscriptUp;
                }
                catch
                {
                    return "";
                }
                break;
            case "trans":
                ZJSIG.UIProcess.Report.TransTypeReport t = new ZJSIG.UIProcess.Report.TransTypeReport( );
                if ( this.ddlOrg.Visible )
                {
                    if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                    {
                        t.orgIds = this.ddlOrg.SelectedValue;
                    }
                    else
                    {
                        long.TryParse( this.ddlOrg.SelectedValue, out t.orgId );
                    }
                }
                t.productType = this.hiddenProduct.Value;
                t.startDate = dt;
                t.endDate = getEndDate( dt );
                switch ( strs[ 0 ] )
                {
                    case "province":
                        return t.createProvinceReport( );
                    case "supplier":
                        return t.createSupplierListReport( long.Parse( strs[ 1 ] ) );
                        break;
                    default:
                        return t.createTransReport( );
                }
                break;
            case"ck":                
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport store = new ZJSIG.UIProcess.Report.StoreDayReport( );
                    store.productType = this.hiddenProduct.Value;
                    //多仓库
                    if ( this.ddlStore.SelectedValue.IndexOf( "," ) != -1 )
                    {
                        store.WhCy = this.ddlStore.SelectedValue;
                    }
                    else
                    {
                        if ( this.ddlStore.SelectedValue == "0" )
                        {
                            store.whId = "";
                        }
                        else
                        {
                            store.whId = this.ddlStore.SelectedValue;
                        }
                    }
                    store.orgId = this.OrgID;
                    store.IsSmall = this.chbClass.Checked;
                    if (this.ddlOrg.SelectedItem == null)
                        store.OrgName = ZJSIG.UIProcess.ADM.UIAdmUser.OrgName(this);
                    else
                        store.OrgName = this.ddlOrg.SelectedItem.Text.Replace("-","");
                    string tempscript = "";
                    //if ( this.ddlOrg.Visible )
                    //{
                    //    long.TryParse( this.ddlOrg.SelectedValue, out store.orgId );
                    //}
                    if ( this.ddlOrg.Visible )
                    {
                        if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                        {
                            store.orgIds = this.ddlOrg.SelectedValue;
                        }
                        else
                        {
                            long.TryParse( this.ddlOrg.SelectedValue, out store.orgId );
                        }
                    }
                    if ( this.ddlReportType.SelectedValue != "2" )
                    {
                        store.FinanceDate = true;
                    }
                    store.dtCurrent = dt;
                    store.IsSaleUnit = this.chbSaleUnit.Checked;
                    if ( strs[ 0 ] == "product" )
                    {
                        store.whName = this.ddlStore.SelectedItem.Text + " ";
                        store.EndDate = this.getEndDate( dt );
                        long productId =0;
                        long.TryParse( strs[ 1 ], out productId );
                        tempscript = store.createStoreDayProductReport( productId );
                        this.divBoxing.Width = store.Width;
                        return tempscript;
                    }
                    else
                    {
                        switch ( this.ddlReportType.SelectedValue )
                        {
                            //日报
                            case "2":
                                store.whName = this.ddlStore.SelectedItem.Text + " ";
                                store.EndDate = this.getEndDate( dt );
                                //tempscript = store.createSaleReport( );
                                long reportTypeId = 0;
                                long.TryParse( this.hiddenReportType.Value, out reportTypeId );
                                if ( reportTypeId >0 )
                                {
                                    store.ReportId = reportTypeId;
                                }
                                store.productType = this.hiddenProduct.Value;
                                tempscript = store.createStoreDayReport( );
                                this.divBoxing.Width = store.Width;
                                return tempscript;
                            //月报
                            default:
                                //store.whName = this.ddlStore.SelectedItem.Text + " ";
                                store.whName = this.ddlStore.SelectedItem.Text + " ";
                                store.EndDate = this.getEndDate( dt );
                                //tempscript = store.createSaleReport( );
                                tempscript = store.createStoreDayReport( );
                                this.divBoxing.Width = store.Width;
                                return tempscript;
                                return store.createStoreMonthReport( );
                        }
                    }
                }
                catch
                {
                    return "";
                }
                break;
            case "jtck"://集团查询仓库进出
                try
                {
                    ZJSIG.UIProcess.Report.StoreDayReport store = new ZJSIG.UIProcess.Report.StoreDayReport();
                    //store.productType = this.hiddenProduct.Value;
                    store.ClassType = long.Parse(this.ddlStore.SelectedValue);                    
                    store.orgId = this.OrgID;
                    store.OrgName = this.ddlOrg.SelectedItem.Text.Replace("-", "");
                    string tempscript = "";
                    if (this.ddlOrg.Visible)
                    {
                        if (this.ddlOrg.SelectedValue.Split(',').Length > 1)
                        {
                            store.orgIds = this.ddlOrg.SelectedValue;
                        }
                        else
                        {
                            long.TryParse(this.ddlOrg.SelectedValue, out store.orgId);
                        }
                    }
                    store.dtCurrent = dt;
                    store.whId = "";
                    switch (strs[0])
                    {
                        case "product":
                            store.EndDate = this.getEndDate(dt);
                            long productId = 0;
                            long.TryParse(strs[1], out productId);
                            tempscript = store.createStoreDayProductReport(productId);
                            this.divBoxing.Width = store.Width;
                            return tempscript;
                            break;
                        case "smallClass":
                            store.EndDate = this.getEndDate(dt);
                            tempscript = store.createStoreDayReport(strs[1]);
                            this.divBoxing.Width = store.Width;
                            return tempscript;
                            break;
                        case "classType":
                            store.EndDate = this.getEndDate(dt);
                            tempscript = store.createStoreDayReport(strs[1]);
                            this.divBoxing.Width = store.Width;
                            return tempscript;
                            break;
                        default://首次查询，将选择的类别当classid传入
                            store.EndDate = this.getEndDate(dt);
                            tempscript = store.createStoreDayReport(this.ddlStore.SelectedValue);
                            this.divBoxing.Width = store.Width;
                            return tempscript;
                            break;
                    }
                }
                catch
                {
                    return "";
                }
                break;
            case"saltworks":
                ZJSIG.UIProcess.Report.PMSReport pmsReport = new ZJSIG.UIProcess.Report.PMSReport(dt,this.getEndDate(dt));
                pmsReport.orgId = this.OrgID;
                if ( this.ddlOrg.Visible )
                {
                    long.TryParse( this.ddlOrg.SelectedValue, out pmsReport.orgId );
                }
                string tempscript1 = pmsReport.createOriSaltReport( );
                this.divBoxing.Width = pmsReport.Width;
                return tempscript1;
            case"saltprocessing":
                ZJSIG.UIProcess.Report.PmsSaltProcessingReport saltProcessing = new ZJSIG.UIProcess.Report.PmsSaltProcessingReport( 0, dt, this.getEndDate( dt ) );
                long orgId1 = 0;
                if ( strs.Length > 1 )
                    long.TryParse( strs[ 1 ], out orgId1 );
                long productId1 = 0;
                if ( strs.Length > 2 )
                    long.TryParse( strs[ 2 ], out productId1 );
                string processing = saltProcessing.createSaltProcessingReport( orgId1, productId1 );
                this.divBoxing.Width = saltProcessing.Width;
                return processing;
                break;
            case"yuanyan":
                ZJSIG.UIProcess.Report.PMSReport pmsReport1 = new ZJSIG.UIProcess.Report.PMSReport( dt, this.getEndDate( dt ) );
                //return pmsReport1.createYuanYanReport( );
                string tempscript2 = "";
                switch ( strs[ 0 ] )
                {
                    case "OrgId":
                        pmsReport1.orgId = long.Parse( strs[ 1 ] );
                        tempscript2 = pmsReport1.createOriSaltReport( );
                        break;
                    default:
                        tempscript2 = pmsReport1.createAllOriSaltReport( );
                        break;
                }

                this.divBoxing.Width = pmsReport1.Width;
                return tempscript2;
                break;
                
            case "yxwt":
                ZJSIG.UIProcess.Report.StoreDayReport storesale = new ZJSIG.UIProcess.Report.StoreDayReport( );
                storesale.dtCurrent = dt;
                storesale.productType = this.hiddenProduct.Value;
                storesale.IsSmall = chbClass.Checked;
                storesale.dtCurrent = dt;
                storesale.basePage = this;
                try
                {
                    storesale.orgId = this.OrgID;
                    string tempscript = "";
                    if ( this.ddlOrg.Visible)
                    {
                        if ( this.ddlOrg.SelectedValue.Split( ',' ).Length > 1 )
                        {
                            storesale.orgIds = this.ddlOrg.SelectedValue;
                        }
                        else
                        {
                            long.TryParse( this.ddlOrg.SelectedValue, out storesale.orgId );
                        }
                    }
                    if ( this.ddlStore.SelectedValue != "0" )
                    {
                        storesale.whId = this.ddlStore.SelectedValue;
                    }
                    else
                    {
                        storesale.whId = "";
                    }
                    switch ( strs[ 0 ] )
                    {
                        case"NoSale":
                            tempscript = storesale.createNoSaleHaveOutReport(long.Parse(strs[1]));
                            break;
                        case"NoOut":
                            tempscript = storesale.createSaleNoOutReport( long.Parse( strs[ 1 ] ) );
                            break;
                        default:
                            tempscript = storesale.createSaleReport( );
                            break;
                    }

                    this.divBoxing.Width = storesale.Width;
                    return tempscript;
                }
                catch
                {
                    return "";
                }
                break;
            case"jxc":                
                ZJSIG.UIProcess.Report.StoreDetail storeDetail = new ZJSIG.UIProcess.Report.StoreDetail(dt,getEndDate(dt) );
                
                storeDetail.UnitType = this.ddlUnit.SelectedValue;
                storeDetail.ClassName = this.ddlStore.SelectedItem.Text;
                if ( this.classType.Value == "" || this.classType.Value=="undefined" )
                {
                    storeDetail.ClassType = long.Parse( this.ddlStore.SelectedValue );
                }
                else
                {
                    storeDetail.ClassType = long.Parse( this.classType.Value );
                }
                //获取该统计项目下对应的单位信息
                storeDetail.orgIds = ZJSIG.UIProcess.BA.UIBaReportTypeOrg.getOrgsString( this, this.ddlStore.SelectedValue );

                //ZJSIG.UIProcess.Report.FactoryReport factory = new ZJSIG.UIProcess.Report.FactoryReport( dt, getEndDate( dt ) );
                //////DataSet ds = factory.getCGData( );
                //return factory.createFactoryReport( );
                    switch(strs[0])
                    {
                        case"org":
                            return storeDetail.createOrgReport(long.Parse(strs[1]));
                            break;
                        case "operType":
                            return storeDetail.createTypeReport(strs[1],0);
                            break;
                        case"product":
                            long reportClassId = 0;
                            if ( strs[ 1 ].Split( ',' ).Length == 3 )
                            {
                                long.TryParse( strs[ 1 ].Split( ',' )[ 2 ], out reportClassId );
                            }
                            return storeDetail.createOrgProductReport( long.Parse( strs[ 1 ].Split( ',' )[ 0 ] ), long.Parse( strs[ 1 ].Split( ',' )[ 1 ] ), reportClassId );
                        case"productlist":
                            return storeDetail.createStoreDayProductReport( strs[ 1 ], storeDetail.ClassType );
                            break;
                        case "smalllist":
                            return storeDetail.createTypeReport( strs[ 1 ],storeDetail.ClassType );
                            break;
                        default:
                            return storeDetail.createReport( );
                            //return storeDetail.createMainReport( );
                    }
                break;
            case"org":
                ZJSIG.UIProcess.Report.FactoryReport org = new ZJSIG.UIProcess.Report.FactoryReport( dt, getEndDate( dt ) );
                org.UnitType = this.ddlUnit.SelectedValue;
                switch ( strs[0] )
                {
                    case"orgId":
                        long classType = 0;
                        long.TryParse( this.classType.Value, out classType );
                        org.ClassType = classType;
                        return org.createOrgSaltReport( long.Parse( strs[ 1 ] ) );
                    default:
                        return org.createAllOrgReport( );
                        break;
                }
                break;
            case"factory":
                ZJSIG.UIProcess.Report.FactoryReport factory = new ZJSIG.UIProcess.Report.FactoryReport( dt, getEndDate( dt ) );
                factory.UnitType = this.ddlUnit.SelectedValue;
                string[ ] types = this.reportType.Value.Split( ':' );
                switch ( types[0] )
                {
                    case"Supplier":
                        if ( types[ 1 ] == "" )
                            return "";
                        factory.CustomerId = long.Parse( types[ 1 ] );
                        return factory.createFactorySupplierReport( );
                        break;
                    default:
                        return factory.createFactoryReport( );
                        break;
                }
               
                break;
            case"sell":
                ZJSIG.UIProcess.Report.SellReport sellReport = new ZJSIG.UIProcess.Report.SellReport( dt, getEndDate( dt ) );
                sellReport.ClassType = long.Parse( this.ddlStore.SelectedValue );
                sellReport.UnitId = long.Parse( this.ddlUnit.SelectedValue );
                switch ( strs[ 0 ] )
                {
                    case"product":
                        return sellReport.createOrgReport( strs[ 1 ] );
                    case"org":

                        //long classType = 0;
                        if ( this.classType.Value == "" || this.classType.Value == "undefined" )
                        {
                            sellReport.ClassType = long.Parse( this.ddlStore.SelectedValue );
                        }
                        else
                        {
                            sellReport.ClassType = long.Parse( this.classType.Value );
                        }
                        //long.TryParse( this.classType.Value, out classType );
                        //sellReport.ClassType = classType;
                        return sellReport.createOrgSaltProductReport( strs[ 1 ] );
                    default:
                        if ( this.classType.Value == "" || this.classType.Value == "undefined" )
                        {
                            sellReport.ClassType = long.Parse( this.ddlStore.SelectedValue );
                        }
                        else
                        {
                            sellReport.ClassType = long.Parse( this.classType.Value );
                        }
                        return sellReport.createAllProductReport( );
                }
                
                break;
                //供应商调运情况
            case"purchsalt":
                ZJSIG.UIProcess.Report.PurchSaltProduct purch = new ZJSIG.UIProcess.Report.PurchSaltProduct( );
                purch.StartDate = dt;
                purch.EndDate = getEndDate( dt );
                switch ( strs[ 0 ] )
                {
                    case"transtype":
                        return purch.createByTransReport( );
                    default:
                        return purch.createByAreaReport( );
                }
                //return purch.createByAreaReport( );
                break;
            case"saltpurch":
                ZJSIG.UIProcess.Report.SaltPurchSalt saltPurch = new ZJSIG.UIProcess.Report.SaltPurchSalt( );
                //string orgs = ZJSIG.UIProcess.BA.UIBaReportTypeOrg.getOrgsString( this,"1" );
                string orgs = "";
                if ( this.ddlOrg.SelectedItem.Value != "0" )
                {
                    orgs = this.ddlOrg.SelectedItem.Value;
                }
                
                saltPurch.ReportType = this.reportType.Value;
                //saltPurch.ReportType = "AllOrg";
                return saltPurch.createReport( orgs, dt, getEndDate( dt ) );
                break;
            case"mainreport":
                ZJSIG.UIProcess.Report.SaltMainReport mainReport = new ZJSIG.UIProcess.Report.SaltMainReport( );
                mainReport.StartDate = dt;
                mainReport.EndDate = getEndDate( dt );
                return mainReport.createReport( );                
            case"smallreport":
                ZJSIG.UIProcess.Report.SmallSaltReport small = new ZJSIG.UIProcess.Report.SmallSaltReport( );
                small.StartDate = dt;
                small.EndDate = getEndDate( dt );
                small.ReportType = this.reportType.Value;
                if ( this.ddlReportType.SelectedValue != "2" )
                {
                    small.FinanceDate = true;
                }
                if ( this.OrgID > 1 )
                {
                    small.ReportType = "org:" + this.OrgID.ToString( );
                }
                if ( this.ddlReportType.SelectedValue != "2" )
                {
                    small.FinanceDate = true;
                }
                return small.createReport( );
                break;
        }
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
        bindStore( );
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
