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

public partial class WMS_frmWmsAdminDefine : PageBase
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
        script.Append("\r\n");
        script.Append( "var dsWh =" );
        script.Append( UIWmsWarehouse.getAllWarehouseListInfoStore( this ) );

        //组织下员工
        script.Append("\r\n");
        script.Append( "var dsAdminCombo =" );
        script.Append( UIAdmEmployee.getEmployeeListStore( this) );

        script.Append("\r\n");
        script.Append("var dsStatusList = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['StatusId','StatusName','OrderIndex'],\r\n");
        script.Append("data:[['0','正常','0'],['1','禁用','1']],\r\n");
        script.Append("autoLoad: false});");
        
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

        switch(method)
        {
            case "getDefineList":        
                UIWmsAdminDefine.getDefineList( this );
                break;
            case "getAdminDefineInfo":
                UIWmsAdminDefine.getDefine( this );
                break;
            case "saveDefine":
                UIWmsAdminDefine.saveDefine( this );
                break;
            case "deleteDefine":
                UIWmsAdminDefine.deleteDefine( this );
                break;

        }
        

    }
}
