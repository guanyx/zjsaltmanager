/*获取指定Form的控件值信息



*/

var jsonFormValue='';
function getFromValue(form)
{
    jsonFormValue = '';
    for(var i=0;i<form.items.length;i++)
    {
//        setJsonValue(form.items.items[i]);
        if(form.items.items[i].items==undefined)
        {
            setJsonFieldValue(form.items.items[i]);
        }
        else
        {
            setJsonValue(form.items.items[i])
        }
    }
    return "{"+jsonFormValue+"}";
}

function setJsonValue(panel)
{
    for(var i=0;i<panel.items.length;i++)
    {
        if(panel.items.items[i].items==undefined)
        {
            setJsonFieldValue(panel.items.items[i]);
        }
        else
        {
            setJsonValue(panel.items.items[i])
        }
    }
}

function setJsonFieldValue(field)
{
    if(jsonFormValue.length>0)
    {
        jsonFormValue+=",";
    }
    switch(field.xtype)
    {
        case"datefield":
            if(field.getValue()!='')
            {
                jsonFormValue+=field.id+":'"+field.getValue().dateFormat('Y/m/d')+"'";
            }
            break;
        default:
            jsonFormValue+=field.id+":'"+field.getValue()+"'";
            break;
    }
}

function setFormValue(form,item)
{
    for(var i=0;i<form.items.length;i++)
    {
//        setJsonValue(form.items.items[i]);
        if(form.items.items[i].items==undefined)
        {
            setFormFieldValue(form.items.items[i],item);
        }
        else
        {
            setFormValue(form.items.items[i],item)
        }
    }
}

function setFormFieldValue(field,item)
{
    switch(field.xtype)
    {
        case"datefield":
            if(item[field.id]!="")
            {
                field.setValue(new Date(item[field.id].substring(0,10)));
            }
            break;
        default:
            field.setValue(item[field.id]);
            break;
    }
    
}