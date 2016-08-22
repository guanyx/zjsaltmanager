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
using System.Collections.Generic;
using ZJSIG.UIProcess.ADM;

public partial class QT_Frames_MenuFrame : System.Web.UI.Page
{
    public Dictionary<string, string> menusdic = new Dictionary<string, string>();
    protected void Page_Load(object sender, EventArgs e)
    {
        //(id, pid, name, url, title, target, icon, iconOpen, open)
        List<string[]> menus = menus = UIAdmResource.getResourceMenuList(this);
        /*
        menus.Add( new string[9] { "1", "0", "基础档案", "example01.html", "", "contentFrme", "", "", "" } );
        menus.Add( new string[9] { "2", "0", "客户管理", "CRM/customer/customerManage.aspx", "", "", "", "", "" } );
        menus.Add( new string[9] { "3", "1", "存货档案", "example01.html", "", "contentFrme", "", "", "" } );
        menus.Add( new string[9] { "4", "0", "配送管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "5", "3", "价格管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "6", "5", "商品价格管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "7", "0", "仓库管理", "example01.html", "", "", "", "", "" } );
        menus.Add( new string[9] { "8", "1", "客户经理管理", "example01.html", "", "", "", "", "" } );
        /*特殊制定打开的图片，包括* /
        menus.Add( new string[9] { "9", "0", "My Pictures", "example01.html", "Pictures I\'ve taken over the years", "", "", "../images/tree_pic/imgfolder.gif", "" } );
        /*使用默认target配置* /
        menus.Add( new string[9] { "10", "9", "The trip to Iceland", "example01.html", "Pictures of Gullfoss and Geysir", "", "", "", "" } );
        menus.Add( new string[9] { "11", "0", "用户管理", "BA/sysadmin/userManager.aspx", "", "", "", "", "" } );
        menus.Add( new string[9] { "12", "0", "Recycle Bin", "example01.html", "Pictures of Gullfoss and Geysir", "", "", "../images/tree_pic/trash.gif", "" } );
        */
        //找到第一级菜单
        List<string[]> menus_0 = menus.FindAll(delegate(string[] sa)
        {
            return sa[0] == "11461";// "26";//质检管理，其他的不需要
        });
        Dictionary<string, string> htmls = new Dictionary<string, string>();
        foreach (string[] sarry in menus_0)
        {
            List<string[]> menus_1 = menus.FindAll(delegate(string[] sa)
            {
                return sa[1] == sarry[0];
            });
            string html = "";
            foreach (string[] s in menus_1)
            {
                string menu = "<div class=\"sub_menu_contain\"> "
                    + "<a style=\"display:block;height:22px;\" href=\"javascript:dosomething(&quot;" + s[2] + "&quot;,&quot;" + s[3] + "&quot;)\"><span class=\"ui-icon-triangle-1-e sub_menu\"></span>"
                    + "<span class=\"sub_menu\" style=\"width: 175px;\">" + s[2] + "</span>"
                    + "</a>"
                    + "</div>";
                html += menu;
            }
            menusdic.Add(sarry[2], html);
        }
    }
}
