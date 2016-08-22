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

public partial class SCM_frmOrderMst : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取组织
        script.Append("var dsOrg = ");  //这个变量名界面combobox需要使用，保持一致
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        //script.Append(ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore(this));
        script.Append(ZJSIG.UIProcess.ADM.UIAdmOrg.getAllAreaOrgListStoreById(this));

        //获取部门列表
        script.Append( "var dsDept = " );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore( ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) ) );

        //获取仓库列表
        script.Append( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStoreByEmpId( this ) );

        //订单类型
        script.Append("var dsOrderType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S01"));

        //开票方式
        script.Append("var dsPayType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S03"));

        //结算方式
        script.Append("var dsBillMode = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S02"));

        //配送方式
        script.Append("var dsDlvType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S04"));

        //送货等级
        script.Append("var dsDlvLevel = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S05"));

        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        Condition subc = new Condition();
        subc.SubConditions.Add(new Condition("PrintType", "sale", Condition.CompareType.Equal, Condition.OperateType.OR));
        subc.SubConditions.Add(new Condition("PrintType", "saleV2", Condition.CompareType.Equal, Condition.OperateType.OR));
        query.Condition.Add(subc);
        query.Condition.Add(new Condition("OrgId", OrgID, Condition.CompareType.Equal, Condition.OperateType.AND));
        query.TableName = "AdmPrintset";
        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery(2, 0, query, "Printset_Id asc");
        DataRow[] drs = new DataRow[] { };
        if(ds.Tables[0].Rows.Count>0)
            drs = ds.Tables[0].Select("PrintType='sale'");
        #region 默认打印版本
        if (drs.Length > 0)
        {
            DataRow dr = drs[0];
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
            script.Append( "var printStyleXml = 'salePrint1.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = true;\r\n" );
        }
        #endregion
        
        if (ds.Tables[0].Rows.Count > 0)
            drs = ds.Tables[0].Select("PrintType='saleV2'");
        #region 打印更多行版本
        if (drs.Length > 0)
        {
            DataRow dr = drs[0];
            script.Append("var printStyleXmlV2 = '" + dr["PrintStyleXml"].ToString() + "';\r\n");
            script.Append("var printPageWidthV2 =" + dr["PrintPageWidth"].ToString() + ";\r\n");
            script.Append("var printPageHeightV2 =" + dr["PrintPageHeight"].ToString() + ";\r\n");
            if (dr["PrintOnlyData"].ToString() == "1")
            {
                script.Append("var printOnlyDataV2 = true;\r\n");
            }
            else
            {
                script.Append("var printOnlyDataV2 = false;\r\n");
            }
        }
        else
        {
            script.Append("var printStyleXmlV2 = 'salePrint1.xml';\r\n");
            script.Append("var printPageWidthV2 =931;\r\n");
            script.Append("var printPageHeightV2 =365;\r\n");
            script.Append("var printOnlyDataV2 = true;\r\n");
        }
        #endregion


        if ( this.UserID == 1 )
        {
            script.Append( "var viewOrg = false;\r\n" );
        }
        else
        {
            script.Append( "var viewOrg = true;\r\n" );
        }

        script.Append( setToolBarVisible() );
        script.Append("</script>\r\n");
        return script.ToString();
    }

    private string setToolBarVisible( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setToolBarVisible(toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "for(var i=0;i<toolBar.items.items.length;i++)\r\n" );
        script.Append("{\r\n");
        script.Append( "switch(toolBar.items.items[i].text)\r\n" );
        script.Append("{\r\n");

        if ( !ValidateControlActionRight( "订单新增" ) )
        {
            script.Append( "case'新增':\r\n" );
            script.Append( "case'编辑':\r\n" );
            script.Append( "case'删除':\r\n" );
            script.Append( "case'打印':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        if (!ValidateControlActionRight("订单收款"))
        {
            script.Append("case'收款':\r\n");
            script.Append("setToolBarButtonHidden(i,toolBar);\r\n");
            script.Append("i--;\r\n");
            script.Append("break;\r\n");
        }
        if (!ValidateControlActionRight("订单开票"))
        {
            script.Append("case'开票':\r\n");
            script.Append("setToolBarButtonHidden(i,toolBar);\r\n");
            script.Append("i--;\r\n");
            script.Append("break;\r\n");
        }
        if ( !ValidateControlActionRight( "订单出库" ) )
        {
            script.Append( "case'出库':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        if ( this.UserID != 1 )
        {
            script.Append( "case'超级编辑':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "Ext.getCmp('OrgId').setDisable(false);\r\n" );
            script.Append( "break;\r\n" );
        }
        if (!ValidateControlActionRight("设置业务员"))
        {
            script.Append("case'设置业务员':\r\n");
            script.Append("setToolBarButtonHidden(i,toolBar);\r\n");
            script.Append("i--;\r\n");
            script.Append("break;\r\n");
        }
        script.Append( "default:\r\n" );
        script.Append( "break;\r\n" );
        script.Append( "}\r\n" );

        script.Append( "}\r\n" );
        script.Append( "}\r\n" );
        script.Append( "function setToolBarButtonHidden(i,toolBar)\r\n" );
        script.Append("{\r\n");
        script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i);\r\n" );
        script.Append( "toolBar.items.items[i-1].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i-1);\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );

    }
    protected string setPrintPrivilege()
    {
        //海宁公司打印超过4行的模板
        StringBuilder pscript = new StringBuilder();
        if (ValidateControlActionRight("更多行打印"))
        {
            pscript.Append(",xtype:'splitbutton'\r\n");
            pscript.Append(",menu: [{\r\n");
            pscript.Append("        text: '打印更多', \r\n");
            pscript.Append("        icon: '../Theme/1/images/extjs/customer/printer.png',\r\n");
            pscript.Append("        handler: function(){\r\n");
            pscript.Append("        printStyleXmlName = printStyleXmlV2;\r\n");
            pscript.Append("        printOnlyDataValue = printOnlyDataV2;\r\n");
            pscript.Append("        printPageWidthValue = printPageWidthV2;\r\n");
            pscript.Append("        printPageHeightValue = printPageHeightV2;\r\n");
            pscript.Append("        printOrderById();\r\n");
            pscript.Append( "}\r\n" );
            pscript.Append( "}]\r\n" );
        }
        return pscript.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getOrderList":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getOrderList(this);
                    break;
                case "getOrder":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getOrder(this);
                    break;                
                case "Delete":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.deleteMst(this);
                    break;
                case "print"://打印
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.printOrder(this);
                    break;
                case"printdate":
                    DataSet ds = ZJSIG.UIProcess.SCM.UIScmOrderMst.getPrintData(this);
                    //嘉兴公司需要添加运费
                    if ( this.OrgID == 121 )
                    {
                        foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                        {
                            if ( dr[ "DlvInf" ].ToString( ) == "" )
                            {
                                dr[ "DlvInf" ] = "自提时间：" + dr[ "DlvDate" ].ToString( );
                            }
                        }
                        foreach ( DataRow dr in ds.Tables[ 1 ].Rows )
                        {
                            if ( dr[ "TransFee" ].ToString( ) != "" )
                            {
                                dr[ "SalePrice" ] = decimal.Parse( dr[ "SalePrice" ].ToString( ) ) +
                                    decimal.Parse( dr[ "TransFee" ].ToString( ) );
				dr["SaleAmt"] = System.Math.Round(decimal.Parse(dr["SalePrice"].ToString())*decimal.Parse(dr["SaleQty"].ToString()),2);
                            }
                        }
                    }
                    //富阳公司 摘要 如果不是增值税，就清空
                    if ( this.OrgID == 102 )
                    {
                        foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                        {
                            if ( dr[ "BillModeName" ].ToString( ) != "增值税发票" )
                            {
                                dr[ "BillModeName" ] = "";
                            }
                        }
                    }
                    foreach ( DataRow dr in ds.Tables[ 1 ].Rows )
                    {
                        if ( dr[ "DiscountAmt" ].ToString( ) != "" )
                        {
                            dr[ "SaleAmt" ] = decimal.Parse( dr[ "SaleAmt" ].ToString( ) ) - decimal.Parse( dr[ "DiscountAmt" ].ToString( ) );
                        }
                        ////富阳公司
                        //if ( this.OrgID == 102 )
                        //{
                        //    QueryConditions queryP = new QueryConditions( );
                        //    queryP.Condition.Add( new Condition( "OrgId", this.OrgID, Condition.CompareType.Equal ) );
                        //    queryP.Condition.Add( new Condition( "ProductId", dr[ "ProductId" ].ToString( ), Condition.CompareType.Equal ) );
                        //    queryP.TableName = "BaProductIndividual";
                        //    DataSet dsP = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, queryP, "" );
                        //    if ( dsP.Tables[ 0 ].Rows.Count > 0 )
                        //    {
                        //        if ( dsP.Tables[ 0 ].Rows[ 0 ][ "Ext2" ].ToString( ) != "" )
                        //        {
                        //            dr[ "ProductName" ] = dsP.Tables[ 0 ].Rows[ 0 ][ "Ext2" ].ToString( );
                        //        }
                        //    }
                        //}
                    }
                    //ds.WriteXml(@"C:\zjsalt\WebSite\ZJSIGSite\xml\data.xml",XmlWriteMode.WriteSchema);
                    string str = ToDataSetString(ds);
                    this.Response.Write(str);
                    this.Response.End();
                    break;
                case"billdata":
                    DataSet dsBill = new DataSet( );
                    DataTable dt = new DataTable( );
                    dt.Columns.Add( "CustomerName" );
                    dt.Columns.Add( "Address" );
                    dt.Columns.Add( "TaxNo" );
                    dt.Columns.Add( "BankId" );
                    dt.Columns.Add( "OrderId", typeof( System.Int64 ) );
                    dsBill.Tables.Add( dt );

                    DataTable dtChild = new DataTable( );
                    dtChild.Columns.Add( "ProductNo" );
                    dtChild.Columns.Add( "SaleQty" );
                    dtChild.Columns.Add( "SalePrice" );
                    dtChild.Columns.Add( "UnitName" );
                    dtChild.Columns.Add( "OrderId", typeof( System.Int64 ) );
                    dsBill.Tables.Add( dtChild );

                    dt.Rows.Add( new object[ ] { "北京公司", "北京路112号", "110101251328321", "北京银行宁波分行", 1 } );
                    dtChild.Rows.Add( new object[ ] { "00107", "3", "33", "台", 1 } );
                    dtChild.Rows.Add( new object[ ] { "00401", "5", "16", "", 1 } );
                    string strBill = ToDataSetString( dsBill );
                    this.Response.Write( strBill );
                    this.Response.End( );
                    break;
                case"cancelaccrect":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.cancleAcctReceRecord(this);
                    break;
                case"outstore":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.generDrawOther(this);
                    break;
                case"cancelbill":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.cancelBill( this );
                    break;
                case"getDrawDtlInfo":
                    QueryConditions query = new QueryConditions( );
                    query.TableName = "VScmDrawDetailView";
                    query.Condition.Add( new Condition( "OrderId", this.Request[ "OrderId" ], Condition.CompareType.Equal ) );
                    string response = ZJSIG.UIProcess.UIProcessBase.getJsonListByQuery( 100, 0, query, "" );
                    this.Response.Write( response );
                    this.Response.End( );
                    break;
                case "getdetailinfo":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getSaleDetailInfo( this );
                    break;
                case "getorderstateinfo":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getSaleOrderState( this );
                    break;
                case "getPrintDataStr":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getPrintDataStr( this );
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
