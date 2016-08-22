
/* 对返回的数据进行处理   */
function checkExtMessage(resp)
{
    var resu = Ext.decode(resp.responseText);
    //如果是UIMessageBase
    if(resu)
    {
        Ext.Msg.alert('提示消息',resu.errorinfo);
        //返回是否成功
        return resu.success;
    }
    return false;
}

/* 对返回的数据进行处理   */
function checkParentExtMessage(resp,parent) {
    var resu = Ext.decode(resp.responseText);
    //如果是UIMessageBase
    if (resu) {
        parent.Ext.Msg.alert('提示消息', resu.errorinfo);
        //返回是否成功
        return resu.success;
    }
    return false;
}