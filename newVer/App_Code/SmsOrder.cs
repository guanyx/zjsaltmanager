using System;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using ZJSIG.Common.DataSearchCondition;

/// <summary>
///SmsOrder 的摘要说明
/// </summary>
[WebService( Namespace = "http://tempuri.org/" )]
[WebServiceBinding( ConformsTo = WsiProfiles.BasicProfile1_1 )]
//若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。 
[System.Web.Script.Services.ScriptService]
public class SmsOrder : System.Web.Services.WebService
{

    public SmsOrder( )
    {

        //如果使用设计的组件，请取消注释以下行 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld( )
    {
        return "Hello World";
    }

    [WebMethod]
    /// <summary>
    /// 获取需要发送的短信信息
    /// </summary>
    /// <returns></returns>
    public string getSendSms( )
    {
        string message = ZJSIG.UIProcess.UIProcessBase.getSendSms( );
        return message;
    }

    [WebMethod]
    /// <summary>
    /// 新增短信订单
    /// </summary>
    /// <param name="orderMessage">短信订单内容</param>
    /// <returns>返回翻译后的订单信息</returns>
    public string AddSmsOrder(string orderMessage )
    {
        //ZJSIG.UIProcess.Log.WriteLog( orderMessage, this.Server.MapPath( "" ) + "\\log1.txt" );
        string message = ZJSIG.UIProcess.SCM.UIScmOrderDtl.saveSMSOrder( orderMessage );
        return message;
    }

    [WebMethod]
    /// <summary>
    /// 新增语音订单
    /// </summary>
    /// <param name="orderMessage">语音订单内容</param>
    /// <returns>返回翻译后的订单信息</returns>
    public string AddInvoiceOrder(string orderMessage )
    {
        if ( orderMessage == null || orderMessage == "" )
        {
            ZJSIG.UIProcess.Log.WriteLog( "上发语言串未空，返回成功！", this.Server.MapPath( "" ) + "\\log1.txt" );
            return "true";
        }

        ZJSIG.UIProcess.Log.WriteLog( orderMessage, this.Server.MapPath( "" ) + "\\log1.txt" );
        string message = ZJSIG.UIProcess.SCM.UIScmOrderDtl.saveInvoiceOrder( orderMessage 	);
        return message;//成功请返回"true"
        //return "true";
    }

    #region 宁波公司使用
    [WebMethod]
    /// <summary>
    /// 宁波公司订单同步
    /// </summary>
    /// <param name="orderMessage">订单内容</param>
    /// <returns>返回订单编号或错误信息</returns>
    public string SyncOrder(string orderMessage)
    {
        return ZJSIG.UIProcess.SCM.UIScmOrderDtl.SyncOrder(orderMessage);
    }
    [WebMethod]
    /// <summary>
    /// 宁波公司退货单同步
    /// </summary>
    /// <param name="orderMessage">退货单内容</param>
    /// <returns>返回退货单编号或错误信息</returns>
    public string SyncReturnOrder(string orderMessage)
    {
        return ZJSIG.UIProcess.SCM.UIScmOrderDtl.SyncReturnOrder(orderMessage);
    }
    [WebMethod]
    /// <summary>
    /// 宁波公司自主采购单同步
    /// </summary>
    /// <param name="orderMessage">采购单内容</param>
    /// <returns>返回仓库入库单编号或错误信息</returns>
    public string SyncSelfPurchOrder(string orderMessage)
    {
        return ZJSIG.UIProcess.SCM.UIScmOrderDtl.SyncSelfPurchOrder(orderMessage);
    }
    #endregion

    [WebMethod]
    /// <summary>
    /// 获取订购的机构信息
    /// </summary>
    /// <returns></returns>
    public string GetSmsOrg( )
    {
        ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions();
        query.Condition.Add(new Condition("IsActive",1,Condition.CompareType.Equal));
        query.TableName="AdmOrgSms";
        System.Data.DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 100, 0, query, "" );
        string smsOrg = "";
        foreach ( System.Data.DataRow dr in ds.Tables[ 0 ].Rows )
        {
            if ( smsOrg.Length > 0 )
                smsOrg += "$";
            smsOrg += string.Concat( dr[ "OrgApiname" ], ",", dr[ "OrgUserName" ], ",", dr[ "OrgUserPassWord" ] );
        }
        return smsOrg;
    }

}

