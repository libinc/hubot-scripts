var page = require('webpage').create();
page.open('http://example.com', function() {
  page.render('example.png');
  phantom.exit();
});
