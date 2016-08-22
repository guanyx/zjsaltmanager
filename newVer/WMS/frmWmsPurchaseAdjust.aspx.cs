using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;
using System.Text;

public partial class WMS_frmWmsPurchaseAdjust : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        script.Append("</script>\r\n");
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
         string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            { 
                case "getPurchaseAdjustList":
                    UIWmsStockInoutAdjust.getAdjustList(this);
                    break;
            }
        }
        catch(System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }

       
    }
}
