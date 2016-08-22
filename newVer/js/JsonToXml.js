
//把当前的Store对象转换成Xml格式的数据
function JsonToXml1(stroeToXml)
{
    var xml = document.createElement("graphData");
    stroeToXml.each(function(store) {
        var stationNode = document.createElement("RowValue");
        var add = true;
        for(var i=0;i<store.fields.items.length;i++)
        {
            var avalue = store.data[store.fields.items[i].name];
            if(avalue==null)
                avalue="";
            if(avalue=="合计")
            {
                add=false;
                break;
            }
            stationNode.setAttribute(store.fields.items[i].name,avalue);
        }
        if(add)
            xml.appendChild(stationNode);
     });
    return xml.innerHTML;
}
function JsonToXml2(stroeToXml)
{
    var xml = '';
    stroeToXml.each(function(store) {
        var stationNode = '<rowvalue ';
        var add = true;
        for(var i=0;i<store.fields.items.length;i++)
        {
            var avalue = store.data[store.fields.items[i].name];
            if(avalue==null)
                avalue="";
            if(avalue=="合计")
            {
                add=false;
                break;
            }
            stationNode += store.fields.items[i].name + '="' + avalue+'" ';
        }
        if(add){
            stationNode +='></rowvalue>';
            xml += stationNode;
        }
     });    
    return xml;
}