function log(message) {
  UIALogger.logMessage('[LOG]: ' + message);
}

function delay(seconds) {
  var defaultDelaySeconds = 1;
  if (seconds == undefined) { seconds = defaultDelaySeconds; }
  UIATarget.localTarget().delay(seconds);
}

function withTimeout(command, timeoutSeconds) {
  var defaultTimeoutSeconds = 10;
  if (timeoutSeconds == undefined) { timeoutSeconds = defaultTimeoutSeconds; }

  delay();
  UIATarget.localTarget().pushTimeout(timeoutSeconds);
  command();
  UIATarget.localTarget().popTimeout();
  delay();
}

Object.prototype.slowTap = function() {
  delay(0.5);
  this.tap();
};

function throttle(target, app, test_steps) {
  eval('var x=' + test_steps.toString().replace(/.tap\(\);/g,'.slowTap();'));
  x(target, app);
}
