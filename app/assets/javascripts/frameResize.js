function iframe_resize(){
  var body = document.body,
  html = document.documentElement,
  height = Math.max(body.scrollHeight, body.offsetHeight,
  html.clientHeight, html.scrollHeight, html.offsetHeight);
  if (parent.postMessage)
  {
    parent.postMessage(height, "*");
  }
}
