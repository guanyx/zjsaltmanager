﻿using System;
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

public partial class SCM_frmOrderCheck : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {

        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取组织
        script.Append("var dsOrg = ");  //这个变量名界面combobox需要使用，保持一致
        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        script.Append(ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore(this));

        //获取部门列表
        script.Append( "var dsDept = " );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore( ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) ) );

        //获取仓库列表
        //script.Append( "var dsWareHouse = " );
        //script.Append( ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore( this ) );

        //订单类型
        //script.Append("var dsOrderType = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S01"));

        //开票方式
        //script.Append("var dsPayType = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S03"));

        //结算方式
        //script.Append("var dsBillMode = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S02"));

        //配送方式
        //script.Append("var dsDlvType = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S04"));

        //送货等级
        //script.Append("var dsDlvLevel = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S05"));

        script.Append("</script>\r\n");
        return script.ToString();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getOrderList":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.getOrderList(this);
                    break;
                case "Check":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.checkOrder(this);
                    break;
                case "getWarehouseList"://获取货位下拉列表
                    ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseList(this);
                    break;
                case "getCommList":
                    ZJSIG.UIProcess.ADM.UISysDicsInfo.getSysDicsInfoList(this);
                    break;
                case"cancelCheck":
                    ZJSIG.UIProcess.SCM.UIScmOrderMst.cancleCheckOrder( this );
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
