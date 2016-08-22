using System;
using System.Collections;
using System.Collections.Generic;
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

public partial class RPT_WMS_frmProductCostView : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            initContralSet();
        }
    }
    private void initContralSet()
    {
        DataSet ds = ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListByOrgId(ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this));
        this.DropDownList1.DataSource = ds.Tables[0];
        this.DropDownList1.DataTextField = "WhName";
        this.DropDownList1.DataValueField = "WhId";
        this.DropDownList1.DataBind();

        this.DropDownList1.Items.Insert(0, new ListItem("全部", "-1"));
        
        for ( int i = 2009; i < DateTime.Today.Year + 10; i++ )
        {
            this.ddlYear.Items.Add( new ListItem(i.ToString()+"年",i.ToString()));
        }
        for ( int i = 1; i < 13; i++ )
        {
            this.ddlMonth.Items.Add( new ListItem(i.ToString()+"月",i.ToString( ) ));
        }
        this.ddlYear.SelectedIndex = DateTime.Today.Year - 2009;
        this.ddlMonth.SelectedIndex = DateTime.Today.AddMonths( -1 ).Month;


    }    
    protected void Button1_Click1(object sender, EventArgs e)
    {
        long whId = long.Parse(this.DropDownList1.SelectedValue);
        DateTime StartDate = DateTime.Parse(this.ddlYear.SelectedValue + "/" + this.ddlMonth.SelectedValue + "/01");
        DateTime EndDate = StartDate.AddMonths(1).AddDays(-1);
        string classIds = this.hiddenProductClass.Value;
        string productName = this.TextBox1.Text;
        int needMerg = this.CheckBox1.Checked ? 1 : 0;
        string whIds = "";
        if ( string.IsNullOrEmpty( this.hiddenWh.Value ) )
        {
            ZJSIG.WMS.BLL.BLWmsWarehouse.GetWarehouseListByOrgID( OrgID ).ForEach( delegate( ZJSIG.WMS.BusinessEntities.WmsWarehouse wwh )
            {
                whIds += wwh.WhId + ",";
            } );
            if ( whIds.Length > 0 )
                whIds = whIds.Remove( whIds.Length - 1 );
        }
        else
            whIds = this.hiddenWh.Value;
        DataTable dtret = ZJSIG.UIProcess.WMS.UIWmsProductCost.getProductCostList(OrgID,
            whIds, "", classIds, "", productName, StartDate, EndDate, needMerg );

        this.Label3.Text = this.DropDownList1.SelectedItem.Text + ":" + StartDate.ToString("yyyy年MM月");

        
        #region 组装gridview需要的列和数据(转换为自定义单位)

        DataTable dt = new DataTable( );
        dt.Columns.Add( new DataColumn( "PRODUCT_NO", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "PRODUCT_NAME", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "SPECIFICATIONS", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "UNIT_NAME", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "LAST_TOTAL_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "LAST_COST_PRICE", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "LAST_TOTAL_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0219_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0219", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0219_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0201_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0201", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0201_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0206_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0206", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0206_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0208_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0208", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0208_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0217_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0217", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0217_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0212_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0212", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0212_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0211_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0211", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0211_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0216_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0216", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0216_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0204_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0204", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0204_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0210_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0210", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0210_COST_AMT", typeof( string ) ) );
        //dt.Columns.Add(new DataColumn("W0203_COST_QTY", typeof(string))); //盘点
        //dt.Columns.Add(new DataColumn("W0203", typeof(string)));
        //dt.Columns.Add(new DataColumn("W0203_COST_AMT", typeof(string)));
        //
        dt.Columns.Add( new DataColumn( "W0205_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0205", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0205_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0214_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0214", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0214_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0209_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0209", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0209_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0202_COST_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0202", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "W0202_COST_AMT", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "TOTAL_QTY", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "PURE_COST_PRICE", typeof( string ) ) );
        dt.Columns.Add( new DataColumn( "THIS_TOTAL_AMT", typeof( string ) ) );

        if ( dtret != null && dtret.Rows.Count > 0 )
        {
            DataTable dtRates = ZJSIG.UIProcess.WMS.UIWmsProductCost.getProductUnitRate( OrgID );
            //
            foreach (DataRowView drv in dtret.DefaultView)
            {
                DataRow dr = dt.NewRow();
                DataRow[] rateDr = dtRates.Select("ProductId=" + drv["PRODUCT_ID"]);
                if (rateDr == null || rateDr.Length <= 0)
                    throw new Exception(drv["PRODUCT_NAME"] + "，可售商品销售单位未设置！");
                decimal rate = decimal.Parse(rateDr[0]["SaleRate"].ToString());
                dr["PRODUCT_NO"] = drv["PRODUCT_NO"];
                dr["PRODUCT_NAME"] = drv["PRODUCT_NAME"];
                dr["SPECIFICATIONS"] = drv["SPECIFICATIONS"];
                dr["UNIT_NAME"] = rateDr[0]["SaleUnitName"];
                dr["LAST_TOTAL_QTY"] = Math.Round(decimal.Parse(drv["LAST_TOTAL_QTY"].ToString()) / rate, 6);
                dr["LAST_COST_PRICE"] = Math.Round(decimal.Parse(drv["LAST_COST_PRICE"].ToString()) * rate, 8).ToString("0.########");
                dr["LAST_TOTAL_AMT"] = Math.Round(decimal.Parse(drv["LAST_TOTAL_AMT"].ToString()), 2).ToString("0.##");
                dr["W0219_COST_QTY"] = Math.Round(decimal.Parse(drv["W0219_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0219"] = Math.Round(decimal.Parse(drv["W0219"].ToString()) * rate, 8).ToString("0.########");
                dr["W0219_COST_AMT"] = Math.Round(decimal.Parse(drv["W0219_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0201_COST_QTY"] = Math.Round(decimal.Parse(drv["W0201_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0201"] = Math.Round(decimal.Parse(drv["W0201"].ToString()) * rate, 8).ToString("0.########");
                dr["W0201_COST_AMT"] = Math.Round(decimal.Parse(drv["W0201_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0206_COST_QTY"] = Math.Round(decimal.Parse(drv["W0206_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0206"] = Math.Round(decimal.Parse(drv["W0206"].ToString()) * rate, 8).ToString("0.########");
                dr["W0206_COST_AMT"] = Math.Round(decimal.Parse(drv["W0206_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0208_COST_QTY"] = Math.Round(decimal.Parse(drv["W0208_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0208"] = Math.Round(decimal.Parse(drv["W0208"].ToString()) * rate, 8).ToString("0.########");
                dr["W0208_COST_AMT"] = Math.Round(decimal.Parse(drv["W0208_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0217_COST_QTY"] = Math.Round(decimal.Parse(drv["W0217_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0217"] = Math.Round(decimal.Parse(drv["W0217"].ToString()) * rate, 8).ToString("0.########");
                dr["W0217_COST_AMT"] = Math.Round(decimal.Parse(drv["W0217_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0212_COST_QTY"] = Math.Round(decimal.Parse(drv["W0212_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0212"] = Math.Round(decimal.Parse(drv["W0212"].ToString()) * rate, 8).ToString("0.########");
                dr["W0212_COST_AMT"] = Math.Round(decimal.Parse(drv["W0212_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0211_COST_QTY"] = Math.Round(decimal.Parse(drv["W0211_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0211"] = Math.Round(decimal.Parse(drv["W0211"].ToString()) * rate, 8).ToString("0.########");
                dr["W0211_COST_AMT"] = Math.Round(decimal.Parse(drv["W0211_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0216_COST_QTY"] = Math.Round(decimal.Parse(drv["W0216_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0216"] = Math.Round(decimal.Parse(drv["W0216"].ToString()) * rate, 8).ToString("0.########");
                dr["W0216_COST_AMT"] = Math.Round(decimal.Parse(drv["W0216_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0204_COST_QTY"] = Math.Round(decimal.Parse(drv["W0204_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0204"] = Math.Round(decimal.Parse(drv["W0204"].ToString()) * rate, 8).ToString("0.########");
                dr["W0204_COST_AMT"] = Math.Round(decimal.Parse(drv["W0204_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0210_COST_QTY"] = Math.Round(decimal.Parse(drv["W0210_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0210"] = Math.Round(decimal.Parse(drv["W0210"].ToString()) * rate, 8).ToString("0.########");
                dr["W0210_COST_AMT"] = Math.Round(decimal.Parse(drv["W0210_COST_AMT"].ToString()), 2).ToString("0.##");
                //dr["W0203_COST_QTY"] = drv["W0203_COST_QTY"];
                //dr["W0203"] = drv["W0203"];
                //dr["W0203_COST_AMT"] = drv["W0203_COST_AMT"];
                //
                dr["W0205_COST_QTY"] = Math.Round(decimal.Parse(drv["W0205_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0205"] = Math.Round(decimal.Parse(drv["W0205"].ToString()) * rate, 8).ToString("0.########");
                dr["W0205_COST_AMT"] = Math.Round(decimal.Parse(drv["W0205_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0214_COST_QTY"] = Math.Round(decimal.Parse(drv["W0214_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0214"] = Math.Round(decimal.Parse(drv["W0214"].ToString()) * rate, 8).ToString("0.########");
                dr["W0214_COST_AMT"] = Math.Round(decimal.Parse(drv["W0214_COST_AMT"].ToString()), 2).ToString("0.##");
                dr["W0209_COST_QTY"] = Math.Round(decimal.Parse(drv["W0209_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["W0209"] = Math.Round(decimal.Parse(drv["W0209"].ToString()) * rate, 8).ToString("0.########");
                dr["W0209_COST_AMT"] = Math.Round(decimal.Parse(drv["W0209_COST_AMT"].ToString()), 2).ToString("0.##");
                if (OrgID == 25)
                {//数据源中减去销售退回
                    decimal qty = decimal.Parse(drv["W0202_COST_QTY"].ToString()) - decimal.Parse(drv["W0204_COST_QTY"].ToString());
                    decimal amt = decimal.Parse(drv["W0202_COST_AMT"].ToString()) - decimal.Parse(drv["W0204_COST_AMT"].ToString());
                    dr["W0202_COST_QTY"] = Math.Round(qty / rate, 6).ToString("0.######");
                    dr["W0202"] = (qty == 0 ? 0 : Math.Round((amt / qty) * rate, 8)).ToString("0.########");
                    dr["W0202_COST_AMT"] = Math.Round(amt, 2).ToString("0.##");
                }
                else
                {
                    dr["W0202_COST_QTY"] = Math.Round(decimal.Parse(drv["W0202_COST_QTY"].ToString()) / rate, 6).ToString("0.######");
                    dr["W0202"] = Math.Round(decimal.Parse(drv["W0202"].ToString()) * rate, 8).ToString("0.########");
                    dr["W0202_COST_AMT"] = Math.Round(decimal.Parse(drv["W0202_COST_AMT"].ToString()), 2).ToString("0.##");
                }
                dr["TOTAL_QTY"] = Math.Round(decimal.Parse(drv["TOTAL_QTY"].ToString()) / rate, 6).ToString("0.######");
                dr["PURE_COST_PRICE"] = Math.Round(decimal.Parse(drv["PURE_COST_PRICE"].ToString()) * rate, 8).ToString("0.########");
                dr["THIS_TOTAL_AMT"] = Math.Round(decimal.Parse(drv["THIS_TOTAL_AMT"].ToString()), 2).ToString("0.##");
                dt.Rows.Add(dr);
            }
        }
        #endregion

        this.GridView1.DataSource = dt.DefaultView;
        this.GridView1.DataBind();
    }
    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            DynamicTHeaderHepler dHelper = new DynamicTHeaderHepler();
            string header = "编号#名称#规格#单位#期初 数量,单价,成本";

            #region 入
            header += "#收入 其他 数量,单价,金额";//W0219 人为调整业务（运费、调整金额（加/减）、返利）
            header += "#收入 采购 数量,单价,金额";//W0201
            header += "#收入 移库 数量,单价,金额";//W0206
            header += "#收入 升溢 数量,单价,金额";//W0208
            header += "#收入 转换 数量,单价,金额";//W0217
            header += "#收入 生产 数量,单价,金额";//W0212
            header += "#收入 降级 数量,单价,金额";//W0211
            header += "#收入 直拨 数量,单价,金额";//W0216
            if (OrgID != 25)//余杭公司要求退货做到销售里面去作为负数处理
                header += "#收入 销售退货 数量,单价,金额";//W0204
            header += "#收入 生产退货 数量,单价,金额";//W0210
            #endregion
            #region 出
            header += "#发出 移库 数量,单价,金额";//W0205
            header += "#发出 损耗 数量,单价,金额";//W0214
            header += "#发出 退货 数量,单价,金额";//W0209
            header += "#发出 销售 数量,单价,金额";//W0202   
            #endregion

            header += "#期末 数量,单价,成本";

            dHelper.SplitTableHeader(e.Row, header);
        }
        else if(e.Row.RowType == DataControlRowType.Footer||e.Row.RowType == DataControlRowType.DataRow)
        {
            if (OrgID == 25)
            {
                e.Row.Cells.RemoveAt(33);
                e.Row.Cells.RemoveAt(32);
                e.Row.Cells.RemoveAt(31);
            }
        }
    }
    protected void Button_print_Click(object sender, EventArgs e)
    {
        System.Web.HttpContext HC = System.Web.HttpContext.Current; 
        HC.Response.Clear();
        HC.Response.Charset = "GB2312";
        HC.Response.Buffer = true;
        HC.Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312"); 
        HC.Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode("结果打印", System.Text.Encoding.UTF8) + ".xls");
        HC.Response.ContentType = "application/ms-excel";//如果要打印为word格式，则换为"application/ms-word"
        this.EnableViewState = false;
        System.IO.StringWriter sw = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw);        
        this.GridView1.RenderControl(htw);
        this.Label3.RenderControl(htw);
        HC.Response.Write(sw.ToString());
        HC.Response.End();
    }//打印输出按钮
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {

    }
    #region 变量
    decimal LAST_TOTAL_QTY = 0;
    decimal LAST_TOTAL_AMT = 0;
    decimal W0219_COST_QTY = 0;
    decimal W0219_COST_AMT = 0;
    decimal W0201_COST_QTY = 0;
    decimal W0201_COST_AMT = 0;
    decimal W0206_COST_QTY = 0;
    decimal W0206_COST_AMT = 0;
    decimal W0208_COST_QTY = 0;
    decimal W0208_COST_AMT = 0;
    decimal W0217_COST_QTY = 0;
    decimal W0217_COST_AMT = 0;
    decimal W0212_COST_QTY = 0;
    decimal W0212_COST_AMT = 0;
    decimal W0211_COST_QTY = 0;
    decimal W0211_COST_AMT = 0;
    decimal W0216_COST_QTY = 0;
    decimal W0216_COST_AMT = 0;
    decimal W0204_COST_QTY = 0;
    decimal W0204_COST_AMT = 0;
    decimal W0210_COST_QTY = 0;
    decimal W0210_COST_AMT = 0;
    decimal W0205_COST_QTY = 0;
    decimal W0205_COST_AMT = 0;
    decimal W0214_COST_QTY = 0;
    decimal W0214_COST_AMT = 0;
    decimal W0209_COST_QTY = 0;
    decimal W0209_COST_AMT = 0;
    decimal W0202_COST_QTY = 0;
    decimal W0202_COST_AMT = 0;
    decimal TOTAL_QTY = 0;
    decimal THIS_TOTAL_AMT = 0;
    #endregion

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[0].Attributes.Add("class", "text");
        }

        //合计
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LAST_TOTAL_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "LAST_TOTAL_QTY"));
            LAST_TOTAL_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "LAST_TOTAL_AMT"));
            W0219_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0219_COST_QTY"));
            W0219_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0219_COST_AMT"));
            W0201_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0201_COST_QTY"));
            W0201_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0201_COST_AMT"));
            W0206_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0206_COST_QTY"));
            W0206_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0206_COST_AMT"));
            W0208_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0208_COST_QTY"));
            W0208_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0208_COST_AMT"));
            W0217_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0217_COST_QTY"));
            W0217_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0217_COST_AMT"));
            W0212_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0212_COST_QTY"));
            W0212_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0212_COST_AMT"));
            W0211_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0211_COST_QTY"));
            W0211_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0211_COST_AMT"));
            W0216_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0216_COST_QTY"));
            W0216_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0216_COST_AMT"));
            W0204_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0204_COST_QTY"));
            W0204_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0204_COST_AMT"));
            W0210_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0210_COST_QTY"));
            W0210_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0210_COST_AMT"));
            W0205_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0205_COST_QTY"));
            W0205_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0205_COST_AMT"));
            W0214_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0214_COST_QTY"));
            W0214_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0214_COST_AMT"));
            W0209_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0209_COST_QTY"));
            W0209_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0209_COST_AMT"));
            W0202_COST_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0202_COST_QTY"));
            W0202_COST_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "W0202_COST_AMT"));
            TOTAL_QTY += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "TOTAL_QTY"));
            THIS_TOTAL_AMT += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "THIS_TOTAL_AMT"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[0].Text = "合计：";
            e.Row.Cells[4].Text = LAST_TOTAL_QTY.ToString();
            e.Row.Cells[6].Text = LAST_TOTAL_AMT.ToString();
            e.Row.Cells[7].Text = W0219_COST_QTY.ToString();
            e.Row.Cells[9].Text = W0219_COST_AMT.ToString();
            e.Row.Cells[10].Text = W0201_COST_QTY.ToString();
            e.Row.Cells[12].Text = W0201_COST_AMT.ToString();
            e.Row.Cells[13].Text = W0206_COST_QTY.ToString();
            e.Row.Cells[15].Text = W0206_COST_AMT.ToString();
            e.Row.Cells[16].Text = W0208_COST_QTY.ToString();
            e.Row.Cells[18].Text = W0208_COST_AMT.ToString();
            e.Row.Cells[19].Text = W0217_COST_QTY.ToString();
            e.Row.Cells[21].Text = W0217_COST_AMT.ToString();
            e.Row.Cells[22].Text = W0212_COST_QTY.ToString();
            e.Row.Cells[24].Text = W0212_COST_AMT.ToString();
            e.Row.Cells[25].Text = W0211_COST_QTY.ToString();
            e.Row.Cells[27].Text = W0211_COST_AMT.ToString();
            e.Row.Cells[28].Text = W0216_COST_QTY.ToString();
            e.Row.Cells[30].Text = W0216_COST_AMT.ToString();
            int i = 0;//余杭单独处理
            if (OrgID == 25) { 
                i = 3;
                //W0202_COST_QTY = W0202_COST_QTY - W0204_COST_QTY;
                //W0202_COST_AMT = W0202_COST_AMT - W0204_COST_AMT;
            } else {
                e.Row.Cells[31].Text = W0204_COST_QTY.ToString();
                e.Row.Cells[33].Text = W0204_COST_AMT.ToString();
            }
            e.Row.Cells[34 - i].Text = W0210_COST_QTY.ToString();
            e.Row.Cells[36 - i].Text = W0210_COST_AMT.ToString();
            e.Row.Cells[37 - i].Text = W0205_COST_QTY.ToString();
            e.Row.Cells[39 - i].Text = W0205_COST_AMT.ToString();
            e.Row.Cells[40 - i].Text = W0214_COST_QTY.ToString();
            e.Row.Cells[42 - i].Text = W0214_COST_AMT.ToString();
            e.Row.Cells[43 - i].Text = W0209_COST_QTY.ToString();
            e.Row.Cells[45 - i].Text = W0209_COST_AMT.ToString();
            e.Row.Cells[46 - i].Text = W0202_COST_QTY.ToString();
            e.Row.Cells[48 - i].Text = W0202_COST_AMT.ToString();
            e.Row.Cells[49 - i].Text = TOTAL_QTY.ToString();
            e.Row.Cells[51 - i].Text = THIS_TOTAL_AMT.ToString();
                        //e.Row.Cells[4]..Text = sum.ToString();
        }  
    }
}
//
//***********************************************************************
//  Created: 2007-10-29    Author:  ruijc
//  File: DynamicTHeaderHepler.cs
//  Description: 动态生成复合表头帮助类
//  相邻父列头之间用'#'分隔,父列头与子列头用空格(' ')分隔,相邻子列头用逗号分隔(',').
//***********************************************************************
class DynamicTHeaderHepler
{
    public DynamicTHeaderHepler()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    /**//// <summary>
    /// 重写表头
    /// </summary>
    /// <param name="targetHeader">目标表头</param>
    /// <param name="newHeaderNames">新表头</param>
    /// <remarks>
    /// 等级#级别#上期结存 件数,重量,比例#本期调入 收购调入 件数,重量,比例#本期发出 车间投料 件数,重量,
    /// 比例#本期发出 产品外销百分比 件数,重量,比例#平均值
    /// </remarks>
    public void SplitTableHeader(GridViewRow targetHeader, string newHeaderNames)
    {
        TableCellCollection tcl = targetHeader.Cells;//获得表头元素的实例
        tcl.Clear();//清除元素
        int row = GetRowCount(newHeaderNames);
        int col = GetColCount(newHeaderNames);
        string[,] nameList = ConvertList(newHeaderNames,row,col);
        int RowSpan = 0;
        int ColSpan = 0;
        for (int k = 0; k < row; k++)
        {
            string LastFName = "";
            for (int i = 0; i < col; i++)
            {
                if (LastFName == nameList[i, k] && k!=row-1)
                {
                    LastFName = nameList[i, k];
                    continue;
                }
                else
                {
                    LastFName = nameList[i, k];
                }
                int bFlag=IsVisible(nameList, k, i, LastFName);
                switch (bFlag)
                {
                    case 0:
                        break;
                    case 1:
                        RowSpan = GetSpanRowCount(nameList,row, k, i);
                        ColSpan = GetSpanColCount(nameList,row,col, k, i);
                        tcl.Add(new TableHeaderCell());//添加表头控件
                        tcl[tcl.Count - 1].RowSpan = RowSpan;
                        tcl[tcl.Count - 1].ColumnSpan = ColSpan;
                        tcl[tcl.Count - 1].HorizontalAlign = HorizontalAlign.Center;
                        tcl[tcl.Count - 1].Text = LastFName;
                        tcl[tcl.Count - 1].Wrap = false;
                        break;
                    case -1:
                        string[] EndColName = LastFName.Split(new char[] { ',' });
                        foreach(string eName in EndColName){
                            tcl.Add(new TableHeaderCell());//添加表头控件
                            tcl[tcl.Count - 1].HorizontalAlign = HorizontalAlign.Center;
                            tcl[tcl.Count - 1].Text = eName;
                            tcl[tcl.Count - 1].Wrap = false;
                        }
                        break;
                }
            }
            if (k != row-1)
            {//不是起始行,加入新行标签
                tcl[tcl.Count - 1].Text = tcl[tcl.Count - 1].Text+"</th></tr><tr>";
            }
        }
    }
    /**//// <summary>
    /// 如果上一行已经输出和当前内容相同的列头，则不显示
    /// </summary>
    /// <param name="ColumnList">表头集合</param>
    /// <param name="rowIndex">行索引</param>
    /// <param name="colIndex">列索引</param>
    /// <returns>1:显示,-1:含','分隔符,0:不显示</returns>
    private int IsVisible(string[,] ColumnList,int rowIndex, int colIndex,string CurrName)
    {
        if (rowIndex!=0){
            if (ColumnList[colIndex,rowIndex-1]==CurrName){
                return 0;
            }else{
                if (ColumnList[colIndex, rowIndex].Contains(","))
                {
                    return -1;
                }else{
                    return 1;
                }
            }
        }
        return 1;
    }
    /**//// <summary>
    /// 取得和当前索引行及列对应的下级的内容所跨的行数
    /// </summary>
    /// <param name="ColumnList">表头集合</param>
    /// <param name="row">行数</param>
    /// <param name="rowIndex">行索引</param>
    /// <param name="colIndex">列索引</param>
    /// <returns>行数</returns>
    private int GetSpanRowCount(string[,] ColumnList, int row,int rowIndex, int colIndex)
    {
        string LastName = "";
        int RowSpan = 1;
        for (int k = rowIndex; k < row; k++)
        {
            if (ColumnList[colIndex,k]==LastName){
                RowSpan++;
            }else{
                LastName = ColumnList[colIndex, k];
            }
        }
        return RowSpan;
    }
    /**//// <summary>
    /// 取得和当前索引行及列对应的下级的内容所跨的列数
    /// </summary>
    /// <param name="ColumnList">表头集合</param>
    /// <param name="row">行数</param>
    /// <param name="col">列数</param>
    /// <param name="rowIndex">行索引</param>
    /// <param name="colIndex">列索引</param>
    /// <returns>列数</returns>
    private int GetSpanColCount(string[,] ColumnList,int row, int col,int rowIndex, int colIndex)
    {
        string LastName = ColumnList[colIndex, rowIndex] ;
        int ColSpan = ColumnList[colIndex, row-1].Split(new char[] { ',' }).Length;
        ColSpan = ColSpan == 1 ? 0 : ColSpan;
        for(int i=colIndex+1;i<col;i++)
        {
            if (ColumnList[i, rowIndex] == LastName)
            {
                ColSpan += ColumnList[i, row - 1].Split(new char[] { ',' }).Length;
            }
            else
            {
                LastName = ColumnList[i, rowIndex];
                break;
            }
        }
        return ColSpan;
    }
    /**//// <summary>
    /// 将已定义的表头保存到数组
    /// </summary>
    /// <param name="newHeaders">新表头</param>
    /// <param name="row">行数</param>
    /// <param name="col">列数</param>
    /// <returns>表头数组</returns>
    private string[,] ConvertList(string newHeaders, int row, int col)
    {
        string[] ColumnNames = newHeaders.Split(new char[] {'#'});
        string[,] news = new string[col, row];
        string Name = "";
        for (int i = 0; i < col; i++)
        {
            string[] CurrColNames = ColumnNames[i].ToString().Split(new char[] { ' ' });
            for (int k = 0; k < row; k++)
            {
                if (CurrColNames.Length - 1 >= k)
                {
                    if (CurrColNames[k].Contains(","))
                    {
                        if (CurrColNames.Length != row)
                        {
                            if (Name == "")
                            {
                                news[i, k] = news[i, k - 1];
                                Name = CurrColNames[k].ToString();
                            }
                            else
                            {
                                news[i, k + 1] = Name;
                                Name = "";
                            }
                        }else{
                            news[i, k] = CurrColNames[k].ToString();
                        }
                    }else{
                        news[i, k] = CurrColNames[k].ToString();
                    }
                }else{
                    if (Name == "")
                    {
                        news[i, k] = news[i, k - 1];
                    }else{
                        news[i, k] = Name;
                        Name = "";
                    }
                }
            }
        }
        return news;
    }
    /**//// <summary>
    /// 取得复合表头的行数
    /// </summary>
    /// <param name="newHeaders">新表头</param>
    /// <returns>行数</returns>
    private int GetRowCount(string newHeaders)
    {
        string[] ColumnNames = newHeaders.Split(new char[] { '#' });
        int Count = 0;
        foreach(string name in ColumnNames){
            int TempCount = name.Split(new char[] { ' ' }).Length;
            if (TempCount > Count)
                Count = TempCount;
        }
        return Count;
    }
    /**//// <summary>
    /// 取得复合表头的列数
    /// </summary>
    /// <param name="newHeaders">新表头</param>
    /// <returns>列数</returns>
    private int GetColCount(string newHeaders)
    {
        return newHeaders.Split(new char[] { '#' }).Length;
    }
   
}
