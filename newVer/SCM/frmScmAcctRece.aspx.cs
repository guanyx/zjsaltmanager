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

public partial class SCM_frmScmAcctRece : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //付款类型
        script.Append("var dsPayType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(this,"F01"));

        //业务种类
        script.Append("var dsBizType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("F06"));

        //借贷方向
        script.Append("var dsFundType = new Ext.data.SimpleStore({");
        script.Append("fields:['DicsCode','DicsName','OrderIndex'],");
        script.Append("data:[['F051','应收','1'],['F052','收款','2']],autoLoad: false});");
        //script.Append("data:[['F051','借','1'],['F052','贷','2']],autoLoad: false}););");

        string strOrderId = this.Request.QueryString[ "strOrderId" ];
        string strBillType = this.Request.QueryString[ "billtype" ];
        script.Append( "var orderidid='" + strOrderId + "';" );
		if (strOrderId != null && !"0".Equals(strOrderId) && !"".Equals(strOrderId) && !"-1".Equals(strOrderId)
            && !"2".Equals(strBillType))
		{
            ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions();
            query.TableName = "ScmOrderMst";
            query.Columns = "Pay_Type";
            query.Condition.Add(new ZJSIG.Common.DataSearchCondition.Condition("OrderId", strOrderId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.SelectIn));
            DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery(1, 0, query, "");
            ZJSIG.ADM.BusinessEntities.SysDicsInfo item = ZJSIG.ADM.BLL.BLSysDicsInfo.GetModel(ds.Tables[0].Rows[0][0].ToString());
            script.Append("var strPayType = '" + item.Remark + "';");
        }
        else
        {
            script.Append("var strPayType = 'F011';");//现结
        }


        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = Request.QueryString["method"];

        switch (method)
        {            
            //保存收款记录
            case "saveAdd":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.saveAcctReceRecord(this);
                break;
            case "saveRed":
                ZJSIG.UIProcess.SCM.UIScmBillManage.generAccount(this);
                break;
        }

    }
}
