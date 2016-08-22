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
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using System.Text;
using ZJSIG.UIProcess.SCM;

public partial class SCM_frmDeliveryManager : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取权限下的仓库
        script.Append( "var dsWh = " );  //这个变量名界面combobox需要使用，保持一致
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //获取订单类型
        script.Append( "var dsOrderType = " );  
        script.Append( UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_ORDER_TYPE) );
        
        //获取结算方式
        script.Append( "var dsPayType = " );  
        script.Append( UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_PAY_TYPE) );

        //获取送货级别
        script.Append( "var dsDlvLevel = " );  
        script.Append( UISysDicsInfo.getDicsInfoStore(CommonDefinition.SCM_DELIVERY_LEVEL) );

        //获取车辆信息
        script.Append( "var dsVehicle = " );
        script.Append( UIScmVehicleAttr.getVehicleAttrStore(this));

        //驾驶员信息
        script.Append( "var dsDriver = " );
        script.Append( UIScmDriverAttr.getDriverAttrStore(this));
        
        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getOrderList":
                    ZJSIG.UIProcess.SCM.UIScmDrawInv.getOrderListForDlv(this);
                    break;

                case "save":
                    ZJSIG.UIProcess.SCM.UIScmDrawInv.saveDrawInv(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
