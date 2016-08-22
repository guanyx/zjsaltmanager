using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BA_product_frmBaSaleProduct : System.Web.UI.Page
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取仓库列表
        script.Append( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );       

        //单位
        script.Append( "\r\n" );
        script.Append( "var dsUnitList = " );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( ) );

        script.Append( "\r\nvar dsCommonStore =new Ext.data.SimpleStore({fields:['Id','Name'],data:[['0','否'],['1','是']],autoLoad: false});\r\n" );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = this.Request.QueryString["method"];
        switch (method)
        {
            case"getlist":                
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleProductList(this);
                break;
            case"save":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.saveSaleProduct(this);
                break;
            case"del":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.delSaleProduct(this);
                break;
            case "getTaxCodes":
                ZJSIG.UIProcess.FM.UIFmSubject.getTaxCfgList(this);
                break;
            case"getProducts":
                ZJSIG.UIProcess.BA.UIBaProduct.getAllProductListForDropDownList( this );
                break;
            case"getreprotunits":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStoreHaveWeight( this );
                break;
            case"stop":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.stopSaleProduct( this );
                break;
            case"restart":
                ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.restartSaleProduct( this );
                break;
        }
    }
}
