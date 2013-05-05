app = new Object();
app.tapCount = 0;
app.tap = function(msg) {
  this.tapCount += 1;
  console.log("Tapping number " + this.tapCount + ": " + msg);
}

var intercepting = false;

function intercept(intercepted) {
  intercepting = true;
  intercepted();
  intercepting = false;
}

function test(name, call) {
  console.log("Running " + name);
  call(proxy(app, function() {
    if (intercepting) {
      console.log("In between");
    }
  }));
}

function proxy(proxied, postCall) {
  var proxy = new Object();
  for (var method in proxied) {
    if (typeof proxied[method] == "function") {
      proxy[method] = function() {
        proxied[method].apply(proxied, arguments);
        postCall();
      }
    }
  }
  return proxy;
}

test("abc", function(app) {
  app.tap("a");
  app.tap("b");
  intercept(function() {
    app.tap("c");
    app.tap("d");
  });
});
