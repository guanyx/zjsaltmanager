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

public partial class BI_frmETLData : PageBase
{
    protected string getComboBoxStore( )
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取组织
         //这个变量名界面combobox需要使用，保持一致
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        //script.Append(ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore(this));
        

        ZJSIG.UIProcess.BI.ETLProductData e = new ZJSIG.UIProcess.BI.ETLProductData( );
        e.OrgId = this.OrgID;
        DateTime dt = e.getLastImportDate( );
        if ( OrgID == 1 )
            dt = new DateTime( 2010, 4, 1 );
        script.AppendLine( "var startDate = " + dt.Year.ToString( ) + ";" );
        script.AppendLine( "var month=" + dt.Month.ToString( ) + ";" );
        script.AppendLine( "var orgId = " + this.OrgID.ToString( ) + ";" );
        if ( this.OrgID > 1 )
        {
            script.AppendLine( "var dsOrg = new Ext.data.SimpleStore({fields:['OrgId','OrgName','OrgShortName'],data:[['" +
                this.OrgID.ToString( ) + "','" + this.OrgName + "','" + this.OrgName + "']],autoLoad: false});" );
        }
        else
        {
            script.AppendLine( "var dsOrg = "+ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgListStore( this ) );
        }

        string memo="当前数据到{0}，可以对{1}数据进行导入，或者对{0}数据进行清除";
        if ( this.OrgID > 1 )
        {
            script.AppendLine( "var memo='" + string.Format( memo, dt.ToString( "yyyy年MM月" ), dt.AddMonths( 1 ).ToString( "yyyy年MM月" ) ) + "';" );
        }
        else
        {
            //script.Append( "var dsOrg = " ); 
            script.AppendLine( "var memo='可以对BI数据进行全部从新导入，包括商品数据和业务数据！';" );
        }

        script.AppendLine( "</script>" );

        
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        ZJSIG.UIProcess.BI.ETLProductData etl = new ZJSIG.UIProcess.BI.ETLProductData( );

        long orgId = 0;
        switch ( this.Request[ "Method" ] )
        {
            case"Org":
                etl.ETLOrgData( );
                this.Response.End( );
                break;
            case"Product":
                etl.ETLRealProductData( );
                etl.ETLProductUnitsData( );
                //etl.ETLDateData( );
                etl.ETLProductUnitData( );
                etl.ETLTableData( "VReportClassRealProduct", "VReportClassRealProduct" );
                etl.ETLTableData( "VReportClassProduct", "VReportClassProduct" );
                this.Response.End( );
                break;
            case"OrgCustomer":

                try
                {
                    orgId = long.Parse( this.Request[ "OrgId" ] );
                    DateTime start1 = DateTime.Parse( this.Request[ "StartDate" ] );
                    if ( this.OrgID > 1 )
                    {
                        canImportData( start1, orgId );
                    }
                    etl.OrgId = orgId;
                    etl.ETLCustomerData( );
                    etl.ETLRouteData( );
                    etl.ETLProductIndividualData( );
                    etl.ETLCloseDayData( );
                    //etl.ETLProductCostData( );
                    //etl.ETLProductCostData( );
                }
                catch
                {
                }
                this.Response.End( );
                break;
            case"OrgStore":
                orgId = long.Parse( this.Request[ "OrgId" ] );
                etl.OrgId = orgId;
                DateTime start = DateTime.Parse( this.Request[ "StartDate" ] );
                //DateTime end = DateTime.Parse( this.Request[ "EndDate" ] );
                etl.StartDate = start;
                //etl.EndDate = start.AddMonths( 1 ).AddDays( -1 );
                etl.ETLDayBillData( );
                etl.ETLCrmDayProduct( );
                etl.ETLProductCostData( );
                etl.ETLDayProductStoreData( );
                this.Response.End( );
                break;
            case"Clear":
                orgId = long.Parse( this.Request[ "OrgId" ] );
                etl.OrgId = orgId;
                DateTime start2 = DateTime.Parse( this.Request[ "StartDate" ] );
                etl.StartDate = start2;
                canImportData( start2, orgId );
                etl.clearOrgDayData( );
                break;
            case"Mining":
                //ZJSIG.UIProcess.BI.BIDataMining mining = new ZJSIG.UIProcess.BI.BIDataMining( );
                //DateTime dt = DateTime.Now;
                //DataSet 0ds = mining.getReportData( );
                //TimeSpan s = DateTime.Now - dt;
                //this.Response.Write( s.Seconds );
                //this.Response.End( );
                this.Response.End( );
                break;
        }
    }

    private void canImportData( DateTime startDate,long orgId )
    {
        ZJSIG.UIProcess.BI.ETLProductData etl = new ZJSIG.UIProcess.BI.ETLProductData( );
        etl.OrgId = orgId;
        try
        {
            etl.StartDate = startDate.AddMonths( -1 );
            //上月数据已经存在，那么再检查下个月的数据
            if ( etl.checkExistsData( ) )
            {
                try
                {
                    etl.StartDate = startDate.AddMonths( 1 );
                }
                catch
                {
                    
                }
                if ( etl.checkExistsData( ) )
                {
                    throw new Exception( "下个月的数据已经存在，不能重新导入数据，请先删除下个月的数据在导入本月数据！" );
                }
            }
        }
        catch(Exception ep)
        {
            throw new Exception( ep.Message);
        }
    }
}
