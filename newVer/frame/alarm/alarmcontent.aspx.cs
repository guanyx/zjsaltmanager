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

public partial class frame_alarm_Default : PageBase
{
    /// <summary>
    /// 告警信息
    /// </summary>
    public string alertMsg = "";

    public bool is_wh_alerm = false;
    public bool is_pay_alerm = false;
    public bool is_receive_alerm = false;
    public bool is_send_alerm = false;
    public bool is_purchase_alerm = false;
    public bool is_distribute_alerm = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (OrgID != 1)
        {//子公司
            is_purchase_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "发运单提醒");
            is_wh_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "仓库预警");
            is_pay_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "应付款提醒");
            is_receive_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "应收款提醒");
            is_send_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "采购入库提醒");
        }
        else
        {
            is_distribute_alerm = ZJSIG.UIProcess.ADM.UIAdmRole.ValidateControlActionRight(this, "发运单提醒");
        }
    }
}
