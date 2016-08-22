/**
 *文件名称：Ajax.js
 *    说明：支持异步或者同步Ajax请求，
 *     Ajax(url,callBackHandler,xml)
 *		url:调用的web端url
 *		callBackHandler:回调函数 ,不设置回调函数，则为同步调用
 *		xml:发送的xml字符串
 */

/*
 * 返回一个新的 XMLHttpRequest 对象，假如浏览器不支持，返回false
 */
function newXMLHttpRequest() {

  var xmlreq = false;

  if (window.XMLHttpRequest) {

    // Create XMLHttpRequest object in non-Microsoft browsers
    xmlreq = new XMLHttpRequest();

  } else if (window.ActiveXObject) {

    // Create XMLHttpRequest via MS ActiveX
    try {
      // Try to create XMLHttpRequest in later versions
      // of Internet Explorer

      xmlreq = new ActiveXObject("Msxml2.XMLHTTP");

    } catch (e1) {

      // Failed to create required ActiveXObject

      try {
        // Try version supported by older versions
        // of Internet Explorer

        xmlreq = new ActiveXObject("Microsoft.XMLHTTP");

      } catch (e2) {

        // Unable to create an XMLHttpRequest with ActiveX
      }
    }
  }

  return xmlreq;
}


/*
 * Adds an item, identified by its product code, to the shopping cart
 * itemCode - product code of the item to add.
 */
function Ajax(url,callBackHandler,xml) {
	if(xml==null) xml="";

	var asynchronous = true;
	if(callBackHandler ==null)
		asynchronous = false;
if (url.indexOf("?") >=0)
	url = url +"&url_source=XMLHTTP";
	else
	url = url +"?url_source=XMLHTTP";
  // Obtain an XMLHttpRequest instance
  var req = newXMLHttpRequest();

  // Set the handler function to receive callback notifications
  // from the request object
  var handlerFunction = getReadyStateHandler(req, callBackHandler);
  req.onreadystatechange = handlerFunction;

  // Open an HTTP POST connection to the shopping cart servlet.
  // Third parameter specifies request is asynchronous.
  req.open("POST", url, callBackHandler);

  // Specify that the body of the request contains form data
  req.setRequestHeader("Content-Type","multipart/form-data");

  // Send form encoded data stating that I want to add the 
  // specified item to the cart.
  req.send(xml);
  if(asynchronous)
	  return req;
  else
	{
		return req.responseText;
	}
}

/*
 * Returns a function that waits for the specified XMLHttpRequest
 * to complete, then passes its XML response to the given handler function.
 * req - The XMLHttpRequest whose state is changing
 * responseXmlHandler - Function to pass the XML response to
 */
function getReadyStateHandler(req, callBackHandler) {

  // Return an anonymous function that listens to the 
  // XMLHttpRequest instance
  return function () {

    // If the request's status is "complete"
    if (req.readyState == 4) {
      
      // Check that a successful server response was received
      if (req.status == 200) {
		var ud = req.responseText;
		

        // Pass the XML payload of the response to the 
        // handler function
		 if(typeof(callBackHandler)=='function')
			callBackHandler(ud);
		else if(typeof(callBackHandler)=='string')
			eval(callBackHandler + "(ud);");
		else
			alert('参数错误！请传递一个Function对象或者一个字符串');

      } else {

        // An HTTP problem has occurred
        //alert("HTTP error: "+req.status);
      }
    }
  }
}


