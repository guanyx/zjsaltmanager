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

using ZJSIG.Common.DataSearchCondition;
using ZJSIG.UIProcess;

public partial class BA_sysadmin_frmOrgBankMail : PageBase
{
    protected void Page_Load( object sender, EventArgs e )
    {
        string method = this.Request.QueryString[ "method" ];
        switch ( method )
        {
            case"getmaillist":
                getmailList( );
                break;
            case "getbankmain":
                getMail( );
                break;
            case"deleteBankmain":
                deleteMail( );
                break;
            case"savemail":
                saveMail( );
                break;
                
        }
    }

    private void saveMail( )
    {
        UIMessageBase message = new UIMessageBase( );
        try
        {
            string mailId = this.Request[ "MailId" ];
            QueryConditions query = new QueryConditions( );
            query.Condition.Add( new Condition( "MailId", mailId, Condition.CompareType.Equal ) );
            query.TableName = "AdmOrgBankmain";
            DataSet dsMail = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
            dsMail.Tables[ 0 ].Columns.RemoveAt( dsMail.Tables[ 0 ].Columns.Count - 1 );
            DataRow drMail = null;
            if ( dsMail.Tables[ 0 ].Rows.Count == 0 )
            {
                ZJSIG.UIProcess.UIProcessBase.ConvertDataTableColumn( dsMail.Tables[ 0 ] );
                drMail = dsMail.Tables[ 0 ].NewRow( );
                dsMail.Tables[ 0 ].Rows.Add( drMail );
            }
            else
                drMail = dsMail.Tables[ 0 ].Rows[ 0 ];
            foreach ( DataColumn dc in dsMail.Tables[ 0 ].Columns )
            {
                if ( dc.ColumnName == "MailId" )
                {
                    drMail[ dc.ColumnName ] = mailId;
                }
                else if ( dc.ColumnName == "OrgId" )
                    drMail[ dc.ColumnName ] = this.OrgID;
                else
                {
                    try
                    {
                        drMail[ dc.ColumnName ] = this.Request[ dc.ColumnName ];
                    }
                    catch
                    {
                    }
                }
            }
            dsMail.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { dsMail.Tables[ 0 ].Columns[ "MailId" ] };
            dsMail.Tables[ 0 ].TableName = "AdmOrgBankmain";
            //foreach ( DataColumn dc in dsMail.Tables[ 0 ].Columns )
            //{
            //    if ( this.Request[ dc.ColumnName ] != null )
            //    {
            //        drMail[ dc ] = this.Request[ dc.ColumnName ];
            //    }
            //}
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsMail );
            message.success = true;
            message.errorinfo = "银行邮件信息保存成功！";
        }
        catch(Exception ep)
        {
            message.success = false;
            message.errorinfo = "银行邮件信息保存失败！" + ep.Message;
        }
        finally
        {
            this.Response.Write( UIProcessBase.ObjectToJson( message ) );
            this.Response.End( );
        }
    }

    private void deleteMail( )
    {
        UIMessageBase message = new UIMessageBase( );
        try
        {
            string mailId = this.Request[ "MailId" ];
            QueryConditions query = new QueryConditions( );
            query.Condition.Add( new Condition( "MailId", mailId, Condition.CompareType.Equal ) );
            query.TableName = "AdmOrgBankmain";
            DataSet dsMail = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
            dsMail.Tables[ 0 ].PrimaryKey = new DataColumn[ ] { dsMail.Tables[ 0 ].Columns[ "MailId" ] };
            dsMail.Tables[ 0 ].Rows[ 0 ].Delete( );
            dsMail.Tables[ 0 ].TableName = "AdmOrgBankmain";
            ZJSIG.ADM.BLL.BLGetListCommon.updateDataSet( dsMail );
            message.success = true;
            message.errorinfo = "银行邮件信息删除成功！";
        }
        catch ( Exception ep )
        {
            message.success = false;
            message.errorinfo = "银行邮件信息删除失败！" + ep.Message;
        }
        finally
        {
            this.Response.Write( UIProcessBase.ObjectToJson( message ) );
            this.Response.End( );
        }

    }

    private void getMail( )
    {
        string mailId = this.Request[ "MailId" ];
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "MailId", mailId, Condition.CompareType.Equal ) );
        query.TableName = "AdmOrgBankmain";
        DataSet dsMail = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 1, 0, query, "" );
        string response = ZJSIG.UIProcess.UIProcessBase.DataTableToJson( dsMail.Tables[ 0 ] );
        this.Response.Write( response );
        this.Response.End( );
    }
    private void getmailList( )
    {
        QueryConditions query = new QueryConditions( );
        query.Condition.Add( new Condition( "OrgId", OrgID, Condition.CompareType.Equal ) );
        query.TableName = "AdmOrgBankmain";
        string response =ZJSIG.ADM.BLL.BLGetListCommon.getJsonListByQuery( 100, 0, query, "" );
        this.Response.Write( response );
        this.Response.End( );
    }
}
