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

public partial class SCM_frmOrderDtl : PageBase
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
        //script.Append(ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore(this));
        script.Append(ZJSIG.UIProcess.ADM.UIAdmOrg.getAllAreaOrgListStoreById(this));

        script.Append("var dsTransOrg = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmOrg.getAllAreaOrgListStoreById(this));

        //获取部门列表
        script.Append( "var dsDept = " );
        script.Append( ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore( ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) ) );

        //获取仓库列表
        //script.Append("var dsWareHouse = ");
        //script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this));

        //订单类型
        script.Append("var dsOrderType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S01"));

        //开票方式
        script.Append("var dsPayType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S03"));

        //结算方式
        script.Append("var dsBillMode = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S02"));

        //配送方式
        script.Append("var dsDlvType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S04"));

        //送货等级
        script.Append("var dsDlvLevel = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S05"));

        //规格
        //script.Append("\r\n");
        //script.Append("var dsProductSpecList = ");
        //script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("B01"));

        //单位
        script.Append("\r\n");
        script.Append("var dsUnitList = ");
        script.Append(ZJSIG.UIProcess.BA.UIBaProductUnit.getUnitInfoStore());

        //用途
        script.Append( "\r\n" );
        script.Append( "var dsProductUse = " );
        script.Append( ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoTreeStore( 1, this.OrgID ) );
        //商品
        //script.Append("\r\n");
        //script.Append("var dsProductList = ");
        //script.Append(ZJSIG.UIProcess.BA.UIBaProduct.getProductListInfoStore(this));

        //驾驶员信息
        script.Append("var dsDriver = ");
        script.Append(ZJSIG.UIProcess.SCM.UIScmDriverAttr.getDriverAttrStore(this));

        if ( SaleCanSeeStore )
        {
            script.Append( "\r\n" );
            script.Append( "var strTemplate='<h3><span>{ProductNo}&nbsp;&nbsp;<font color=\"red\">{ProductName}&nbsp;</font><font color=\"green\">{WhQty}</font></span></h3>';" );
        }
        else
        {
            script.Append( "\r\n" );
            script.Append( "var strTemplate='<h3><span>{ProductNo}&nbsp;&nbsp;<font color=\"red\">{ProductName}&nbsp;</font></span></h3>';" );
        }

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
                case "getDtlList":
                    ZJSIG.UIProcess.SCM.UIScmOrderDtl.getDtlList(this);
                    break;                
                case "saveOrder"://保存订单
                    ZJSIG.UIProcess.SCM.UIScmOrderDtl.saveOrder(this);
                    break;
                case "getCusByConLike"://客户列表
                    ZJSIG.UIProcess.CRM.UIBusinessCrmCustomer.getSaleCustomerListForDropDownList(this);
                    break;
                case "getDeptSimple"://根据公司得到部门列表
                    //ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore(0);
                    break;
                case "getCustomProduct"://当前客户可订商品列表
                    ZJSIG.UIProcess.SCM.UIScmOrderDtl.getCustomProduct(this);
                    break;
                case "getProductInfo":
                    ZJSIG.UIProcess.CRM.UICrmCustomerFixpice.getProductByNoForSCM( this );
                    break;
                case"getProductUnits":
                    ZJSIG.UIProcess.BA.UIBaProduct.getProductUnitsStore( this );
                    break;
                case "getProductByNameNo":
                    ZJSIG.UIProcess.BA.UIBaProduct.getProductListByNameAndNo( this );
                    break;
                case "getWareHouse":
                    ZJSIG.UIProcess.WMS.UIWmsWarehouse.getAllWarehouseListByOrgId(this);
                    break;
                case "getCustomerAddList":
                    ZJSIG.UIProcess.CRM.UICrmCustomerAttributes.getAttributesList(this);
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
