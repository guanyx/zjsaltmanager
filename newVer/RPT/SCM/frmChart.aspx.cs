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
using System.Text;
using ZJSIG.UIProcess.Graph;

public partial class RPT_SCM_frmChart : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //第一次浏览本页
            //1.根据url中get过来的图表类型，设置查询条件，并赋值到界面的condDiv层，如果没有则跳过
            string ChartType = Request.QueryString["ChartType"];
            if (!string.IsNullOrEmpty(ChartType))
                initConditionsByChartType(ChartType);
            

            //2.如果是查询数据，则回写图表xml片段，并执行加载数据
            string StaticsType = Request.QueryString["StaticsType"];
            if (!string.IsNullOrEmpty(StaticsType))
                generatorChartByStaticsType(StaticsType);


        }
    }

    /// <summary>
    /// 1.根据Url的ChartType来初始化相应的查询条件，经过组装放到层condDiv中
    /// 2.回写客户端触发得到数据的控件的脚本(其中应该包括url中增加StaticsType属性和对应的查询条件)
    /// 3.根据需要往客户端写好各个图形之间的切换方法updateChart
    ///     可以回写多个按钮，每个按钮对应一个类型的图形展示(执行updateChart方法)
    /// </summary>
    /// <param name="chartType"></param>
    /// <returns></returns>
    private void initConditionsByChartType(string chartType)
    {        
        string initCompnentAmdScriptStr = "";
        switch (chartType)
        {
            case "getInitTest":
                initCompnentAmdScriptStr = UIChart.getTestInitCompnentAndScript(this);
                break;
            default:
                break;
        }
        
        init.InnerHtml = initCompnentAmdScriptStr;

    }

    /// <summary>
    /// 根据初始化查询条件的统计类型StaticsType得到查询条件并组装返回的xml片段，最后执行客户端数据加载到chartDiv层中
    /// </summary>
    /// <param name="staticType"></param>
    /// <returns></returns>
    private void generatorChartByStaticsType(string staticType)
    {
        string xmlwrapper = "";
        switch (staticType)
        {
            case "getTestData":
                xmlwrapper = UIChart.getTestXmlWrapper(this);
                break;
            default:
                break;
        }

        //xmlwrapper = "<graph bgColor='F3F3F3' showAlternateHGridColor='1' caption='全省购销存统计' subcaption='测试子标题' xAxisName='盐种' yAxisName='数量' ><Set Name='购进' Value='46042283.10' ></Set><Set Name='销售' Value='46042283.10'  ></Set><Set Name='库存' Value='46042283.10'  ></Set></graph> ";

        Response.Write(xmlwrapper);
        Response.End();
    }
}
