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

public partial class ZJ_frmQtCheckInput : PageBase
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        script.AppendLine( "var templateStore = " +
            ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.getTemplateSimpleStore( this ) );
        //checkId
        if ( this.Request.QueryString[ "CheckId" ] == null )
        {
            script.AppendLine( "var checkId = 0;" );
        }
        else
        {
            script.AppendLine( "var checkId = " + this.Request.QueryString[ "CheckId" ] + ";" );
        }
        if ( this.Request.QueryString[ "FromBillType" ] == null )
        {
            script.AppendLine( "var fromBillType='';" );
        }
        else
        {
            script.AppendLine( "var fromBillType='" + this.Request.QueryString[ "FromBillType" ] + "';" );
        }
        if ( this.Request.QueryString[ "FromBillId" ] == null )
        {
            script.AppendLine( "var fromBillId=0;" );
        }
        else
        {
            script.AppendLine( "var fromBillId='" + this.Request.QueryString[ "FromBillId" ] + "';" );
        }
        script.AppendLine( "var orgName='" + this.OrgName + "';" );
        script.AppendLine( "var checkTypeStore=" + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "Q09" ) );
        script.AppendLine( "var saltStore=" + ZJSIG.UIProcess.QT.UIQtSalt.getSaltSimpleStore(this) );
        script.AppendLine( "var canPassQuotaNo='" + ZJSIG.UIProcess.QT.UIQtCheck.getCanNoPassQuota( ) + "';" );
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
        switch ( this.Request.QueryString[ "query" ] )
        {
            case "1":
                script.Append( "case'保存':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
            default:
                script.Append( "case'打印':\r\n" );
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
        string method = this.Request.QueryString[ "Method" ];
        switch ( method )
        {
            case"templatestore":
                ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.getTemplateStore( this );
                break;
            case"getstandardbytemplate":
                ZJSIG.UIProcess.QT.UIQtQuotaTemplateRel.getQuotasByTemplate( this );
                break;
            case"getlevelbytemplate":
                ZJSIG.UIProcess.QT.UIQtSalt.getLevelByTemplate( this );
                break;
            case"getstandardbylevel":
                ZJSIG.UIProcess.QT.UIQtSalt.getStandardByLevel( this );
                break;
            case"checklevelstandard":
                ZJSIG.UIProcess.QT.UIQtSalt.checkLevelStandard( this );
                break;
            case"getSaltProduct":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductListByNameAndNo( this );
                break;
            case"getcheckinfo":
                ZJSIG.UIProcess.QT.UIQtCheck.getCheckInformation(this );
                break;
            case"getcheckresult":
                ZJSIG.UIProcess.QT.UIQtCheck.getCheckResult( this );
                break;
            case"savecheck":
                ZJSIG.UIProcess.QT.UIQtCheck.saveCheck( this );
                break;
            case"printdata":
                DataSet dsPrint = ZJSIG.UIProcess.QT.UIQtCheck.getCheckPrintData( this );
                string str = ToDataSetString( dsPrint );
                this.Response.Write( str );
                this.Response.End( );
                break;
            case"gethelp":
                ZJSIG.UIProcess.QT.UIQtQualityTemplateCfg.getHaveOpenStandard( this );
                break;
        }
    }
}
