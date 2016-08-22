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

using System.IO;

public partial class SCM_frmScmOrderBalance :PageBase
{
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {

        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //获取组织
        script.Append( "var dsOrg = " );  //这个变量名界面combobox需要使用，保持一致
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        script.Append( ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore( this ) );

        //获取部门列表
        script.Append( "var dsDept = " );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore( ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) ) );

        //获取仓库列表
        script.Append( "var dsWareHouse = " );
        script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //订单类型
        script.Append( "var dsOrderType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S01" ) );

        //开票方式
        script.Append( "var dsPayType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S03" ) );

        //结算方式
        script.Append( "var dsBillMode = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S02" ) );

        //配送方式
        script.Append( "var dsDlvType = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S04" ) );

        //送货等级
        script.Append( "var dsDlvLevel = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "S05" ) );

        string bankType = this.Request.QueryString[ "Bank" ];
        script.AppendLine( "var bankType = '" + bankType + "';" );
        script.Append( setToolBarVisible( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
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
        if ( this.Request.QueryString[ "Bank" ] == "01" )
        {
            //script.Append( "case'导出文件':\r\n" );
            script.Append( "case'导入文件':\r\n" );
            script.Append( "case'导出文件':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        else if ( this.Request.QueryString[ "Bank" ] == "02" )
        {
            script.Append( "case'发送结算邮件':\r\n" );
            script.Append( "case'接收邮件':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
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


    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request[ "Method" ];
        string bankType = this.Request[ "Bank" ];
        switch ( method )
        {
            case "getOrderList":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.getBalanceOrderList( this, bankType );
                break;
            case"sendAbcMail":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.sendAbcMail( this );
                break;
            case"receiveAbcMail":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.receiveAbcMail( this );
                break;
            case "importData":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.ImportFileAndAnalysis( this );
                break;
            case"geturcbfile":
                ZJSIG.UIProcess.SCM.UIScmOrderMst.downURCBBankData( this );
                break;
            case"viewbalance":
                string dataFile = getTodayBalanceData( bankType );
                if ( dataFile == "" )
                    this.Response.End( );
                DataSet ds = new DataSet( );
                ds.ReadXml( dataFile );
                //DataTable dt = new DataTable( );
                //dt.ReadXml( dataFile );
                //DataSet ds = new DataSet( );
                //ds.Tables.Add( dt );
                string response = "{'totalProperty':'" + ds.Tables[0].Rows.Count.ToString( ) + "','root':[";
                response += ZJSIG.UIProcess.UIProcessBase.DataTableToJson( ds.Tables[ 0 ] );
                response += "]}";
                this.Response.Write( response );
                this.Response.End( );
                break;
        }
    }

    private string getTodayBalanceData( string bankType )
    {
        string strBankType = "";
        switch(bankType)
        {
            case"01":
                strBankType = "ABC";
                break;
            case"02":
                strBankType = "URCB";
                break;
        }
        string[] fiels = System.IO.Directory.GetFiles(Server.MapPath("../")+"\\upload_files\\BalanceData",OrgID.ToString()+"_"+strBankType+DateTime.Today.ToString("yyyyMMdd")+"*.xml");
        if ( fiels.Length > 0 )
        {
            return fiels[ 0 ];
        }
        return "";

    }

    
}
