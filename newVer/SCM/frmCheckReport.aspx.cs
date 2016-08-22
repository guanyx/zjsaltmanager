using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess;
using ZJSIG.Common.DataSearchCondition;

public partial class SCM_frmCheckReport : System.Web.UI.Page
{
    public string getColModel()
    {
        StringPlus reader = new StringPlus();
        reader.AppendLine("var gridStore = new Ext.data.Store({");
        reader.AppendLine("url: 'frmCheckReport.aspx?method=getlist',");

        reader.AppendLine(" reader :new Ext.data.JsonReader({");
        reader.AppendLine("totalProperty: 'totalProperty',");
        reader.AppendLine("root: 'root',");
        //reader.AppendLine( string.Format("idProperty: '{0}',",itemReport.ReportPrimarykey) );
        reader.AppendLine("fields: [");


        StringPlus script = new StringPlus();
        script.Append("<script>\r\n");
        //需要创建的Grid显示列
        script.Append("var colModel = new Ext.grid.ColumnModel({\r\n");
        script.AppendSpaceLine(1, "columns: [");
        script.AppendSpaceLine(2, "new Ext.grid.RowNumberer(),");
        ZJSIG.UIProcess.Common.DataGridColumn gridColum = new ZJSIG.UIProcess.Common.DataGridColumn();

        gridColum.DataIndex = "ProductNo";
        gridColum.Header = "商品编号";
        gridColum.Id = "ProductNo";
        gridColum.Renderer = "";     
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");
        
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "ProductNo", "string") + "},");

        gridColum.DataIndex = "ProductName";
        gridColum.Header = "商品名称";
        gridColum.Id = "ProductName";
        gridColum.Renderer = "";
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "ProductName", "string") + "},");

        gridColum.DataIndex = "CheckNum";
        gridColum.Header = "核销数量";
        gridColum.Id = "CheckNum";
        gridColum.Renderer = "";
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "CheckNum", "float") + "},");

        gridColum.DataIndex = "SalePrice";
        gridColum.Header = "商品单价";
        gridColum.Id = "SalePrice";
        gridColum.Renderer = "";
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "SalePrice", "float") + "},");

        gridColum.DataIndex = "SaleAmt";
        gridColum.Header = "商品总价";
        gridColum.Id = "SaleAmt";
        gridColum.Renderer = "";
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "},");
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "SaleAmt", "float") + "},");

        gridColum.DataIndex = "CheckOthor";
        gridColum.Header = "客户运费";
        gridColum.Id = "CheckOthor";
        gridColum.Renderer = "";
        script.AppendSpaceLine(2, "{" + gridColum.ToJsString(0) + "}");
        script.AppendSpaceLine(1, "]});");
        reader.AppendSpaceLine(1, "{" + string.Format("name:'{0}',type:'{1}'", "CheckOthor", "float") + "}");
        reader.AppendSpaceLine(1, "]})");
        reader.AppendLine("});");
        //重量（吨）、数量、不含税商品单价、含税商品单价、不含税商品金额、含税商品金额、不含税客户运费、含税客户运费、税率、税额、不含税总金额、含税总金额、总税额（按不同税率计算金额）

        script.Append(reader.ToString());

        script.Append("</script>");
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
            //获取机构列表信息
            case "getlist":
                List<ZJSIG.Common.GroupField> groupList = new List<ZJSIG.Common.GroupField>();
                ZJSIG.Common.GroupField groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "ProductNo";
                groupField.AsName = "商品编号";
                groupField.GroupType = "Group By";
                groupList.Add(groupField);
                groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "ProductName";
                groupField.AsName = "商品名称";
                groupField.GroupType = "Group By";
                groupList.Add(groupField);
                groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "CheckNum";
                groupField.AsName = "核销数量";
                groupField.GroupType = "Sum";
                groupList.Add(groupField);
                groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "SalePrice";
                groupField.AsName = "销售单价";
                groupField.GroupType = "Sum";
                groupList.Add(groupField);
                groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "SaleAmt";
                groupField.AsName = "销售额";
                groupField.GroupType = "Sum";
                groupList.Add(groupField);
                groupField = new ZJSIG.Common.GroupField();
                groupField.FieldName = "CheckOthor";
                groupField.AsName = "运费";
                groupField.GroupType = "Sum";
                groupList.Add(groupField);

                QueryConditions query = new QueryConditions();
                query.TableName = "VScmOrderCheckList";
                ZJSIG.UIProcess.UIProcessBase.setWebFilter(query, this);
                DataSet ds = ZJSIG.ADM.BLL.BLGetListCommon.getDynamicStatistics(groupList, query);
                this.Response.Write(UIProcessBase.DataTableToJson(ds.Tables[0]));
                this.Response.End();
                break;            
        }
    }
}
