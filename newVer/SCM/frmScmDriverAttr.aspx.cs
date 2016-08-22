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
using ZJSIG.UIProcess.Common;
using System.Text;

public partial class SCM_frmScmDriverAttr : PageBase
{

    /// <summary>
    /// 得到界面需要的所有基础代码
    /// </summary>
    /// <returns></returns>
    protected string getComboBoxStore()
    {
        StringBuilder script = new StringBuilder( );
        script.Append( "<script>\r\n" );

        ////获取性别
        //script.Append( "var dsGender = " );
        //script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.ADM_GENDER ) );

        //获取民族
        script.Append( "var dsNation = " );
        script.Append( UISysDicsInfo.getDicsInfoStore( CommonDefinition.ADM_NATION ) );

        //装卸公司
        script.Append("\r\n");
        script.Append("var dsLoadCompanyList = ");
        script.Append(ZJSIG.UIProcess.WMS.UIWmsLoadCompany.getCompanyListStore(this));

        script.Append( "</script>\r\n" );
        return script.ToString( );
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        string method = "";
        try
        {
            method = Request.QueryString["method"];
        
            switch ( method )
            {
                case "deleteAttr":
                    ZJSIG.UIProcess.SCM.UIScmDriverAttr.deleteAttr( this );
                    break;
                case "getattr": 
                    ZJSIG.UIProcess.SCM.UIScmDriverAttr.getAttr( this );
                    break;
                case "addAttr":
                    ZJSIG.UIProcess.SCM.UIScmDriverAttr.addAttr( this );
                    break;
                case "saveAttr":
                    ZJSIG.UIProcess.SCM.UIScmDriverAttr.editAttr(this);
                    break;
                case "getAttrlist":
                    ZJSIG.UIProcess.SCM.UIScmDriverAttr.getAttrList( this );
                    break;
                case "getVehiclelist":
                    ZJSIG.UIProcess.SCM.UIScmDriverVehicleRel.getRelList(this);
                    break;
                case "saveDriverVehicleRel":
                    ZJSIG.UIProcess.SCM.UIScmDriverVehicleRel.addRel(this);
                    break;
                case "deleteRelInfo":
                    ZJSIG.UIProcess.SCM.UIScmDriverVehicleRel.deleteRel(this);
                    break;
            }
        }
        catch (Exception ex)
        {

        }
        
    }
}
