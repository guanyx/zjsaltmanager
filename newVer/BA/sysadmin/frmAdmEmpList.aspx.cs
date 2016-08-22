using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess;
using System.Text;

public partial class BA_sysadmin_frmAdmEmpList :PageBase
{
    public string OrgInformation
    {
        get
        {
            long orgID = 0;
            //首先查找是否有传递过来的机构信息
            long.TryParse(this.Request.QueryString["orgid"], out orgID);
            if (orgID == 0)
            {
                //如果没有就获取默认登录ID信息
                orgID = OrgID;
            }
            string orgName = ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgNameById(orgID);
            return string.Format("<script>\r\n var orgId = {0};\r\n var orgName='{1}';\r\n </script>\r\n", orgID, orgName);
        }
    }

    private string setToolBarVisible()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function setToolBarVisible(toolBar)\r\n");
        script.Append("{\r\n");
        //script.Append("for(var i=0;i<toolBar.items.items.length;i++)\r\n");
        //script.Append("{\r\n");
        //script.Append("switch(toolBar.items.items[i].text)\r\n");
        //script.Append("{\r\n");
        //script.Append("case'新增':\r\n");
        //script.Append("toolBar.items.items[i].setVisible(false);\r\n");
        //script.Append("toolBar.items.removeAt(i);\r\n");
        //script.Append("toolBar.items.items[i].setVisible(false);\r\n");
        //script.Append("toolBar.items.removeAt(i);\r\n");
        //script.Append("break;\r\n");
        //script.Append("}\r\n");
        //script.Append("}\r\n");
        script.Append("}\r\n");
        return script.ToString();
        
    }
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取性别信息数据
        script.Append("var EmpSexStore =");
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A03", "OrderIndex,DicsName" ) );

        //获取在职状态信息
        script.Append("var EmpStateStore=");
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A04", "OrderIndex,DicsName" ) );

        //获取编制信息
        script.Append("var EmpBzStore = ");
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore( "A05", "OrderIndex,DicsName" ) );

        //设置政治面貌信息 A18
        script.Append("var EmpPoliticalStore= ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("A18", "OrderIndex,DicsName"));

        long orgID = 0;
        //首先查找是否有传递过来的机构信息
        long.TryParse(this.Request.QueryString["orgid"], out orgID);
        if (orgID == 0)
        {
            //如果没有就获取默认登录ID信息
            orgID = OrgID;
        }
        string orgName = ZJSIG.UIProcess.ADM.UIAdmOrg.getOrgNameById(orgID);
        script.Append(string.Format("var orgId = {0};\r\n var orgName='{1}';\r\n ", orgID, orgName));
        script.Append("var DeptIdStore=");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore(orgID));

        script.Append(setToolBarVisible());
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
            //获取职员列表信息
            case "getemplist":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.getEmployeeList(this);
                break;
            //新增职员信息
            case "add":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.addEmployee(this);
                break;
            //获取职员信息
            case "getemployee":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.getEmployee(this);
                break;
            //删除职员信息
            case "deleteemp":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.deleteEmployee(this);
                break;
            //编辑职员信息
            case "editemp":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.editEmployee(this);
                break;
            case"getuserbyempid":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.getUserByEmpId(this);
                break;
            case"saveuser":
                ZJSIG.UIProcess.ADM.UIAdmEmployee.saveUserByEmpId(this);
                break;
            case"getpositiontreecolumnlist":
                ZJSIG.UIProcess.ADM.UIAdmPosition.getOrgDeptPositionTreeStore(this);
                break;
            case"gridexpert":
                HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment;filename=Excel.xls");
                HttpContext.Current.Response.Charset = "UTF-8";
                HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Default;
                HttpContext.Current.Response.ContentType = "application/ms-excel";//image/JPEG;text/HTML;image/GIF;vnd.ms-excel/msword 
                
                HttpContext.Current.Response.Write(Request["exportContent"]);
                HttpContext.Current.Response.End(); 
                break;
            case "getgroupby":
                UIProcessBase.GetGroupStore(this, "AdmEmployee");
                break;
        }
    }
}
