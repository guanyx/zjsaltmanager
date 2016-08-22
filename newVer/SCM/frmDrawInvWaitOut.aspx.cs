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
using System.Text;
using ZJSIG.UIProcess.SCM;
using ZJSIG.Common.DataSearchCondition;

public partial class SCM_frmDrawInvWaitOut : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //领货单类型
        script.Append("var dsDrawType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S10"));

        //获取车辆信息
        script.Append("var dsVehicle = ");
        script.Append(UIScmVehicleAttr.getVehicleAttrStore(this));

        //驾驶员信息
        script.Append("var dsDriver = ");
        script.Append(UIScmDriverAttr.getDriverAttrStore(this));

        //打印样式信息
        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "draw", Condition.CompareType.Equal ) );
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
            script.Append( "var printStyleXml = 'jxdrawprint.xml';\r\n" );
            script.Append( "var printPageWidth =931;\r\n" );
            script.Append( "var printPageHeight =365;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append( setToolBarVisible( ) );
        script.Append("</script>\r\n");
        return script.ToString();
    }

    private string setToolBarVisible( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "function setToolBarVisible(toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "for(var i=0;i<toolBar.items.items.length;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "switch(toolBar.items.items[i].text)\r\n" );
        script.Append( "{\r\n" );

        //杭州市盐业公司，配送单和自提单需要分开来打印
        if ( this.OrgID == 2 || this.OrgID == 101)
        {
            script.Append( "case'领货单打印':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        else
        {
            script.Append( "case'配送单打印':\r\n" );
            script.Append( "case'自提单打印':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        script.Append( "default:\r\n" );
        script.Append( "break;\r\n" );
        script.Append( "}\r\n" );

        script.Append( "}\r\n" );
        script.Append( "}\r\n" );
        script.Append( "function setToolBarButtonHidden(i,toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i);\r\n" );
        script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
        script.Append( "toolBar.items.removeAt(i);\r\n" );
        script.Append( "}\r\n" );
        return script.ToString( );

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                //领货单列表
                case "getDrawInvList":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawListForWaitOut(this);
                    break;               
                //保存
                case "saveUpdate":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.saveDrawInvWaitOut(this);
                    break;
                //删除领货单
                case "delDrawInv":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.deleteDrawInv(this);
                    break;
                case"getDtlInfo":
                    ZJSIG.UIProcess.SCM.UIScmDrawManager.getDrawDtlList(this );
                    break;
                    //自提单据
                case"selfprintdata":
                    DataSet dsSelf = ZJSIG.UIProcess.SCM.UIScmDrawManager.getPrintData( this );


                    foreach ( DataRow dr in dsSelf.Tables[ 0 ].Rows )
                    {
                        dr[ "PJName" ] = dr[ "PJName" ].ToString( ).Replace( "货物销售领货单", "提货单" );
                        dr[ "OperName" ] = this.EmpName;
                        dr[ "CreateDate" ] = DateTime.Today;

                        dr[ "DrawNumber" ] = dr[ "DrawNumber" ].ToString( ) + getOrderNumber( dr[ "DrawInvId" ].ToString( ),
                            dr[ "OrderId" ].ToString( ) );
                        //共几张，第几页

                        ////订单备注信息，配送车号
                        ////if(dr
                        //QueryConditions query = new QueryConditions( );
                        //query.TableName = "ScmOrderMst";
                        //query.Columns = "Remark";
                        //query.Condition.Add( new Condition( "OrderId", dr[ "OrderId" ].ToString( ), Condition.CompareType.Equal ) );
                        
                        
                        
                    }
                    //ds.WriteXml(@"C:\zjsalt\WebSite\ZJSIGSite\xml\data.xml",XmlWriteMode.WriteSchema);
                    string str1 = ToDataSetString( dsSelf );
                    this.Response.Write( str1 );
                    this.Response.End( );
                    break;
                    //配送单据
                case "printdate":
                    DataSet ds = ZJSIG.UIProcess.SCM.UIScmDrawManager.getPrintData( this );
                    ds.Tables[ 0 ].Columns.Add( "CarNo" );
                    ds.Tables[ 0 ].Columns.Add( "OrderRemark" );
                    foreach ( DataRow dr in ds.Tables[ 0 ].Rows )
                    {
                        dr[ "CreateDate" ] = DateTime.Today;
                        dr[ "OperName" ] = this.EmpName;
                        //订单备注信息，配送车号
                        //if(dr
                        QueryConditions query = new QueryConditions( );
                        query.TableName = "ScmOrderMst";
                        query.Columns = "Remark";
                        query.Condition.Add( new Condition( "OrderId", dr[ "OrderId" ].ToString( ), Condition.CompareType.Equal ) );
                        DataSet dsOrder = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                        dr[ "OrderRemark" ] = dsOrder.Tables[ 0 ].Rows[ 0 ][ "Remark" ];
                        query = new QueryConditions( );
                        query.Columns = "Draw_Inv_Id,Vehicle_Id";
                        query.TableName = "ScmDrawInvMst";
                        query.Condition.Add( new Condition( "DrawInvId", dr[ "DrawInvId" ].ToString( ), Condition.CompareType.Equal ) );
                        DataSet dsDraw = UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                        if ( dsDraw.Tables[0].Rows[0][ "VehicleId" ].ToString( ) != "" )
                        {
                            query = new QueryConditions( );
                            query.TableName = "ScmVehicleAttr";
                            query.Condition.Add( new Condition( "VehicleId", dsDraw.Tables[ 0 ].Rows[ 0 ][ "VehicleId" ].ToString( ), Condition.CompareType.Equal ) );
                            DataSet dsV = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                            if ( dsV.Tables[ 0 ].Rows.Count > 0 )
                            {
                                dr[ "CarNo" ] = dsV.Tables[ 0 ].Rows[ 0 ][ "VehicleNo" ];
                            }
                        }
                    }
                    //ds.WriteXml(@"C:\zjsalt\WebSite\ZJSIGSite\xml\data.xml",XmlWriteMode.WriteSchema);
                    string str = ToDataSetString( ds );
                    this.Response.Write( str );
                    this.Response.End( );
                    break;
                case "print":
                    QueryConditions queryPrinte = new QueryConditions( );
                    queryPrinte.Columns = "Draw_Inv_Id,Print_Count";
                    queryPrinte.TableName = "ScmDrawInvMst";
                    queryPrinte.Condition.Add( new Condition( "DrawInvId", this.Request[ "OrderId" ], Condition.CompareType.SelectIn ) );
                    DataSet dsPrint = UIProcessBase.getDataSetByQuery( 100, 0, queryPrinte, "" );
                    dsPrint.Tables[ 0 ].TableName = "ScmDrawInvMst";
                    foreach ( DataRow dr in dsPrint.Tables[ 0 ].Rows )
                    {
                        if ( dr[ 1 ].ToString( ) == "" )
                            dr[ 1 ] = 1;
                        else
                        {
                            dr[ 1 ] = int.Parse( dr[ 1 ].ToString( ) ) + 1;
                        }
                    }
                    dsPrint.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { dsPrint.Tables[ 0 ].Columns[ "DrawInvId" ] };
                    dsPrint.Tables[ 0 ].Columns.RemoveAt( 2 );
                    ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsPrint );
                    this.Response.End( );
                    break;

            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    /// <summary>
    /// 获取当前领货单是第几张，并总共有几页
    /// </summary>
    /// <param name="drawInvId">领货单</param>
    /// <param name="orderId">订单</param>
    /// <returns></returns>
    private string getOrderNumber(string drawInvId,string orderId)
    {
        QueryConditions query = new QueryConditions();
        query.TableName="ScmDrawInvMst";
        query.Condition.Add(new Condition("OrderId",orderId,Condition.CompareType.Equal));
        query.Condition.Add(new Condition("IsActive",1,Condition.CompareType.Equal));
        int total = ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query );
        query.Condition.Add( new Condition( "DrawInvId", drawInvId, Condition.CompareType.LessThanOrEqual ) );
        int current = ZJSIG.ADM.BLL.BLGetListCommon.GetCount( query );
        return string.Format( "       第{0}页共{1}页", current, total );
    }


}
