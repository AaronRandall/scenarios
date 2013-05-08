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
  app.mainWindow().tableViews()["Empty list"].cells()["Multi-Selection Demo"].slowTap();
  app.mainWindow().tableViews()["Empty list"].cells()["Select me"].slowTap();
  app.mainWindow().tableViews()["Empty list"].cells()["And me"].slowTap();
  app.mainWindow().tableViews()["Empty list"].cells()["And me too"].slowTap();
  app.navigationBar().leftButton().tap();
})

test("Remove items from a TableView", function(target, app) {
  app.mainWindow().tableViews()["Empty list"].cells()["TableView Demo"].slowTap();
  app.navigationBar().rightButton().slowTap();
  app.mainWindow().tableViews()["Empty list"].cells()["One"].slowTap();
  app.mainWindow().tableViews()["Empty list"].cells()["Two"].slowTap();
  app.toolbar().buttons()["Delete"].slowTap();
  app.navigationBar().rightButton().slowTap();
  app.navigationBar().leftButton().slowTap();

  delay();
})

