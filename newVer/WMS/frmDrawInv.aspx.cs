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
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmDrawInv : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取仓库列表
        script.Append( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //领货单类型
        script.Append("var dsDrawType = ");
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S10" ) );

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "stock", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        System.Data.DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
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
            script.Append( "var printStyleXml = 'jsstockprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =355;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "rate", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            DataRow dr = ds.Tables[ 0 ].Rows[ 0 ];
            script.Append( "var printRateStyleXml = '" + dr[ "PrintStyleXml" ].ToString( ) + "';\r\n" );
            script.Append( "var printRatePageWidth =" + dr[ "PrintPageWidth" ].ToString( ) + ";\r\n" );
            script.Append( "var printRatePageHeight =" + dr[ "PrintPageHeight" ].ToString( ) + ";\r\n" );
            if ( dr[ "PrintOnlyData" ].ToString( ) == "1" )
            {
                script.Append( "var printRateOnlyData = true;\r\n" );
            }
            else
            {
                script.Append( "var printRateOnlyData = false;\r\n" );
            }
        }
        else
        {
            script.Append( "var printRateStyleXml = 'jxrateprint.xml';\r\n" );
            script.Append( "var printRatePageWidth =931;\r\n" );
            script.Append( "var printRatePageHeight =355;\r\n" );
            script.Append( "var printRateOnlyData = false;\r\n" );
        }
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch ( method )
            {
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawInv.getOrderDrawList( this );
                    break;
                case"canceldrawinvwaitout":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.CancelDrawInvWaitOut(this);
                    break;

                case "delDraw":
                    ZJSIG.UIProcess.SCM.UIScmDrawInv.delDrawInv( this );
                    break;
                case "getdrawdetail":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawDetailInfo( this );
                    break;
                case"getprintdata":
                    //try
                    //{
                        System.Data.DataSet ds = UIWmsStockInout.getSalePrintData( this );
                        //ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 0 ] );
                        //ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( ds.Tables[ 1 ] );

                        string str = ToDataSetString( ds );
                        this.Response.Write( str );
                        this.Response.End( );
                    
                    break;
                case"getrateprintdata":
                    System.Data.DataSet dsRate = UIWmsStockInout.getRatePrintData( this );
                    string strRate = ToDataSetString( dsRate );
                    this.Response.Write( strRate );
                    this.Response.End( );
                    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
