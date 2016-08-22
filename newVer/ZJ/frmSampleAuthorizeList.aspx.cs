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

public partial class ZJ_frmSampleAuthorizeList : PageBase
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.AppendLine( "<script>" );
        script.AppendLine( "var checkTypeStore=" + ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "Q09" ) );
        script.AppendLine( "var status='" + this.Request.QueryString[ "Status" ] + "';" );
        //获取委托Id
        script.AppendLine( "var AuthorizeId='" + this.Request.QueryString[ "id" ] + "';" );
        

        script.AppendLine( setToolBarVisible( ) );
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
            
                //检测
            case "Q1302":
                script.Append( "case'新增':\r\n" );
                script.Append( "case'修改':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'送检':\r\n" );
                script.Append( "case'取消送检':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
                //委托单位管理
            case"Q1303":
                script.Append( "case'新增':\r\n" );
                script.Append( "case'修改':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'送检':\r\n" );
                script.Append( "case'检测':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
                //检测单位查看
            case"Q1304":
                script.Append( "case'新增':\r\n" );
                script.Append( "case'修改':\r\n" );
                script.Append( "case'删除':\r\n" );
                script.Append( "case'送检':\r\n" );
                script.Append( "case'检测':\r\n" );
                script.Append( "case'取消送检':\r\n" );
                script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
                script.Append( "i--;\r\n" );
                script.Append( "break;\r\n" );
                break;
            //登记
            case "Q1301":
            default:
                script.Append( "case'取消送检':\r\n" );
                script.Append( "case'检测':\r\n" );
                script.Append( "case'查看':\r\n" );
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
            case"getlist":
                ZJSIG.UIProcess.QT.UIQtAuthorize.getQtAuthorizeList( this );
                break;
            case"delAuthorize":
                ZJSIG.UIProcess.QT.UIQtAuthorize.deleteAuthorize(this);
                break;
            case"sendToCheck":
                ZJSIG.UIProcess.QT.UIQtAuthorize.sendToCheck( this );
                break;
            case"cancleSend":
                ZJSIG.UIProcess.QT.UIQtAuthorize.cancleSend( this );
                break;
        }
    }
}
