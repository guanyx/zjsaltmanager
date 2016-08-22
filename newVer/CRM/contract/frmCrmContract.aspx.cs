using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using System.Text;
using ZJSIG.UIProcess.Common;
using System.IO;

public partial class CRM_Contract_frmCrmContract : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //合同类型
        script.Append( "var dsContractType = " );
        script.Append(UISysDicsInfo.getDicsInfoStore(CommonDefinition.CRM_CONTRACT_TYPE));

        //合同状态
        script.Append( "var dsState = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.CRM_CONTRACT_STATE ) );

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {

        string method = "";
        try
        {
            method = Request.QueryString["method"];
        }
        catch ( Exception ex )
        {
        }

        switch ( method )
        {
            case "getContractType"://合同类型下拉框
                break;
            case "getContractList":
                ZJSIG.UIProcess.CRM.UICrmContract.getContractList( this);
                break;
            case "deleteContract":
                ZJSIG.UIProcess.CRM.UICrmContract.deleteContract( this);
                break;
            case "getContract":
                ZJSIG.UIProcess.CRM.UICrmContract.getContract( this );
                break;
            case "addContract":
                if ( SaveFiles( ) )
                    ZJSIG.UIProcess.CRM.UICrmContract.addContract( this );
                break;
            case "saveContract":
                if ( SaveFiles( ) )
                ZJSIG.UIProcess.CRM.UICrmContract.editContract( this );
                break;
            case "getAccessories":
                download( Request.Params["fileName"] );
                break;
        }       
    }
    /// <summary>
    /// 上传文件
    /// </summary>
    /// <returns></returns>
    public Boolean SaveFiles()
    {
        ///'遍历File表单元素  
        HttpFileCollection files = Request.Files;
        
        try
        {
            for ( int iFile = 0; iFile < files.Count; iFile++ )
            {
                ///'检查文件扩展名字  
                HttpPostedFile postedFile = files[ iFile ];
                string fileName, fileExtension;
                fileName = System.IO.Path.GetFileName( postedFile.FileName );
                if ( fileName != "" )
                {
                    ///注意：可能要修改你的文件夹的匿名写入权限。  
                    postedFile.SaveAs( Request.PhysicalApplicationPath
                        + CommonDefinition.CONTRACT_FILE_UPLOAD_ROOT_PATH  + fileName );
                        //+ CommonDefinition.CONTRACT_FILE_UPLOAD_ROOT_PATH + DateTime.Now.ToString( "yyyyMMddHHmmsss" ) + "_" + fileName );
                }
            }
            return true;
        }
        catch ( System.Exception Ex )
        {
            return false;
        }
    }
    /// <summary>
    /// 下载需要的文件
    /// </summary>
    /// <param name="fileName">客户端需要的文件名</param>
    private void download( string fileName )
    {
        string filePath = Request.PhysicalApplicationPath + CommonDefinition.CONTRACT_FILE_UPLOAD_ROOT_PATH + fileName;//路径

        //以字符流的形式下载文件
        try
        {
            FileStream fs = new FileStream( filePath, FileMode.Open );
            byte[ ] bytes = new byte[ (int)fs.Length ];
            fs.Read( bytes, 0, bytes.Length );
            fs.Close( );
            Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            Response.AddHeader( "Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode( fileName, System.Text.Encoding.Default ) );
            Response.BinaryWrite( bytes );
            Response.Flush( );
            Response.End( );
        }
        catch ( FileNotFoundException fnfe )
        {
            string errMsg = "您要查看的文件不存在";
            Response.Redirect( Request.ApplicationPath + "/errorPage.aspx" + "?errMessage=" + errMsg );
        }
        catch ( Exception ex )
        {
            string errMsg = "访问您要查看的文件时，出现异常："+ex.Message;
            Response.Redirect( Request.ApplicationPath + "/errorPage.aspx" + "?errMessage=" + errMsg );
        }
    }
}
