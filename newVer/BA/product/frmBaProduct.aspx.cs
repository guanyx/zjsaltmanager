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
using ZJSIG.BA.BusinessEntities;
using ZJSIG.BA.BusinessLogic;
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.BA;

public partial class CRM_product_frmProduct : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
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

        script.Append(setToolBarVisible());
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    private string setToolBarVisible()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function setToolBarVisible(toolBar)\r\n");
        script.Append("{\r\n");
        script.Append("for(var i=0;i<toolBar.items.items.length;i++)\r\n");
        script.Append("{\r\n");
        script.Append("switch(toolBar.items.items[i].text)\r\n");
        script.Append("{\r\n");
        if (!ValidateControlActionRight("存货维护"))
        {
            script.Append("case'新增':\r\n");
            script.Append("case'编辑':\r\n");
            script.Append("case'删除':\r\n");
            script.Append("case'设置单位转换':\r\n");
            script.Append( "case'复制单位体系':\r\n" );
            script.Append( "case'设置价格体系':\r\n" );
            script.Append("setToolBarButtonHidden(i,toolBar);\r\n");
            script.Append("i--;\r\n");
            script.Append("break;\r\n");
        }
        else
        {
            script.Append("case'查看':\r\n");
            script.Append("setToolBarButtonHidden(i,toolBar);\r\n");
            script.Append("i--;\r\n");
            script.Append("break;\r\n");
        }
        script.Append("default:\r\n");
        script.Append("break;\r\n");
        script.Append("}\r\n");
        
        script.Append("}\r\n");
        script.Append("}\r\n");
        script.Append("function setToolBarButtonHidden(i,toolBar)\r\n");
        script.Append("{\r\n");
        script.Append("toolBar.items.items[i].setVisible(false);\r\n");
        script.Append("toolBar.items.removeAt(i);\r\n");
        script.Append("toolBar.items.items[i].setVisible(false);\r\n");
        script.Append("toolBar.items.removeAt(i);\r\n");
        script.Append("}\r\n");
        return script.ToString();

    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getSupplieres":
                ZJSIG.UIProcess.BA.UIBaProduct.getSupplieres( this );
                break;
            case "getProductInfoList":
                ZJSIG.UIProcess.BA.UIBaProduct.getProductList( this );
                break;
            case "getModifyProductInfo":
                ZJSIG.UIProcess.BA.UIBaProduct.getProduct( this );
                break;
            case "saveModifyProductInfo":
                ZJSIG.UIProcess.BA.UIBaProduct.editProduct( this );
                break;
            case "saveAddProductInfo":
                ZJSIG.UIProcess.BA.UIBaProduct.addProduct( this );
                break;
            case "deleteProductInfo":
                ZJSIG.UIProcess.BA.UIBaProduct.deleteProduct( this );
                break;    
            case "getSmallClasses":
                ZJSIG.UIProcess.BA.UIBaProductSmallClass.getClassList( this );
                break;
            case "getProductNo":
                ZJSIG.UIProcess.BA.UIBaProduct.getNextProductNo(this);
                break;
            default:
                return;
        }
    }
}
