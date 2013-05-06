#import "support/scenarios.js"

test("Login using username and password", function(target, app) {
    app.mainWindow().tableViews()["Empty list"].cells()["Form Control Demo"].tap();
    app.mainWindow().textFields()["Username"].tap();
    app.keyboard().typeString("RonSwanson");
    app.mainWindow().secureTextFields()["Password"].tap();
    app.keyboard().typeString("mypassword\n");

    withTimeout(function(){
    app.mainWindow().buttons()["Login"].tap();
      UIATarget.onAlert = function onAlert(alert) {
        alert.buttons()["OK"].tap();
        return true;
      }
    });

    app.navigationBar().leftButton().tap();
})

test("Multi-select list items", function(target, app) {
  throttle(target, app, function() {
    app.mainWindow().tableViews()["Empty list"].cells()["Multi-Selection Demo"].tap();
    app.mainWindow().tableViews()["Empty list"].cells()["Select me"].tap();
    app.mainWindow().tableViews()["Empty list"].cells()["And me"].tap();
    app.mainWindow().tableViews()["Empty list"].cells()["And me too"].tap();
    app.navigationBar().leftButton().tap();
  });
})

test("Remove items from a TableView", function(target, app) {
  app.mainWindow().tableViews()["Empty list"].cells()["TableView Demo"].tap();
  app.navigationBar().rightButton().tap();
  app.mainWindow().tableViews()["Empty list"].cells()["One"].tap();
  app.mainWindow().tableViews()["Empty list"].cells()["Two"].tap();
  app.toolbar().buttons()["Delete"].tap();
  app.navigationBar().rightButton().tap();
  app.navigationBar().leftButton().tap();
})

