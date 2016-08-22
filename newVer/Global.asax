<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        //在应用程序启动时运行的代码

    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //在应用程序关闭时运行的代码

    }
        
            private void CreateLog(string path)
            {
                System.IO.StreamWriter SW;
                SW = System.IO.File.CreateText(path);
                SW.WriteLine("Log created at: " +
                                     DateTime.Now.ToString("dd-MM-yyyy hh:mm:ss"));
                SW.Close();
            }

            private void WriteLog(string Log,string path)
            {
                using (System.IO.StreamWriter SW = System.IO.File.AppendText(path))
                {
                    SW.WriteLine(Log);
                    SW.Close();
                }
            }

    void Application_Error(object sender, EventArgs e) 
    { 
        //在出现未处理的错误时运行的代码
        Exception objErr = Server.GetLastError( ).GetBaseException( ); 
        string error = "发生异常页: " + Request.Url.ToString( ) + "﹤br﹥"; 
        error += "异常信息: " + objErr.Message + "﹤br﹥";
        string path = Server.MapPath("") + "\\log.txt";
        if (System.IO.File.Exists(path))
        {
            
            
        }
        else
        {
            CreateLog(path);
        }
        WriteLog("date:" + DateTime.Now.ToString() + "    " + error, path);
        //Server.ClearError( ); 
        Application[ "error" ] = error;
        //throw new Exception(error);
        Session["error"] = error;
        Response.Redirect( "errorPage.aspx" );
        

    }

    void Session_Start(object sender, EventArgs e) 
    {
        //在新会话启动时运行的代码

    }

    void Session_End(object sender, EventArgs e) 
    {
        //在会话结束时运行的代码。 
        // 注意: 只有在 Web.config 文件中的 sessionstate 模式设置为
        // InProc 时，才会引发 Session_End 事件。如果会话模式 
        //设置为 StateServer 或 SQLServer，则不会引发该事件。

    }
       
</script>
