using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using ZJSIG.UIProcess.Common;

public partial class SCM_frmPurchPlanList : PageBase
{
    protected string getComboBoxSource()
    {
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");
        //获取采购计划类型信息数据
        script.Append("var cmbPlanTypeList =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S20"));

        script.Append("var cmbStatusList =");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S21"));

        script.Append("var cmbPlanYearList = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getYearList());

        script.Append("var cmbPlanMonthList=");
        script.Append(ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getMonthList());

        script.Append("var cmbPlanQuarteList=");
        script.Append(ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getQuarterList());

        //获取发运类型
        script.Append( "var SendTypeStore =" );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore(
            ZJSIG.UIProcess.Common.CommonDefinition.ADM_SEND_TYPE ) );

        //设置默认过滤条件
        script.Append("var action='"+Action+"';\r\n");
        if (Action == "")
        {
            script.Append("var view = false;\r\n");
        }
        else
        {
            script.Append("var view = true;\r\n");
        }

        

        script.Append( "var owner='&Owner=" + OwnerId.ToString( )+"';" );
        script.Append(initToolBar());
        script.Append("</script>\r\n");
        return script.ToString();
    }

    private string initToolBar()
    {
        StringBuilder script = new StringBuilder();
        script.Append("function iniToolBar(Toolbar)\r\n");
        script.Append("{\r\n");

        string iconUrl = "imageUrl + \"images/extjs/customer/{0}\"";
        ToolBarButton tb = null;
        switch (Action)
        {
                //新增采购订单
            case"":
                tb = new ToolBarButton("addNew", "新增", string.Format(iconUrl, "add16.gif"), "Toolbar");
                script.Append(tb.createButton());
                script.Append(new ToolBarButton("editPlan", "编辑", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                script.Append(new ToolBarButton("delPlan", "删除", string.Format(iconUrl, "delete16.gif"), "Toolbar").createButton());
                script.Append(new ToolBarButton("sendPlan", "送审核", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                break;
                //单位审核
            case"check":
                script.Append(new ToolBarButton("viewPlan", "查看", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                script.Append(new ToolBarButton("checkPlan", "部门审核", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                break;
            case"parentcheck":
                script.Append(new ToolBarButton("viewPlan", "查看", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                script.Append(new ToolBarButton("checkPlan", "审核", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                break;
            case"planup":
                script.Append(new ToolBarButton("viewPlan", "查看", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                script.Append( new ToolBarButton( "checkPlan", "省公司审核", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                break;
            case"my":
                script.Append(new ToolBarButton("viewPlan", "查看", string.Format(iconUrl, "edit16.gif"), "Toolbar").createButton());
                script.Append( new ToolBarButton( "viewProvidePlan", "查看要货情况", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "checkReport", "上报情况", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                script.Append( new ToolBarButton( "vstaticreport", "查看计划情况", string.Format( iconUrl, "edit16.gif" ), "Toolbar" ).createButton( ) );
                break;

        }
        script.Append("Toolbar.render();\r\n");
        script.Append("}\r\n");
        return script.ToString();
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";

            method = Request.QueryString["method"];

                switch (method)
                {
                    
                    case "add":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.addMst(this);
                        break;
                    case"getmst":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getMst(this);
                        break;
                    case"getdtllist":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getDetailList(this);
                        break;
                    case"deletemst":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.deleteMst(this);
                        break;
                    case"editmst":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.editMst(this);
                        break;
                    case"getmstlist":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getMstList(this);
                        break;
                    case"sight":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.addSight(this);
                        break;
                    case"getproductplan":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getProductPlanInformation( this );
                        break;
                    case"getdtlinfo":
                        ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.getDetailInfo( this );
                        break;
                    case"getProcessInfo":
                        //ZJSIG.UIProcess.SCM.UIScmPurchPlanMst.get
                        //StringBuilder script = new StringBuilder();
                        
                        //this.Response.Write( script.ToString( ) );
                        //this.Response.End( );
		            
                        break;
                    
                }
                  
    }
}
