using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class SCM_frmCustomerBillEdit : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        script.Append( "var curUserId = " + this.EmployeeID.ToString( ) + ";" );

        script.Append( "var curUserName = \"" + ZJSIG.UIProcess.ADM.UIAdmUser.EmployeeName( this ) + "\";" );

        long customerId = 0;
        long.TryParse( this.Request.QueryString[ "strCustomerId" ],out customerId );
        ZJSIG.CRM.BusinessEntities.BusinessCrmCustomer item = 
            ZJSIG.CRM.BusinessLogic.BLCrmCustomer.GetCustomer(customerId);
        script.Append( "var strCustomerName = '" + item.ChineseName + "';\r\n" );

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
                case "getSumOrderList"://获取合计数据
                    ZJSIG.UIProcess.SCM.UIScmBillManage.getCustomerNoBillOrderList( this );
                    break;
                //case "saveAdd"://保存蓝字发票
                //    ZJSIG.UIProcess.SCM.UIScmBillManage.saveBillRecord( this );
                //    break;
                //case "saveRed"://保存红字发票
                //    ZJSIG.UIProcess.SCM.UIScmBillManage.saveRedBillRecord( this );
                //    break;

            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
