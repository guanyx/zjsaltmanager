using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZJSIG.UIProcess.ADM;
using System.Text;
using ZJSIG.UIProcess.Common;

public partial class CRM_Contract_frmCrmContract : System.Web.UI.Page
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
                if(SaveFiles())
                    ZJSIG.UIProcess.CRM.UICrmContract.addContract( this );
                break;
            case "saveContract":
                ZJSIG.UIProcess.CRM.UICrmContract.editContract( this );
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
                    postedFile.SaveAs( Request.PhysicalApplicationPath + "/upload_files/"  + fileName );
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
