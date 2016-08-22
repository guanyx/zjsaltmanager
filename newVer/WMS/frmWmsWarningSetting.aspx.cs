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
using ZJSIG.UIProcess.Common;
using System.Text;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;

public partial class WMS_frmWmsWarningSetting : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //仓库列表
        script.Append( "var dsWh =" );
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //算法下拉框
        script.Append( "var dsWarningType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.WMS_WARNING_TYPE ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
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

            case "addSetting":
                UIWmsWarningSetting.addSetting( this );
                break;
            case "saveSetting":
                UIWmsWarningSetting.editSetting( this );
                break;
            case "getSetting":
                UIWmsWarningSetting.getSetting( this );
                break;
            case "getSettingList":
                UIWmsWarningSetting.getSettingList( this );
                break;
            case "deleteSetting":
                UIWmsWarningSetting.deleteSetting( this );
                break;
            case "getProducts":
                UIBaProduct.getProductListForDropDownList( this );
                break;
            case "getProductUnits":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStore(this);
                break;
        }
    }
}
