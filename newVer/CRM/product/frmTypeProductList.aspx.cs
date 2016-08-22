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

using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.BA;

public partial class CRM_product_frmTypeProductList : System.Web.UI.Page
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        ////获取规格
        //script.Append( "var dsSpecifications = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_SPECIFICATION ) );

        //获取产地
        script.Append( "var dsOrigin =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_ORIGIN ) );

        //获取计价方法
        script.Append( "var dsAliasPrice =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_ALIASPRICE ) );

        //获取存货类别
        script.Append( "var dsProductType =" );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.BA_PRODUCT_PRODUCTTYPE ) );

        //获取单位
        script.Append( "var dsUnit =" );
        script.Append( UIBaProductUnit.getUnitInfoStore( ) );

        script.Append( "var classId = '" + this.Request.QueryString[ "classId" ] + "';" );
        script.Append( "var action = '" + this.Request.QueryString[ "action" ] + "';" );
        script.Append( setToolBarVisible( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    private string setToolBarVisible( )
    {
        StringBuilder script = new StringBuilder( );
        string action = this.Request.QueryString[ "action" ];
        script.Append( "function setToolBarVisible(toolBar)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "for(var i=0;i<toolBar.items.items.length;i++)\r\n" );
        script.Append( "{\r\n" );
        script.Append( "switch(toolBar.items.items[i].text)\r\n" );
        script.Append( "{\r\n" );
        if ( action == "add" )
        {
            script.Append( "case'添加商品':\r\n" );
            script.Append( "case'删除商品':\r\n" );
            script.Append( "setToolBarButtonHidden(i,toolBar);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
        }
        else
        {
            script.Append( "case'保存':\r\n" );
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

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "Method" ];
        switch ( method )
        {
            case "getTypeProductList":
                
                string action = this.Request[ "action" ];
                if ( action == null || action == "" )
                {
                    ZJSIG.UIProcess.BA.UIBaReportType.getProductListByReport( this );
                }
                else if ( action == "add" )
                {
                    ZJSIG.UIProcess.BA.UIBaReportType.getProductListByNoReport( this );
                }
                break;
            case "save":
                ZJSIG.UIProcess.BA.UIBaReportType.saveReportRealProduct( this );
                break;
            case "del":
                ZJSIG.UIProcess.BA.UIBaReportType.delReportRealProduct( this );
                break;

        }
    }
}
