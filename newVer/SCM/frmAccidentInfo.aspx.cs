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
using System.Text;
using ZJSIG.UIProcess.Common;
using ZJSIG.UIProcess.ADM;

public partial class SCM_frmAccidentInfo : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //事故类型
        script.Append( "var dsAccidentType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_ACCIDENT_TYPE ) );

        ////业务状态
        //script.Append( "var dsState = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.SCM_BUSI_TYPE ) );

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
            case "addInfo":
                if ( SaveFiles( ) )
                    ZJSIG.UIProcess.SCM.UIScmAccidentInfo.addInfo( this );
                break;
            case "saveInfo":
                if ( SaveFiles( ) )
                    ZJSIG.UIProcess.SCM.UIScmAccidentInfo.editInfo( this );
                break;
            case "getInfoList":
                ZJSIG.UIProcess.SCM.UIScmAccidentInfo.getInfoList( this );
                break;
            case "getInfo":
                ZJSIG.UIProcess.SCM.UIScmAccidentInfo.getInfo( this );
                break;
            case "deleteInfo":
                ZJSIG.UIProcess.SCM.UIScmAccidentInfo.deleteInfo( this );
                break;

        }
    }
    public Boolean SaveFiles()
    {
        ///'遍历File表单元素  
        HttpFileCollection files = Request.Files;
        try
        {
            for ( int iFile = 0; iFile < files.Count; iFile++ )
            {
                ///'检查文件扩展名字  
                HttpPostedFile postedFile = files[iFile];
                string fileName, fileExtension;
                fileName = System.IO.Path.GetFileName( postedFile.FileName );
                if ( fileName != "" )
                {
                    ///注意：可能要修改你的文件夹的匿名写入权限。  
                    postedFile.SaveAs( Request.PhysicalApplicationPath
                        + CommonDefinition.ACCIDENT_FILE_UPLOAD_ROOT_PATH  + fileName );
                        //+ CommonDefinition.ACCIDENT_FILE_UPLOAD_ROOT_PATH + DateTime.Now.ToString( "yyyyMMddHHmmsss" ) + "_" + fileName );
                }
            }
            return true;
        }
        catch ( System.Exception Ex )
        {
            return false;
        }
    }
}
