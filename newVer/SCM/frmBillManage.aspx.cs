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
using System.IO;
using ZJSIG.UIProcess.SCM;

public partial class SCM_frmBillManage : PageBase
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
        script.Append(ZJSIG.UIProcess.SCM.UIScmVehicleAttr.getOrgListStore(this));

        //获取部门列表
        script.Append("var dsDept = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmDept.getDeptSimpleStore(ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this)));

        //获取仓库列表
        script.Append("var dsWareHouse = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsWarehouse.getWarehouseListInfoStore(this));
                
        //开票方式
        script.Append("var dsPayType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S03"));

        //收款方式
        script.Append("var dsAcctType = ");
        script.Append(ZJSIG.UIProcess.ADM.UISysDicsInfo.getDicsInfoStore("S11"));

        //人员
        script.Append("var dsUser = ");
        script.Append(ZJSIG.UIProcess.ADM.UIAdmEmployee.getEmployeeListStore(this));

        script.Append("</script>\r\n");
        return script.ToString();
    }


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

    protected void Page_Load(object sender, EventArgs e)
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
            switch (method)
            {
                case "getBillList":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.getBillList(this);
                    break;
                case "generAccount"://生成应收帐款
                    ZJSIG.UIProcess.SCM.UIScmBillManage.generAccount(this);
                    break;
                case "checkBillData":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.checkBillInfo(this);
                    break;
                case "exportData"://导出数据
                    ExportGeneratedInvoice( this );
                    break;
                case "importData":
                    ImportFileAndAnalysis( this );                    
                    break;
                case "getBillDtlInfo":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.getBillDtlList(this);
                    break;
                case "discardBillData":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.discardBillData(this);
                    break;
                case "rollBillData":
                    //ZJSIG.UIProcess.SCM.UIScmBillManage.rollBillData(this);
                    /* 1.生成EXT2＝0的应收款记录（红字F062与蓝字F061的资金方向均为F051，且金额Amount均为正值，记录发票id
                     *   其中红字时使累计应收款余额减少，蓝字增加
                     * 2.不影响应收账款最近余额表 Fm_Account_Receivable_Renct
                     * 3.生成一红一蓝的发票记录用于金税打印
                     * 4.根据必要信息可以使用于在导出金税前，调整发票的主体相关信息，例如调整发票抬头，地址，银行等
                     */
                    break;
                case "updateInfo":
                    ZJSIG.UIProcess.SCM.UIScmBillManage.updateBillData(this);
                    break;
                case"printdata":
                    string billId = this.Request[ "BillId" ];
                    string str = "";
                        ZJSIG.Common.DataSearchCondition.QueryConditions query = new ZJSIG.Common.DataSearchCondition.QueryConditions();
                        query.Condition.Add(new ZJSIG.Common.DataSearchCondition.Condition("BillId",billId,ZJSIG.Common.DataSearchCondition.Condition.CompareType.SelectIn));
                        query.TableName = "VScmBillMst";
                        DataSet ds = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 20, 0, query, "" );
                        DataColumn dc = new DataColumn( "PJName" );
                        dc.DefaultValue =OrgName+ "票据清单";
                        ds.Tables[ 0 ].Columns.Add( dc );
                        query.TableName = "VScmBillDtl";
                        DataSet dsDtl = ZJSIG.UIProcess.UIProcessBase.getDataSetByQuery( 10000, 0, query, "" );
                        DataTable dtDtl= dsDtl.Tables[ 0 ];
                        dtDtl.TableName = "dtDtl";
                        dsDtl.Tables.Remove( dtDtl );
                        ds.Tables.Add( dtDtl );
                        str = ToDataSetString( ds );
                    
                    this.Response.Write( str );
                    this.Response.End( );
                    break;
            }
        }
        catch (System.Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    /// <summary>
    /// 根据明细id串，生成发票文件，保存起来后，客户端下载
    /// </summary>
    public void ExportGeneratedInvoice( Page p )
    {
        string fileName = ZJSIG.UIProcess.ADM.UIAdmUser.OrgID( this ) + "_" + DateTime.Now.ToString( "yyyyMMddHHmmss" ) + ".txt";
        string filePath = Path + "\\invoice_files\\export_files\\" + fileName;
        //using ( FileStream fs = File.Create( filePath ) )
        //{
        //StreamWriter sw = new StreamWriter(fs, Encoding.Default);//ansi code
        //sw.Write(UIScmBillManage.ExportBillInfo(this)); 
        //调用生成文件逻辑
        //组装主记录呀明细呀什么的
        //sw.WriteLine( "This is my file." );
        //sw.WriteLine( "I can write ints {0} or floats {1}, and so on.",
        //    1, 4.2 );
        //sw.Close( );
        ////对要导出的发票进行合理性检查
        //this._SaleFacade.checkZZFP( this._strFPXH, out strPassXH, out this._dsBad );
        //this._SaleFacade.getZZFPInfo(strPassXH,out strFPText,out strBadFPText,out strFPXH);
        //if ( str_tmpFile.Length > 0 )
        //{

        //    try
        //    {
        //        System.IO.TextWriter file = new System.IO.StreamWriter( strPath, true, System.Text.Encoding.GetEncoding( "GB2312" ) );
        //        file.WriteLine( "SJJK0101~~销售单据传入" );
        //        for ( int ii = 0; ii < str_tmpFile.Length; ii++ )
        //        {
        //            file.WriteLine( str_tmpFile[ ii ] );
        //        }

        //        file.Close( );

        //    }
        //    catch ( System.IO.IOException e )
        //    {
        //        System.Console.Write( e.ToString( ) );
        //        return -1;
        //    }

        //    str_tmpOut = str_fpxh.Split( ',' );
        //    return this._SaleFacade.updateZZFPState( str_tmpOut );

        //}


        //FileStream fs = new FileStream( filePath, FileMode.Open );

        FileStream fs = new FileStream( filePath,
                      FileMode.CreateNew, FileAccess.Write, FileShare.None );
        StreamWriter sw = new StreamWriter( fs, Encoding.Default );
        sw.Write( UIScmBillManage.ExportBillInfo( this ) );
        sw.Flush( );
        sw.Close( );
        fs.Close( );
        fs = new FileStream( filePath, FileMode.Open );
        byte[ ] bytes = new byte[ (int)fs.Length ];
        fs.Read( bytes, 0, bytes.Length );
        fs.Close( );
        p.Response.ContentType = "application/octet-stream";
        //通知浏览器下载文件而不是打开
        p.Response.AddHeader( "Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode( fileName, System.Text.Encoding.Default ) );
        p.Response.BinaryWrite( bytes );
        p.Response.Flush( );
        fs.Close( );
        p.Response.End( );

        //}        
    }

    /// <summary>
    /// 导入处理的文件，并解析处理
    /// </summary>
    /// <returns></returns>
    public void ImportFileAndAnalysis(Page p )
    {
        ///'遍历File表单元素  
        HttpFileCollection files = Request.Files;
        
        try
        {
            for (int iFile = 0; iFile < files.Count; iFile++)
            {
                //检查文件扩展名字  
                HttpPostedFile postedFile = files[iFile];
                string fileName, fileExtension;
                fileName = System.IO.Path.GetFileName(postedFile.FileName);
                if (fileName != "")
                {
                    string fileName_Prifix = ZJSIG.UIProcess.ADM.UIAdmUser.OrgID(this) + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "_";
                    string filePath = Path + "\\invoice_files\\import_files\\" + fileName_Prifix + fileName;
                    ///注意：可能要修改你的文件夹的匿名写入权限。  
                    postedFile.SaveAs(filePath);
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
                    }
                }
            }
            p.Response.Write("{\"success\":\"true\",\"errorinfo\":\"导入成功！\"}");
        }
        catch (System.Exception Ex)
        {
            p.Response.Write("{\"success\":\"false\",\"errorinfo\":\"导入发生异常"+Ex.Message+"！\"}");            
        }
        finally
        {
            p.Response.End();
        }
    }
}
