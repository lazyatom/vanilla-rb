{:name => "system",
 :content => "You're in the system snip now.",
 :main_template => %^
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  <title>{title}</title>
  <link rel="stylesheet" type="text/css" media="screen"  href="<%= url_to("system", "css.css") %>" />
</head>
<body>
  <div id="content">
    <div id="controls">
      <strong><a href="/">home</a></strong> ::
      <strong>{link_to_current_snip}</strong>
    </div>
    {current_snip}
  </div>
</body>
</html>^,
 :css => %^
body {
  font-family: Helvetica;
  background-color: #666;
  margin: 0;
  padding: 0;
}

div#content {
  width: 800px;
  margin: 0 auto;
  background-color: #fff;
  padding: 1em;
}^
}