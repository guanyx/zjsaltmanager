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
using ZJSIG.UIProcess.RPT.WMS;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.ADM;
using System.Text;

public partial class RPT_WMS_frmWmsStockDayStat : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        script.Append( "\r\n" );
        script.Append( "var dsWarehouseList = " );
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );
        
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    /// <summary>
    /// 仓库进出类型
    /// </summary>
    public string[][] WhType = UISysDicsInfo.getSysDicsInfoList( "W02" );

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case "getlist":
                UIWmsStockDayStat.getViewList( this );
                break;
        }
    }
}
