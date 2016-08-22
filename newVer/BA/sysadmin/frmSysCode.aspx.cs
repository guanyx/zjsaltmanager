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

using ZJSIG.Common.DataSearchCondition;

public partial class BA_sysadmin_frmSysCode : PageBase
{
    protected string getComboBoxStore( )
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );
        script.Append( "var orgId = " + OrgID.ToString( ) + ";\r\n" );
        script.Append( "</script>\r\n" );
        return script.ToString( );
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        QueryConditions query = new QueryConditions( );
        switch ( method )
        {
            case"save":
                long codeId = 0;
                long.TryParse( this.Request[ "CodeId" ], out codeId );
                query.Condition.Add( new Condition( "CodeId", codeId, Condition.CompareType.Equal ) );
                query.TableName = "SysTreeCode";
                DataSet dsSaveCode = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                if ( dsSaveCode.Tables[ 0 ].Rows.Count == 0 )
                {
                    ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( dsSaveCode.Tables[ 0 ] );
                    DataRow dr = dsSaveCode.Tables[ 0 ].NewRow( );
                    dr[ "CodeId" ] = 0;
                    dr[ "OperId" ] = this.EmployeeID;
                    dr[ "OrgId" ] = this.OrgID;
                    dr[ "CreateDate" ] = DateTime.Now;
                    long parentId = 0;
                    long.TryParse(this.Request[ "CodeParent" ],out parentId);
                    dr[ "CodeParent" ] = parentId;
                    dr[ "CodeNo" ] = getNewCode( parentId );
                    dsSaveCode.Tables[ 0 ].Rows.Add( dr );
                }
                DataRow drChange = dsSaveCode.Tables[ 0 ].Rows[ 0 ];
                drChange[ "CodeName" ] = this.Request[ "CodeName" ];
                long.TryParse( this.Request[ "CodeSort" ], out codeId );
                drChange[ "CodeSort" ] = codeId;
                drChange[ "CodeMemo" ] = this.Request[ "CodeMemo" ];
                dsSaveCode.Tables[ 0 ].TableName = "SysTreeCode";
                dsSaveCode.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { dsSaveCode.Tables[ 0 ].Columns[ "CodeId" ] };
                dsSaveCode.Tables[ 0 ].Columns.RemoveAt( dsSaveCode.Tables[ 0 ].Columns.Count - 1 );
                ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsSaveCode );
                break;
            case"gettreelist":
                
                query.Condition.Add( new Condition( "OrgId", "1," + OrgID.ToString( ), Condition.CompareType.SelectIn ) );
                query.TableName = "SysTreeCode";
                DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1000, 0, query, "Code_No" );
                string[ ] columns = new string[ ] { "OrgId" };
                string tree = ZJSIG.UIProcess.UIProcessBase.getTreeStringByDataTable( ds.Tables[ 0 ], 0, "CodeId", "CodeName", "CodeParent", null, "" );
                this.Response.Write("["+ tree+"]" );
                this.Response.End( );
                break;
            case"getcode":
                query.Condition.Add( new Condition( "CodeId", this.Request[ "CodeId" ], Condition.CompareType.Equal ) );
                query.TableName = "SysTreeCode";
                DataSet dsCode = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1000, 0, query, "Code_No" );
                this.Response.Write( ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsCode.Tables[ 0 ], "" ) );
                this.Response.End( );
                break;
            case"delete":
                query.Condition.Add( new Condition( "CodeId", this.Request[ "CodeId" ], Condition.CompareType.Equal ) );
                query.TableName = "SysTreeCode";
                DataSet dsDelete = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
                dsDelete.Tables[ 0 ].TableName = "SysTreeCode";
                ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
                try
                {
                    foreach ( DataRow dr in dsDelete.Tables[ 0 ].Rows )
                    {
                        if ( dr[ "OrgId" ].ToString( ) == "1" )
                        {
                            if ( this.OrgID != 1 )
                            {
                                throw new Exception( "省公司数据不能删除！" );
                            }
                        }
                        dr.Delete( );
                    }
                    dsDelete.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { dsDelete.Tables[ 0 ].Columns[ "CodeId" ] };
                    ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsDelete );
                    message.success = true;
                    message.errorinfo = "数据删除成功！";
                }
                catch(Exception ep)
                {
                    message.success = false;
                    message.errorinfo = ep.Message;
                }
                this.Response.Write( ZJSIG.UIProcess.UIProcessBase.ObjectToJson(message) );
                this.Response.End( );
                break;
        }
    }

    private string getNewCode( long parentId )
    {
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "CodeId", parentId, Condition.CompareType.Equal ) );
        query.TableName = "SysTreeCode";
        int count = 0;
        DataSet dsParent = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        //获取细项最大的编号值
        query.Condition.Clear( );
        query.Condition.Add( new Condition( "CodeParent", parentId, Condition.CompareType.Equal ) );
        query.Condition.Add( new Condition( "OrgId", "1," + OrgID, Condition.CompareType.SelectIn ) );
        DataSet dsMaxCode = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "Code_No desc" );
        string code = "";//
        if ( dsParent.Tables[ 0 ].Rows.Count > 0 )
        {
            code = dsParent.Tables[ 0 ].Rows[ 0 ][ "CodeNo" ].ToString( );
        }
        int max =0;
        if ( dsMaxCode.Tables[ 0 ].Rows.Count > 0 )
        {
            string maxCode = dsMaxCode.Tables[0].Rows[0]["CodeNo"].ToString();

            max = int.Parse( maxCode.Substring( maxCode.Length - 2 ) );

        }
        max++;
        return code + max.ToString( ).PadLeft( 2, '0' );

    }
}
