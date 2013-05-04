function log(message) {
  UIALogger.logMessage('[LOG]: ' + message);
}

function delay(seconds) {
  var defaultDelaySeconds = 1;
  if (seconds == undefined) { seconds = defaultDelaySeconds; }
  UIATarget.localTarget().delay(seconds);
}

function throttle(command, timeoutSeconds) {
  var defaultTimeoutSeconds = 10;
  if (timeoutSeconds == undefined) { timeoutSeconds = defaultTimeoutSeconds; }

  delay();
  UIATarget.localTarget().pushTimeout(timeoutSeconds);
  command();
  UIATarget.localTarget().popTimeout();
  delay();
}
