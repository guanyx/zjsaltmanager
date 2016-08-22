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
using ZJSIG.UIProcess;
using ZJSIG.Common.DataSearchCondition;

public partial class Common_frmDocReport : System.Web.UI.Page
{
    protected string createDocHtml( )
    {
        string empId = this.Request.QueryString[ "ReportId" ];
        if ( empId == "" || empId == null )
        {
            return "";
        }
        //Uri.UnescapeDataString( );
        QueryConditions query = new QueryConditions( );
        switch ( System.Web.HttpUtility.UrlDecode(this.Request.QueryString[ "ReportName" ]))
        {
            case"员工简历表":
                query.TableName = "AdmEmployee";
                query.Condition.Add( new ZJSIG.Common.DataSearchCondition.Condition( "EmpId", empId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                DataSet ds = UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                ds.Tables[ 0 ].TableName = "AdmEmployee";
                return "<script>" + ZJSIG.UIProcess.ADM.UIAdmDocReport.setPageScript( "员工简历表", ds ) + "</script>";
            case"销售发货单":
                query.TableName = "VScmOrdermst";
                query.Condition.Add( new Condition( "OrderId", empId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.Equal ) );
                DataSet dsOrder = UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                dsOrder.Tables[ 0 ].TableName = "VScmOrderMst";
                query.TableName = "VScmOrderdtl";
                DataSet dsTemp = UIProcessBase.getDataSetByQuery( 1000, 0, query, "" );
                DataTable dt = dsTemp.Tables[ 0 ];
                dsTemp.Tables.Remove( dt );
                dt.TableName = "VScmOrderDtl";
                dsOrder.Tables.Add( dt );
                UIProcessBase.ConvertDataTableColumn( dsOrder.Tables[ 0 ] );
                UIProcessBase.ConvertDataTableColumn( dsOrder.Tables[ 1 ] );
                string script = ZJSIG.UIProcess.ADM.UIAdmDocReport.setPageScript( "销售发货单", dsOrder );
                return "<script>" + script + "</script>";
            case"余杭销售发货单":
                query.TableName = "VScmOrdermst";
                query.Condition.Add(new ZJSIG.Common.DataSearchCondition.Condition("OrderId", empId, ZJSIG.Common.DataSearchCondition.Condition.CompareType.SelectIn));
                DataSet dsOrd = UIProcessBase.getDataSetByQuery(20, 0, query, "");

                dsOrd.Tables[ 0 ].Columns.Add( "rmb" );
                dsOrd.Tables[ 0 ].Columns.Add( "bill_receiver" );
                foreach ( DataRow dr in dsOrd.Tables[ 0 ].Rows )
                {
                    ZJSIG.UIProcess.Common.NumToChina china = new ZJSIG.UIProcess.Common.NumToChina(
                        double.Parse(dr[ "SaleTotalAmt" ].ToString( ) ) );
                    dr[ "rmb" ] = china.ChinaNum;
                }

                dsOrd.Tables[0].TableName = "VScmOrderMst";
                query.TableName = "VScmOrderdtl";
                DataSet dsOrdDtl = UIProcessBase.getDataSetByQuery(1000, 0, query, "");
                
                DataTable dtDtl = dsOrdDtl.Tables[0];
                dsOrdDtl.Tables.Remove(dtDtl);
                dtDtl.TableName = "VScmOrderdtl";
                dsOrd.Tables.Add(dtDtl);
                string script1 = ZJSIG.UIProcess.ADM.UIAdmDocReport.setPageScript("余杭销售发货单", dsOrd,"OrderId");
                return "<script>" + script1 + "</script>";
            case"store":
                string scriptExcel = ZJSIG.UIProcess.ADM.UIAdmDocReport.setExcelPageScript( "store.xls" );
                return "<script>" + scriptExcel + "</script>"; 
            case"excel":
                string fileName = this.Request[ "FileName" ];
                string scriptExcel1 = ZJSIG.UIProcess.ADM.UIAdmDocReport.setExcelPageScript( fileName );
                return "<script>" + scriptExcel1 + "</script>"; 
                break;
            default:
                string script2 = ZJSIG.UIProcess.ADM.UIAdmDocReport.getDefaultPrintScript(this);
                return "<script>" + script2 + "</script>";
                
        }
        return "";
        
    }
    protected void Page_Load( object sender, EventArgs e )
    {

    }
}
