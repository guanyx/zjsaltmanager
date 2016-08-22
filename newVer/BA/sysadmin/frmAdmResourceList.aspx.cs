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
using System.Text;

public partial class BA_sysadmin_frmAdmResourceList : System.Web.UI.Page
{
    protected string resourceData
    {
        get
        {
            //string script = "<script>\r\n";
            //script += ZJSIG.UIProcess.ADM.UIAdmResource.getResourceTreeList(this);
            //script += "</script>\r\n";
            return "";
        }
    }

    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取公司类别信息
        script.Append("var ResourceTypeStore =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A01"));


        script.Append("</script>\r\n");
        return script.ToString();
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
            //获取角色列表信息
            case "getresourcelist":
                ZJSIG.UIProcess.ADM.UIAdmResource.getResourceList(this);
                break;
            //获取角色列表信息
            case "gettreecolumnlist":
                ZJSIG.UIProcess.ADM.UIAdmResource.getTreeColumnList(this);
                break;
            //新增角色信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmResource.addResource(this);
                break;
            //获取角色信息
            case "getresource":
                ZJSIG.UIProcess.ADM.UIAdmResource.getResource(this);
                break;
            //删除角色信息
            case "deleteresource":
                ZJSIG.UIProcess.ADM.UIAdmResource.deleteResource(this);
                break;
            //编辑角色信息
            case "editresource":
                ZJSIG.UIProcess.ADM.UIAdmResource.editResource(this);
                break;
            case"gettreelist":
                ZJSIG.UIProcess.ADM.UIAdmResource.getResourceTreeList(this);
                break;
        }
    }
}
