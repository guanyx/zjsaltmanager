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


using ZJSIG.UIProcess;
using System.IO;

public partial class Common_frmUpLoadFile : System.Web.UI.Page
{

    /// <summary>
    /// 获取文件路径
    /// </summary>
    public string Path
    {
        get
        {
            string _path = System.Configuration.ConfigurationSettings.AppSettings[ "UploadFilePath" ];
            if ( _path.IndexOf( ":" ) != -1 )
                return _path;
            else
                return Server.MapPath( "~/" + _path );
        }
    }
    protected void Page_Load( object sender, EventArgs e )
    {
        try
        {
            string uploadpath = Path + "\\" + this.Request["FileType"];
            string fileName = this.Request.QueryString["FileName"];
            string docType = this.Request.QueryString["docType"];
            string method = this.Request.QueryString[ "method" ];

            if (string.IsNullOrEmpty(method))
            {
                if (string.IsNullOrEmpty(docType))
                {
                    doFormUploadDisk(uploadpath, fileName);
                }
                else
                {
                    this.HiddenField1.Value = this.Request.QueryString["docType"];
                }
            }
            else
            {//ajax提交
                switch (method)
                {
                    case "addFileInNews":
                        ZJSIG.UIProcess.BA.UISysMessage.addFileInNews(this);
                        break;
                }
            }
        }
        catch (Exception ex)
        {
        }
    }

    /// <summary>
    /// 发票保存
    /// </summary>
    protected void saveBillImportBackData()
    {
        HttpFileCollection uploadFiles = Request.Files;

        try
        {
            string fileName = System.IO.Path.GetFileName(uploadFiles[0].FileName);
            if (fileName != "")
            {
                string fileName_Prifix = ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "_";
                string filePath = Path + "\\invoice_files\\import_files\\" + fileName_Prifix + fileName;
                ///注意：可能要修改你的文件夹的匿名写入权限。  
                uploadFiles[0].SaveAs(filePath);
                //+ CommonDefinition.CONTRACT_FILE_UPLOAD_ROOT_PATH + DateTime.Now.ToString( "yyyyMMddHHmmsss" ) + "_" + fileName );

                //调用解析文件逻辑
                //拆分行记录后，保存到表呀什么的
                StreamReader strmR;
                string str_tmpRead;
                int int_tmpCount = 0;
                string[] str_tmpReadZ;
                string[] str_tmpOut = new string[0];
                int int_tmplen = 0;
                int int_index = 0;
                try
                {
                    strmR = new StreamReader(filePath, System.Text.Encoding.GetEncoding("GB2312"));
                    strmR.BaseStream.Seek(0, SeekOrigin.Begin);
                    //读取文件中的内容,并将其写到数组
                    while (strmR.Peek() > -1)
                    {
                        //							Console.WriteLine(strmR.ReadLine());
                        int_tmpCount++;
                        str_tmpRead = strmR.ReadLine();
                        str_tmpReadZ = str_tmpRead.Split('~');
                        if (int_tmpCount == 2)
                        {
                            for (int ii = 0; ii < Convert.ToString(str_tmpReadZ[0]).Length; ii++)
                            {
                                if (Char.IsNumber(Convert.ToString(str_tmpReadZ[0]), ii) == false)
                                {
                                    throw new Exception("请确认此文件为导出文件；\n此文件的第二行的第一个字符非数值。");
                                }

                            }

                            int_tmplen = Convert.ToInt16(str_tmpReadZ[0]);
                            str_tmpOut = new string[int_tmplen];

                        }
                        if (int_tmpCount >= 3)
                        {
                            if (str_tmpReadZ.Length >= 5)
                            {
                                if ((str_tmpReadZ[2] == "0" || str_tmpReadZ[2] == "1") /* && str_tmpReadZ[ 4 ] == "0" */) //由于普通发票的标志不清楚（规范为1，实际导出为2），而增值税发票都是0
                                {
                                    if (int_index < int_tmplen)
                                    {
                                        str_tmpOut[int_index] = str_tmpReadZ[0] + "," + str_tmpReadZ[6] + "," + str_tmpReadZ[8] + "," + str_tmpReadZ[16];
                                        int_index++;
                                    }

                                }
                            }

                        }
                        //写入dataset
                    }
                    strmR.Close();
                }
                catch (System.IO.IOException e)
                {
                    throw new Exception(e.Message.ToString());

                }

                //
                string[] tmp_strForSave = new string[int_index];

                for (int ii = 0; ii < int_index; ii++)
                {
                    tmp_strForSave[ii] = str_tmpOut[ii];
                }
                //将发票种类号、发票号码和传输标志更新到增值发票的相应的记录
                if (ZJSIG.UIProcess.SCM.UIScmBillManage.ImportBillInfo(this, tmp_strForSave) >= 0)
                {
                    //导入成功
                    Response.Write("<Script Language=JavaScript>alert('导入成功！'); parent.fileWindow.hide();  </Script>");
                    //Response.Write(" <script> closeuploadForm(); </script> ");
                }
            }
        }
        catch (System.Exception Ex)
        {
            Response.Write("<Script Language=JavaScript>alert('导入失败！'); </Script>");
        }
        finally
        {

        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        switch(this.HiddenField1.Value)
        {
            case "bill":
                saveBillImportBackData();
                break;
            break;
        }
    }

    public void doFormUploadDisk(string uploadpath, string fileName)
    {        
        //uploadpath += this.getDirectory( );
        System.Web.HttpFileCollection uploadFiles = Request.Files;
        System.Web.HttpPostedFile theFile;
        //string fileNames = "";
        ZJSIG.UIProcess.UIMessageBase message = new ZJSIG.UIProcess.UIMessageBase( );
        try
        {
            for ( int i = 0; i < uploadFiles.Count; i++ )
            {
                theFile = uploadFiles[ i ];
                if ( uploadFiles.GetKey( i ).ToUpper( ) == "CONTARCTATTACH" )
                {
                    //string filename = theFile.FileName.Substring( theFile.FileName.LastIndexOf( '\\' ) + 1 );
                    theFile.SaveAs( uploadpath + @"\" + fileName );
                    //if ( fileNames.Length > 0 )
                    //{
                    //    fileNames += ",";
                    //}
                    //fileNames += filename;
                }
            }
            message.errorinfo = fileName + "文件保存成功！";
            message.success = true;
        }
        catch ( Exception ep )
        {
            message.errorinfo = ep.Message;
            message.success = false;
        }
        finally
        {
            this.Response.Write( UIProcessBase.ObjectToJson( message ) );
            this.Response.End( );
        }
    }

}
