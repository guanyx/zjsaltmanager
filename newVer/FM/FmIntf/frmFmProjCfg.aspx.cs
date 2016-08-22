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
using ZJSIG.UIProcess.ADM;
using ZJSIG.UIProcess.FM;
using ZJSIG.UIProcess.Common;
using System.Text;

public partial class FM_FmIntf_frmFmProjCfg : PageBase
{
    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        //字段类型
        script.Append( "var dsFieldType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_FIELD_TYPE ) );

        //接口方案类型
        script.Append( "var dsBillType = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_BILL_TYPE ) );

        //字段分隔符
        script.Append( "var dsFieldSparator = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_FIELD_SPARATOR ) );

        //单据分隔符
        script.Append( "var dsBillSparator = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.FM_BILL_SPARATOR ) );

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
        catch
        {
        }

        switch (method)
        {
            case "getOrgList":
                UIAdmOrg.getOrgList( this );
                break;
            case "deleteCfg":
                UIFmProjCfg.deleteCfg( this );                
                break;
            case "addCfg":
                UIFmProjCfg.addCfg( this );
                break;
            case "saveCfg":
                UIFmProjCfg.editCfg( this );
                break;
            case "getCfg":
                UIFmProjCfg.getCfg( this );
                break;
            case "getCfgList":
                UIFmProjCfg.getCfgList( this );
                break;
            case "deleteFeildCfg":
                UIFmFeildCfg.deleteCfg( this );
                break;
            case "addFieldCfg":
                UIFmFeildCfg.addCfg( this );
                break;
            case "saveFieldCfg":
                UIFmFeildCfg.editCfg( this );
                break;
            case "getFieldCfg":
                UIFmFeildCfg.getCfg( this );
                break;
            case "getFieldList":
                UIFmFeildCfg.getCfgList( this );
                break;

        }        
    }
}
