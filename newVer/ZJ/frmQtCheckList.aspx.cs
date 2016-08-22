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

using ZJSIG.Common.DataSearchCondition;

public partial class ZJ_frmQtCheckList : PageBase
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        script.AppendLine( "var checkStatus='" + this.Request.QueryString[ "Status" ] + "';" );
        script.AppendLine( "var orgId=" + ZJSIG.UIProcess.UIProcessBase.OrgID( this ).ToString( ) + ";" );
        QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions( );
        query.Condition.Add( new Condition( "PrintType", "qtcheck", Condition.CompareType.Equal ) );
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
            script.Append( "var printStyleXml = 'qtcheck.xml';\r\n" );
            script.Append( "var printPageWidth =798;\r\n" );
            script.Append( "var printPageHeight =1102;\r\n" );
            script.Append( "var printOnlyData = false;\r\n" );
        }

        script.Append( setToolBarVisible( ) );

        script.AppendLine( "</script>" );
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
        switch ( this.Request.QueryString[ "Status" ] )
        {
            case"Q1204":
                script.Append( "case'修改':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'批准':\r\n" );
                script.Append( "case'取消上报':\r\n" );  
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
            case"Q1205":
                script.Append( "case'打印':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'取消批准':\r\n" );
                script.Append( "case'批准':\r\n" );
                script.Append( "case'修改':\r\n" );
                script.Append( "case'上报':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
            default:
                script.Append( "case'打印':\r\n" );
                script.Append( "case'查看':\r\n" );
                script.Append( "case'取消批准':\r\n" );
                script.Append( "case'上报':\r\n" );
                script.Append( "case'取消上报':\r\n" );  
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
        }
        script.AppendLine( "}" );
        script.AppendLine( "}" );
        script.AppendLine( "}" );
        
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
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getcheck":
                ZJSIG.UIProcess.QT.UIQtCheck.getCheckList( this );
                break;
            case"delcheck":
                ZJSIG.UIProcess.QT.UIQtCheck.delCheck( this );
                break;
            case"allow":
                ZJSIG.UIProcess.QT.UIQtCheck.allowCheck( this );
                break;
            case"cancleAllow":
                ZJSIG.UIProcess.QT.UIQtCheck.cancleAllowCheck( this );
                break;
            case"report":
                ZJSIG.UIProcess.QT.UIQtCheck.reportCheck( this );
                break;
            case"cancleReport":
                ZJSIG.UIProcess.QT.UIQtCheck.cancleReportCheck( this );
                break;
            case"printdate":
                DataSet dsPrint = ZJSIG.UIProcess.QT.UIQtCheck.getCheckPrintData( this );
                string str = ToDataSetString( dsPrint );
                this.Response.Write( str );
                this.Response.End( );
                break;
        }
    }
}
