﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.WMS;
using ZJSIG.UIProcess.BA;
using ZJSIG.UIProcess.ADM;
using System.Text;

public partial class WMS_frmWmsCostStockTypeConf : PageBase
{
    
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        string strId = Request.QueryString["id"];
        bool isEdit = (strId != null && strId.Trim().Length > 0) ? true : false;
        StringBuilder script = new StringBuilder();
        script.Append("<script>\r\n");

        //获取规格
        script.Append("var dsNeedInitWarehouseList = ");

        //可以考虑当为集团公司时，将Request.Form["OrgId"] = ''
        //其他分公司时，Request.Form["OrgId"] = Session["OrgId"]
        script.Append(UIWmsWarehouse.getNeedInitWarehouseList(this, isEdit));

        script.Append("\r\n");
        script.Append("var dsProductSpecList = ");
        script.Append(UISysDicsInfo.getDicsInfoStore("B01"));

        script.Append("\r\n");
        script.Append("var dsProductUnitList = ");
        script.Append(UIBaProductUnit.getUnitInfoStore());

        script.Append("\r\n");
        script.Append("var dsProductList = ");
        script.Append( UIBaProduct.getProductListInfoStore( this ) );
        //组织下员工
        script.Append("\r\n");
        script.Append("var dsOperationList =");
        script.Append(UIAdmEmployee.getEmployeeListStore(this));

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
        catch
        {
            
        }

        switch (method)
        {
            case "getWarehousePosList":
                UIWmsWarehousePosition.getWarehousePositionListByWhId(this);
                break;
            case "saveInventoryOrderInfo":
                UIWmsInventoryOrder.saveOrder(this);
                break;
            case "getInventoryOrderProductList":
                UIWmsInventoryOrderDetail.getDetailList(this);
                break;
            case "getInventoryOrderInfo":
                UIWmsInventoryOrder.getOrder(this);
                break;
            case "getCurrenStockByWarehouse":
                UIWmsStockCurrent.getCurrentStockList(this);
                break;
            case "commitInventoryOrderInfo":
                UIWmsInventoryOrder.commitInventoryOrder(this);
                break;
        }
    }
}
