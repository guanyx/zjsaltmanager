using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class BA_product_frmBaProductUnitConvert : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取单位
        string dsUnit = ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( );
        script.Append( "var dsUnit =" );
        script.Append( dsUnit );

        //获取被单位
        script.Append( "var dsNewUnit =" );
        script.Append( dsUnit );

        script.Append("var productId=\"" + this.Request.QueryString["productId"] + "\";");
        script.Append("var productName=\"" + this.Request.QueryString["productName"] + "\";");


        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getProducts":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductListForDropDownList( this );
                break;
            case "getUnitConvertInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.getConvert( this );
                break;
            case "addUnitConvertInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.addConvert( this );
                break;
            case "saveUnitConvertInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.editConvert( this );
                break;
            case "deleteUnitConvertInfo":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.deleteConvert( this );
                break;
            case "getUnitCovertList":
                ZJSIG.UIProcess.BA.UIBaProductUnitConvert.getConvertList( this );
                break;
        }

        

    }
}
