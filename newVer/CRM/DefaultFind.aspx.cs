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
using ZJSIG.UIProcess.SCM;
using ZJSIG.Common.DataSearchCondition;

public partial class CRM_DefaultFind : System.Web.UI.Page
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch ( method )
            {
                case "getLineTreeByOrg": // 根据组织得到线路
                    ZJSIG.UIProcess.SCM.UIScmDistributionRoute.getLineTreeByOrg(this );
                    break;
                case "getLineCustomer"://根据线路得到客户
                    ZJSIG.UIProcess.SCM.UIScmDistributionRouteRel.getRelList( this );
                    break;
                case "getptreelist"://得到所有商品分类
                    ZJSIG.UIProcess.BA.UIBusinessBaProductType.getBaProducctTypeTreeList( this );
                    break;
                case "getClassProducts"://得到已经建立对应关系的商品
                    ZJSIG.UIProcess.BA.UIBaProductClass.getClassList( this );
                    break;
                case"getWhTreeByOrg":
                    ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions();
                    query.Condition.Add(new Condition("OrgId",ZJSIG.UIProcess.UIProcessBase.OrgID(this),Condition.CompareType.Equal));
                    query.Columns = "Wh_Id,Wh_Name,Wh_Code";
                    query.TableName="WmsWarehouse";
                    DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery(100,0,query,"wh_code asc");
                    DataColumn dc = new DataColumn("ParentWh",typeof(System.Int16));
                    dc.DefaultValue = 0;
                    ds.Tables[ 0 ].Columns.Add( dc );
                    string tree = ZJSIG.UIProcess.UIProcessBase.getTreeStringByDataTable( ds.Tables[ 0 ], 0, "WhId", "WhName", "ParentWh", null,null,"" );
                    this.Response.Write("["+ tree+"]" );
                    this.Response.End( );
                    break;
                case"getSaleDeptData":
                    QueryConditions query1 = new QueryConditions( );
                    query1.TableName = "AdmDept";
                    query1.Columns = "Dept_Id,Dept_Name,Dept_Parent";
                    query1.Condition.Add( new Condition( "DeptType", "A083", Condition.CompareType.Equal ) );
                    query1.Condition.Add( new Condition( "OrgId", ZJSIG.UIProcess.UIProcessBase.OrgID( this ), Condition.CompareType.Equal ) );
                    System.Data.DataSet dsDept =
                        ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 100, 0, query1, "" );
                    DataColumn dc1 = new DataColumn( "ParentDept", typeof( System.Int16 ) );
                    dc1.DefaultValue = 0;
                    dsDept.Tables[ 0 ].Columns.Add( dc1 );
                        string dept = ZJSIG.UIProcess.UIProcessBase.getTreeStringByDataTable( dsDept.Tables[ 0 ], 0, "DeptId", "DeptName", "ParentDept", null, null, "" );
                    this.Response.Write( "[" + dept + "]" );
                    this.Response.End( );
                    break;
                //case"getLineTree":
                //    ZJSIG.UIProcess.SCM.UIScmDistributionRoute.getLineTreeToFileter(this, true);
                //    break;
            }
        }
        catch ( System.Exception ex )
        {
            Console.WriteLine( ex.Message );
        }
    }
}
