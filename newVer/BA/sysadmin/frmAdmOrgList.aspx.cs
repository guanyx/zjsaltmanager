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

public partial class BA_sysadmin_frmAdmOrgList : PageBase
{

    protected string getComboBoxSource( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        //获取发运类型
        script.Append( "var SendTypeStore =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(
            ZJSIG.UIProcess.Common.CommonDefinition.ADM_SEND_TYPE ) );

        script.Append("var OrgAreaStore = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A61"));
        //机构类型
        script.Append( "var OrgTypeStore = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A09" ) );

        script.Append( setToolBarVisible( ) );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    private string setToolBarVisible( )
    {
        StringBuilder script = new StringBuilder( );
        
        script.Append( "function setToolBarVisible(toolBar)\r\n" );
        script.Append( "{\r\n" );
        //不是省盐业公司的，不能新增，删除，创建用户操作
        if ( this.OrgID != 1 )
        {
            script.Append( "for(var i=0;i<toolBar.items.items.length;i++)\r\n" );
            script.Append( "{\r\n" );
            script.Append( "switch(toolBar.items.items[i].text)\r\n" );
            script.Append( "{\r\n" );
            script.Append( "case'新增':\r\n" );
            script.Append( "case'删除':\r\n" );
            script.Append( "case'创建管理员':\r\n" );
            script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
            script.Append( "toolBar.items.removeAt(i);\r\n" );
            script.Append( "toolBar.items.items[i].setVisible(false);\r\n" );
            script.Append( "toolBar.items.removeAt(i);\r\n" );
            script.Append( "i--;\r\n" );
            script.Append( "break;\r\n" );
            script.Append( "}\r\n" );
            script.Append( "}\r\n" );
        }
        script.Append( "}\r\n" );
        return script.ToString( );

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch (Exception ex)
        {
        }
        switch (method)
        {
            //获取机构列表信息
            case "getorglist":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgList(this);
                break;
            //新增机构信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmOrg.addOrg(this);
                break;
            //获取机构信息
            case "getorg":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getOrg(this);
                break;
            //删除机构信息
            case "deleteorg":
                ZJSIG.UIProcess.ADM.UIAdmOrg.deleteOrg(this);
                break;
            //编辑机构信息
            case "editorg":
                ZJSIG.UIProcess.ADM.UIAdmOrg.editOrg(this);
                break;
            case"gettreecolumnlist":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getTreeColumnList(this);
                break;
            case"getuserbyorgid":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getUserByOrgId(this);
                break;
            case"saveUserByOrgId":
                ZJSIG.UIProcess.ADM.UIAdmOrg.saveUserByOrgId(this);
                break;
            case"getcurrentandchildrentree":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getCurrentAndChildrenTree( this );
                break;
            case"getcurrentAndChildrenTreeByArea":
                ZJSIG.UIProcess.ADM.UIAdmOrg.getcurrentAndChildrenTreeByArea(this);
                break;
        }
    }
}
