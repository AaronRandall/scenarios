#import "support/scenarios.js"

UIALogger.logMessage("[INFO]: " + "STARTING TESTING");

test("Remove items from list", function(target, app) {
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Multi Edit Demo"].tap();
  target.frontMostApp().navigationBar().rightButton().tap();
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["One"].tap();
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Two"].tap();
  target.frontMostApp().toolbar().buttons()["Delete"].tap();
  target.frontMostApp().navigationBar().rightButton().tap();
  target.frontMostApp().navigationBar().leftButton().tap();
})

test("Multi-select list items", function(target, app) {
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Multi Selection Demo"].tap();
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["Select me"].tap();
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["And me"].tap();
  target.frontMostApp().mainWindow().tableViews()["Empty list"].cells()["And me too"].tap();
  target.frontMostApp().navigationBar().leftButton().tap();
})
