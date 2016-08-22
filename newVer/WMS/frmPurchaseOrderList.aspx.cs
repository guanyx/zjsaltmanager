using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.CRM;
using ZJSIG.Common.DataSearchCondition;

public partial class WMS_frmPurchaseOrderList : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        script.Append("\r\n");
        script.Append("var dsWarehouseList = ");
        //script.Append(UIWmsWarehouse.getWarehouseListInfoStore(this));
        script.Append( UIWmsWarehouse.getWarehouseListInfoStoreByEmpId( this ) );

        script.Append("\r\n");
        script.Append("var dsBillType = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("W01"));

        script.Append("\r\n");
        script.Append("var dsBillStatus = new Ext.data.SimpleStore({\r\n");
        script.Append("fields:['BillStatusId','BillStatusName'],\r\n");
        script.Append("data:[['0','未入仓'],['1','已入仓']],\r\n");
        script.Append("autoLoad: false});\r\n");

        script.Append("\r\n");
        script.Append("var dsSuppliesListInfo = ");
        script.Append(UIBusinessCrmCustomer.getSuppliesListInfoStore());

        //权限控制
        script.Append(setToolBarVisible());

        //入库单（含税）
        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "purch", Condition.CompareType.Equal ) );
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
            script.Append( "var printStyleXml = 'jspurchprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =355;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }
        //不含税打印格式
        query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "notaxpurch", Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmPrintset";
        ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        if ( ds.Tables[ 0 ].Rows.Count > 0 )
        {
            script.Append( "var printNoTaxStyleXml='" + ds.Tables[ 0 ].Rows[ 0 ][ "PrintStyleXml" ].ToString( ) + "';\r\n" );
        }
        else
        {
            script.Append( "var printNoTaxStyleXml='jsnotaxpurchprint.xml';" );
        }

        //入库单（财务版本）
        query = new ZJSIG.Common.DataSearchCondition.QueryConditions();
        query.Condition.Add(new Condition("PrintType", "purchV2", Condition.CompareType.Equal));
        query.Condition.Add(new Condition("OrgId", OrgID, Condition.CompareType.Equal));
        query.TableName = "AdmPrintset";
        ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery(1, 0, query, "");
        if (ds.Tables[0].Rows.Count > 0)
        {
            DataRow dr = ds.Tables[0].Rows[0];
            script.Append("var printStyleXmlV2 = '" + dr["PrintStyleXml"].ToString() + "';\r\n");
        }
        else
        {
            script.Append("var printStyleXmlV2 = 'jspurchprint.xml';\r\n");
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

        script.Append("</script>\r\n");
        return script.ToString();
    }

    private string setToolBarVisible()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function setToolBarVisible(toolBar)\r\n");
        script.Append("{\r\n");
        if (!ValidateControlActionRight("采购金额调整"))
        {
            script.Append(" setToolBarButtonHidden(toolBar.items.items.length-1,toolBar);\r\n");
        }
        script.Append("}\r\n");
        script.Append("function setToolBarButtonHidden(i,toolBar)\r\n");
        script.Append("{\r\n");
        script.Append("toolBar.items.items[i].setVisible(false);\r\n");
        script.Append("toolBar.items.removeAt(i);\r\n");
        script.Append("toolBar.items.items[i-1].setVisible(false);\r\n");
        script.Append("toolBar.items.removeAt(i-1);\r\n");
        script.Append("}\r\n");
        return script.ToString();

    }
    protected string setPrintPrivilege()
    {
        //海宁公司打印要除税和含税一起显示
        StringBuilder pscript = new StringBuilder();
        if (!ValidateControlActionRight("含税和去税会并打印"))
        {
            pscript.Append("Ext.getCmp('mixedprint').hide();\r\n");
        }
        return pscript.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        string method = Request.QueryString["method"];
        switch (method)
        {
            case "getPurchaseOrderList":
                UIWmsPurchaseOrder.getOrderList(this);
                break;
            case"cancelSplit":
                UIWmsPurchaseOrder.CancelShippingOrderSplit( this );
                break;
            case"getdetailinfo":
                UIWmsPurchaseOrder.getPurchaseDetailInfo( this );
                break;
            //case "getprintdata":
            //    System.Data.DataSet ds = UIWmsPurchaseOrder.getPurchPrintData( this );
            //    string str = ToDataSetString( ds );
            //    this.Response.Write( str );
            //    this.Response.End( );
            //    break;
            case "getprintdata":
                System.Data.DataSet dsNoTax = UIWmsPurchaseOrder.getPurchPrintData( this );
                dsNoTax.Tables[1].Columns.Add( "NoTaxAmt", typeof( System.Decimal ) );
                dsNoTax.Tables[1].Columns.Add("NoTaxPrice", typeof(System.Decimal));
                dsNoTax.Tables[1].Columns.Add("Tax", typeof(System.Decimal), "Amt-NoTaxAmt");
                dsNoTax.Tables[1].Columns.Add("TaxRateStr");
                foreach ( DataRow dr in dsNoTax.Tables[ 1 ].Rows )
                {
                    decimal rate = decimal.Parse(dr["TaxRate"].ToString());
                    dr[ "NoTaxPrice" ] = System.Math.Round( 1 / ( 1 + rate ) * decimal.Parse( dr[ "ProductPrice" ].ToString( ) ), 7 );
                    dr[ "NoTaxAmt" ] = System.Math.Round( 1 / ( 1 + rate ) * decimal.Parse( dr[ "Amt" ].ToString( ) ), 2 );
                    //税率转百分比显示
                    dr["TaxRateStr"] = dr["TaxRate"].ToString().Replace("0.", "") + "%";                    
                }
                
                string str1 = ToDataSetString( dsNoTax );
                this.Response.Write( str1 );
                this.Response.End( );
                break;
            case "getrateprintdata":
                System.Data.DataSet dsRate = UIWmsStockInout.getPurchPrintData( this );
                string strRate = ToDataSetString( dsRate );
                this.Response.Write( strRate );
                this.Response.End( );
                break;
        }
    }
}
