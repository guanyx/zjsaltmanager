using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using ZJSIG.UIProcess.BA;

public partial class QT_frmQtZJTemplate : PageBase
{

    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );


        script.Append( "var allQuotaStore =" );
        script.Append( ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.getAllQuotaStore());

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender , EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString[ "method" ];
        }
        catch ( Exception ex )
        {
        }
        switch ( method )
        {
            case "saveOrder":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.saveOrder( this );
                break;
            case "queryNT":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.queryNT( this );
                break;
            case "delnt":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.deleteCfgDT( this );
                break;
            case "getNTdetail":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaDtCfg.getCfgList( this );
                break;
            case "getAllQuota": 
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.getAllQuota( this );
                break;
            case "getReport":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.getReport1( this );
                break;
            case "updateOrder":
                ZJSIG.UIProcess.QT.UIQtNotifyFormulaCfg.updateOrder( this );
                break;
            case "outExcel":
                GridExportExcel( this );
                break;
        }
    }

    public static void GridExportExcel(Page p)
      {
          HttpResponse resp = p.Response;
          resp.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
          resp.AppendHeader( "Content-Disposition" , "attachment;filename=" + p.Request.Params[ "title" ] + ".xls" );
          resp.ContentType = "application/ms-excel";
          string s = p.Request.Params[ "outstring" ];
          s=s.Replace("&nbsp;"," "); 
          resp.Write(s);
          resp.End(); 
     }

}
