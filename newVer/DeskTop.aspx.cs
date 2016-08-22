using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class DeskTop : PageBase
{
    /// <summary>
    /// 告警信息
    /// </summary>
    public string alertMsg = "";

    public bool is_wh_alerm = false;
    public bool is_pay_alerm = false;
    public bool is_receive_alerm = false;
    public bool is_send_alerm = false;

    public string server_date = DateTime.Now.ToShortDateString();

    protected void Page_Load( object sender, EventArgs e )
    {
        //通过权限获取预警信息
        //alertMsg = "仓库超储预警：<a href=\"viewDtal.aspx?ProductId=1\"target=\"_blank\">日晒盐50公斤</a>";        
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
            case "getMessageList":
                ZJSIG.UIProcess.BA.UISysMessage.getMessageList( this );
                break;
            case "getWhAlermList":
                ZJSIG.UIProcess.WMS.UIWmsWarningSetting.getWhLimitAlerm( this );
                break;
            case "getPayableAlermList":
                ZJSIG.UIProcess.FM.UIFmAccountsPayableCfg.getPayableAlerm( this );
                break;
            case "getReceiveAlermList":
                ZJSIG.UIProcess.FM.UIFmAccountsPayableCfg.getReceivableAlerm( this );
                break;
            case "getSendAlermList":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getPurchaseSendAlerm( this );
                break;
            case "getPurchaseAlermList":
                ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getPurchaseSubmitAlerm(this);
                break;
            case "getDistributeAlermList":
                ZJSIG.UIProcess.SCM.UIScmSupplierSendMst.getDistributeAlerm(this);
                break;
            #region 右下角提示泡泡用
            case "getPurchaseCount":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getAlermCount(this, "purchase");
                break;
            case "getDistributeCount":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getAlermCount(this, "distribute");
                break;    
            case "getStockCount":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getAlermCount(this, "stock");
                break;
            case "getWharehouseCount":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getAlermCount(this, "wharehouse");
                break;
            case "getReceiveCount":
                ZJSIG.UIProcess.WMS.UIWmsPurchaseOrder.getAlermCount(this, "receive");
                break;
            #endregion
            default:
                if ( OrgID != 1 )
                {//子公司
                    is_wh_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight( this, "仓库预警" );
                    is_pay_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight( this, "应付款提醒" );
                    is_receive_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight( this, "应收款提醒" );
                    is_send_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight( this, "采购入库提醒" );
                }
                break;
        }

        
    }
}
