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
using ZJSIG.UIProcess.ADM;
using ZJSIG.ADM.BLL;
using ZJSIG.Common.DataSearchCondition;
using ZJSIG.ADM.BusinessEntities;
using ZJSIG.UIProcess;
using System.Collections.Generic;

public partial class changeDept : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string Action = Request.QueryString[ "method" ];
        if ("gettree".Equals(Action))
        {
            string parId = Request.QueryString["parId"];
            //找到用户本来归属的最大部门
            long deptId = BLAdmEmployee.GetModel(UIAdmUser.EmployeeID(this)).DeptId;
            //根据该部门找到部门树
            QueryConditions query = new QueryConditions();
            int recordCount = 0;
            query.Condition.Add(new Condition("OrgId", UIAdmUser.OrgID(this), Condition.CompareType.Equal));
            List<AdmDept> list = BLAdmDept.GetPageList(int.MaxValue, 0, query, "Dept_Code", out recordCount);
            if ("-1".Equals(parId))
            {
                AdmDept ad = BLAdmDept.GetModel(deptId);
                Response.Write("[{cls:'file',id:'" + deptId + "',leaf:false,children:null,text:'"+ad.DeptName+"',checked:false,CustomerColumn:'',CustomerColumn1:'',CustomerColumn2:'',uiProvider:'',iconCls:'',NodeType:''}]");
            }
            else
            {
                Response.Write("[" + UIProcessBase.BuildTreeNode<AdmDept>(list, "DeptName", "DeptId", "DeptParent", parId + "", "-1", "") + "]");
            }
            
            Response.End();
        }
        else if ("applyChange".Equals(Action))
        {
             UIMessageBase message = new UIMessageBase();
             try
             {
                 string parId = Request.Form["DestDept"];
                 if (UIAdmUser.DeptID(this) == long.Parse(parId))
                     throw new Exception("切换目标部门与当前部门一致！");

                 AdmEmployee emp = this.Session["LoginEmployee"] as AdmEmployee;
                 emp.DeptId = long.Parse(parId);
                 this.Session["LoginEmployee"] = emp;

                 message.success = true;
                 message.errorinfo = "部门切换成功！";

             }
             catch (Exception ep)
             {
                 message.success = false;
                 message.errorinfo = ep.Message;
             }
             finally
             {
                 Response.Write(UIProcessBase.ObjectToJson(message));
                 Response.End();
             }
        }
    }
}
