﻿using System;
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
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.Common;
using ZJSIG.Common.DataSearchCondition;

public partial class PMS_frmPmsStockOrder : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //操作状态
        script.Append( "var dsStatus = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( CommonDefinition.PMS_WS_ORDER_TYPE ) );


        //车间列表
        script.Append( "var dsWs = " );
        script.Append( ZJSIG.UIProcess.PMS.UIPmsWorkshop.getWorkshopListStore( this ) );
        
        //获取仓库        
        script.Append( "var dsWarehouseList = " );
        script.Append( UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //获取商品列表(应该是供应商下面的小类，这里应该管理进去供应商)
        script.Append( "\r\n" );
        script.Append( "var dsProductList = " );
        script.Append( UIBaProduct.getProductListInfoStore( this ) );

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
            script.Append( "var printStyleXml = 'jspmsorderprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =355;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
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
            case "addOrder":
                ZJSIG.UIProcess.PMS.UIPmsStockOrder.addOrder( this );
                break;
            case "saveOrder":
                ZJSIG.UIProcess.PMS.UIPmsStockOrder.editOrder( this );
                break;
            case "deleteOrder":
                ZJSIG.UIProcess.PMS.UIPmsStockOrder.deleteOrder( this );
                break;
            case "getorder":
                ZJSIG.UIProcess.PMS.UIPmsStockOrder.getOrder( this );
                break;
            case "getOrderList":
                ZJSIG.UIProcess.PMS.UIPmsStockOrder.getOrderList( this );
                break;
            case"getprintdata":
                System.Data.DataSet ds =ZJSIG.UIProcess.PMS.UIPmsStockOrder.getPmsStockOrderPrintData( this );
                string str = ToDataSetString( ds );
                this.Response.Write( str );
                this.Response.End( );
                break;
        }
    }
}
