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

using ZJSIG.Common.DataSearchCondition;

public partial class SCM_frmReturn : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //单位
        script.Append( "\r\n" );
        script.Append( "var dsUnitList = " );
        script.Append( ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore( ) );

        //获取仓库列表
        script.Append("var dsWareHouse = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this)); 

        //可售商品
        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append(ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleProductStore(this));

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "slrtn", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printPageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printPageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printStyleXml = 'jssaleprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append("</script>\r\n");
        return script.ToString();
    }

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getPrivCode()
    {
        StringBuilder script = new StringBuilder();
        if (ValidateControlActionRight("配送直出库"))
        {
            script.Append(", '-', { \r\n");
            script.Append("text: \"生成入仓单\", \r\n");
            script.Append("icon: \"../Theme/1/images/extjs/customer/edit16.gif\", \r\n");
            script.Append("handler: function() { generateInStockOrderWin(); } }\r\n");
        }
        return script.ToString();
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                //退货单列表
                case "getReturnList":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getReturnList(this);
                    break;
                //可退订单列表
                case "getOrderList":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getOrderList(this);
                    break;
                //可退订单明细列表
                case "getOrderDtlList":
                    ZJSIG.UIProcess.SCM.UIScmOrderDtl.getDtlList(this);
                    break;
                //新增时保存
                case "saveAdd":
                    ZJSIG.UIProcess.SCM.UIScmReturn.saveAdd(this);
                    break;
                //修改时取退货单明细
                case "getReturnDtlList":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getReturnDtlList(this);
                    break;
                //修改时取退货单主表
                case "getAttr":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getAttr(this);
                    break;
                //编辑时保存
                case "saveUpdate":
                    ZJSIG.UIProcess.SCM.UIScmReturn.saveUpdate(this);
                    break;
                //删除数据
                case "delete":
                    ZJSIG.UIProcess.SCM.UIScmReturn.delete(this);
                    break;
                case "checkReturn":
                    ZJSIG.UIProcess.SCM.UIScmReturn.resetOrder(this);
                    break;
                case "getCustomers":
                    ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleCustomerListForDropDownList(this);
                    break;
		        case"getreturndetailinfo":
                    ZJSIG.UIProcess.SCM.UIScmReturn.getReturnDetailInfo( this );
                    break;
                case"getprintdata":
                    DataSet ds = ZJSIG.UIProcess.SCM.UIScmReturn.getPrintData( this );
                    //余杭公司销售和金额做负处理
                    if ( this.OrgID == 25 )
                    {
                        foreach ( DataRow dr in ds.Tables[ 1 ].Rows )
                        {
                            dr[ "SaleQty" ] = -double.Parse( dr[ "SaleQty" ].ToString( ) );
                            dr[ "SaleAmt" ] = -double.Parse( dr[ "SaleAmt" ].ToString( ) );
                        }
                    }
                    string str = ToDataSetString( ds );
                    this.Response.Write( str );
                    this.Response.End( );
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

}
