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
using System.IO;

public partial class RPT_WMS_frmOrgBusiUseStatics : System.Web.UI.Page
{
    public static DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.TextBox1.Text = DateTime.Now.ToString("yyyy-MM-dd");
            this.TextBox2.Text = DateTime.Now.ToString("yyyy-MM-dd");
            this.GridView1.DataSource = null;
            this.GridView1.DataBind();
            
        }
        
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        try
        {
            this.GridView1.AllowPaging = false;

            ////重新绑定数据 
            //this.GridView1.DataSource = dt;
            //this.GridView1.DataBind();

            string StrFileName = "全省所有单位业务使用情况";
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "GB2312";
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + StrFileName + ".xls");
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.ContentType = "application/ms-excel";
            StringWriter oStringWriter = new StringWriter();
            HtmlTextWriter oHtmlTextWriter = new HtmlTextWriter(oStringWriter);
            this.GridView1.RenderControl(oHtmlTextWriter);
            Response.Output.Write(oStringWriter.ToString());
            Response.Flush();
            Response.End();
        }
        catch
        {
            //Alert("导出出错！"); 
            //return; 
        } 
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dt.DefaultView.Sort = "";
            return;
        }
        DateTime startdate = DateTime.Parse(this.TextBox1.Text);
        DateTime enddate = DateTime.Parse(this.TextBox2.Text);
        dt = new DataTable();
        DataColumn dc1 = new DataColumn("单位名称", typeof(string));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("本期订单数量（单）", typeof(int));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("本期订单金额（元）", typeof(decimal));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("上期订单数量（单）", typeof(int));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("上期订单金额（元）", typeof(decimal));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("同期订单数量（单）", typeof(int));
        dt.Columns.Add(dc1);
        dc1 = new DataColumn("同期订单金额（元）", typeof(decimal));
        dt.Columns.Add(dc1);

        //1.查询本期（订单数量，订单金额）
        DataTable dtThisCount = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetOrderCount(startdate, enddate);
        DataTable dtThisSum = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetSaleAmtSum(startdate, enddate);
                
        //2.上期（订单数量，订单金额）
        startdate = DateTime.Parse(this.TextBox1.Text).AddDays(-1);
        enddate = DateTime.Parse(this.TextBox2.Text).AddDays(-1);
        DataTable dtLastCount = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetOrderCount(startdate, enddate);
        DataTable dtLastSum = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetSaleAmtSum(startdate, enddate);

        //3.历史同期（订单数量，订单金额）
        startdate = DateTime.Parse(this.TextBox1.Text).AddYears(-1);
            enddate = DateTime.Parse(this.TextBox2.Text).AddYears(-1);
        DataTable dtHisCount = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetOrderCount(startdate, enddate);
        DataTable dtHisSum = ZJSIG.UIProcess.SCM.UIVScmOrderdtlSalequery.GetSaleAmtSum(startdate, enddate);

        //组装
        foreach (DataRow dr in dtThisCount.Rows)
        {
            DataRow drNew = dt.NewRow();
            drNew["单位名称"] = dr["org_short_name"];
            drNew["本期订单数量（单）"] = dr["order_count"].ToString();
            if (dtThisSum == null || dtThisSum.Rows.Count == 0)
            {
                drNew["本期订单金额（元）"] = 0;
            }
            else
            {
                DataRow[] drs = dtThisSum.Select("org_id=" + dr["org_id"]);
                if(drs!=null && drs.Length==1)
                    drNew["本期订单金额（元）"] = drs[0]["sale_amt"].ToString();
                else
                    drNew["本期订单金额（元）"] = 0;
            }
            //last
            if (dtLastCount == null || dtLastCount.Rows.Count == 0)
            {
                drNew["上期订单数量（单）"] = 0;
            }
            else
            {
                DataRow[] drs = dtLastCount.Select("org_id=" + dr["org_id"]);
                if (drs != null && drs.Length == 1)
                    drNew["上期订单数量（单）"] = drs[0]["order_count"].ToString();
                else
                    drNew["上期订单数量（单）"] = 0;
            }
            if (dtLastSum == null || dtLastSum.Rows.Count == 0)
            {
                drNew["上期订单金额（元）"] = 0;
            }
            else
            {
                DataRow[] drs = dtLastSum.Select("org_id=" + dr["org_id"]);
                if (drs != null && drs.Length == 1)
                    drNew["上期订单金额（元）"] = drs[0]["sale_amt"].ToString();
                else
                    drNew["上期订单金额（元）"] = 0;
            }
            //his
            if (dtHisCount == null || dtHisCount.Rows.Count == 0)
            {
                drNew["同期订单数量（单）"] = 0;
            }
            else
            {
                DataRow[] drs = dtHisCount.Select("org_id=" + dr["org_id"]);
                if (drs != null && drs.Length == 1)
                    drNew["同期订单数量（单）"] = drs[0]["order_count"].ToString();
                else
                    drNew["同期订单数量（单）"] = 0;
            }
            if (dtHisSum == null || dtHisSum.Rows.Count == 0)
            {
                drNew["同期订单金额（元）"] = 0;
            }
            else
            {
                DataRow[] drs = dtHisSum.Select("org_id=" + dr["org_id"]);
                if (drs != null && drs.Length == 1)
                    drNew["同期订单金额（元）"] = drs[0]["sale_amt"].ToString();
                else
                    drNew["同期订单金额（元）"] = 0;
            }
            dt.Rows.Add(drNew);
        }
        dt.DefaultView.Sort = "本期订单数量（单） desc ";
        sortField = GetSortColumnIndex("本期订单数量（单）");
        GridViewSortDirection = SortDirection.Descending;
        this.GridView1.DataSource = dt.DefaultView;
        this.GridView1.DataBind();
        if (dt.Rows.Count > 0)
            this.Label3.Text = "数据已刷新成功！";
        else
            this.Label3.Text = "请点击查询按钮刷新数据。。。";
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {        
        if (e.Row.RowIndex >= 0)
        {
            e.Row.Cells[0].Text = Convert.ToString(e.Row.DataItemIndex + 1);
            e.Row.Cells[0].Width = Unit.Parse("50px ");
            e.Row.Cells[0].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[1].Width = Unit.Parse("130px ");
            e.Row.Cells[1].Style.Add(HtmlTextWriterStyle.TextAlign, "left");
            e.Row.Cells[2].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[3].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[4].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[5].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[6].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            e.Row.Cells[7].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //鼠标经过时，行背景色变 
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='#E6F5FA'; ");
            //鼠标移出时，行背景色变 
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor='#FFFFFF'; ");
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {//表尾
            e.Row.Cells[1].Text = "合计：";
            e.Row.Cells[1].Style.Add(HtmlTextWriterStyle.TextAlign, "right");
            object o = dt.Compute("sum(本期订单数量（单）)", "");
            e.Row.Cells[2].Text = o.ToString();
            e.Row.Cells[2].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            o = dt.Compute("sum(本期订单金额（元）)", "");
            e.Row.Cells[3].Text = o.ToString();
            e.Row.Cells[3].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            o = dt.Compute("sum(上期订单数量（单）)", "");
            e.Row.Cells[4].Text = o.ToString();
            e.Row.Cells[4].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            o = dt.Compute("sum(上期订单金额（元）)", "");
            e.Row.Cells[5].Text = o.ToString();
            e.Row.Cells[5].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            o = dt.Compute("sum(同期订单数量（单）)", "");
            e.Row.Cells[6].Text = o.ToString();
            e.Row.Cells[6].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
            o = dt.Compute("sum(同期订单金额（元）)", "");
            e.Row.Cells[7].Text = o.ToString();
            e.Row.Cells[7].Style.Add(HtmlTextWriterStyle.TextAlign, "center");
        }
        if (e.Row.RowType == DataControlRowType.Header)
        {//标题行
            if (sortField>0)
            {
                Label label = new Label();
                label.Text = GridViewSortDirection == SortDirection.Ascending ? "<font color='#99BBE8'>▲</font>" : "<font color='#99BBE8'>▼</font>";
                e.Row.Cells[sortField].Controls.Add(label);
            }
        }
    }
    /// <summary>
    /// 排序方向屬性
    /// </summary>
    public SortDirection GridViewSortDirection
    {
        get
        {
            if (ViewState["sortDirection"] == null)
                ViewState["sortDirection"] = SortDirection.Ascending;
            return (SortDirection)ViewState["sortDirection"];
        }
        set
        {
            ViewState["sortDirection"] = value;
        }
    }
    /// <summary>
    /// 排序字段
    /// </summary>
    public int sortField
    {
        get
        {
            if (ViewState["sortField"] == null)
                return -1;
            return (int)ViewState["sortField"];
        }
        set
        {
            ViewState["sortField"] = value;
        }
    }
    protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
    {
        string sortExpression = e.SortExpression.ToUpper();
        sortField = GetSortColumnIndex(sortExpression);
        if (GridViewSortDirection == SortDirection.Ascending)
        {
            GridViewSortDirection = SortDirection.Descending;
            //排序並重新綁定
            bindData(sortExpression, "DESC");
        }
        else if (GridViewSortDirection == SortDirection.Descending)
        {
            GridViewSortDirection = SortDirection.Ascending;
            //排序並重新綁定
            bindData(sortExpression, "ASC");
        }
    }
    /// <summary>
    /// 排序並綁定數據
    /// </summary>
    /// <param name="sortExpression"></param>
    /// <param name="sortDirection"></param>
    protected void bindData(string sortExpression, string sortDirection)
    {
        dt.DefaultView.Sort = sortExpression + " " + sortDirection;
        this.GridView1.DataSource = dt.DefaultView;
        this.GridView1.DataBind();
    }

    //获取排序列索引
    private int GetSortColumnIndex(string fildName)
    {
        foreach (DataColumn  dc in dt.Columns)
        {
            if (dc.ColumnName == fildName)
                return dc.Ordinal + 1;
        }
        return -1;
    }

    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
    }
}
