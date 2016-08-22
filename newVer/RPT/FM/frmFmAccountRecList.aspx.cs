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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.SCM;

public partial class SCM_FmAccountRecList : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //发运单状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_PROVIDE_SEND_TYPE ) );

        //获取商品列表(应该是供应商下面的小类，这里应该管理进去供应商)
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

        //增加超级权限判断
        script.Append("\r\n");
        if(ValidateControlActionRight("忽略部门过滤"))
            script.Append(" var ignoredept = true; \r\n");
        else
            script.Append(" var ignoredept = false; \r\n");


        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
            switch ( method )
            {
                case "getReceiveList":
                    ZJSIG.UIProcess.FM.UIFmAccountRece.getAccountReceDtlForRPT(this);
                    break;
                case "exportData":
                    ZJSIG.UIProcess.RPT.SCM.UIExportFile.ExportAccountReceivableData(this);
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
