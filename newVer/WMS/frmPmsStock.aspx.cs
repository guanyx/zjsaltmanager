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
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;

public partial class WMS_frmPmsStock : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取仓库列表
        script.Append( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );
        //获取车间列表
        script.Append("var dsWorkShopList = ");
        script.Append(ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopListStore(this));

        //质检状态
        script.Append("\r\n");
        script.Append("var dsCheckStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['CheckId','CheckName'],\r\n");
        script.Append("data:[['0','未质检'],['1','已质检']],\r\n");
        script.Append("autoLoad: false});\r\n");


        //生产类型
        script.Append("var dsProduceType = ");
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "P04" ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch ( method )
            {
                case "getPmsStockList":
                    ZJSIG.UIProcess.PMS.UIPmsStockOrder.getOrderListForWh(this);
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
