#import "assertions.js"
#import "lang-ext.js"

extend(UIATableView.prototype, {
  /**
   * A shortcut for:
   *  this.cells().firstWithName(name)
   */
  cellNamed: function(name) {
    return this.cells().firstWithName(name);
  },

  /**
   * Asserts that this table has a cell with the name (accessibility label)
   * matching the given +name+ argument.
   */
  assertCellNamed: function(name) {
    assertNotNull(this.cellNamed(name), "No table cell found named '" + name + "'");
  }
});

extend(UIAElement.prototype, {
	/**
	 * Poll till the item becomes visible, up to a specified timeout
	 */
	waitUntilVisible: function (timeoutInSeconds) {
        this.waitUntil(function(element) {
            return element;
        }, function(element) {
            return element.isVisible();
        }, timeoutInSeconds, "to become visible");
	},

	/**
	 * Wait until element becomes invisible
	 */
	waitUntilInvisible: function (timeoutInSeconds) {
        this.waitUntil(function(element) {
            return element;
        }, function(element) {
            return !element.isVisible();
        }, timeoutInSeconds, "to become invisible");
    },
    
    /**
     * Wait until child element with name is added
     */
    waitUntilFoundByName: function (name, timeoutInSeconds) {
        this.waitUntil(function(element) {
            return element.elements().firstWithName(name);
        }, function(element) {
            return element.isValid();
        }, timeoutInSeconds, "to become valid");
    },
    
    /**
     * Wait until child element with name is removed
     */
    waitUntilNotFoundByName: function (name, timeoutInSeconds) {
        this.waitUntil(function(element) {
            return element.elements().firstWithName(name);
        }, function(element) {
            return !element.isValid();
        }, timeoutInSeconds, "to become invalid");
    },
    
    /**
     * Wait until element fulfills condition
     */
    waitUntil: function (filterFunction, conditionFunction, timeoutInSeconds, description) {
        timeoutInSeconds = timeoutInSeconds == null ? 5 : timeoutInSeconds;
        var element = this;
        var delay = 0.25;
        retry(function() {
            var filteredElement = filterFunction(element);
            if(!conditionFunction(filteredElement)) {
                throw(["Element", filteredElement, "failed", description, "within", timeoutInSeconds, "seconds."].join(" "));
            }
        }, Math.max(1, timeoutInSeconds/delay), delay);
    },
	
  /**
   * A shortcut for waiting an element to become visible and tap.
   */
  vtap: function() {
    this.waitUntilVisible(10);
    this.tap();
  },
  /**
   * A shortcut for touching an element and waiting for it to disappear.
   */
  tapAndWaitForInvalid: function() {
    this.tap();
    this.waitForInvalid();
  }
});

extend(UIAApplication.prototype, {
  /**
   * A shortcut for getting the current view controller's title from the
   * navigation bar. If there is no navigation bar, this method returns null
   */
  navigationTitle: function() {
    navBar = this.mainWindow().navigationBar();
    if (navBar) {
      return navBar.name();
    }
    return null;
  },

  /**
   * A shortcut for checking that the interface orientation in either
   * portrait mode
   */
  isPortraitOrientation: function() {
    var orientation = this.interfaceOrientation();
    return orientation == UIA_DEVICE_ORIENTATION_PORTRAIT ||
      orientation == UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN;
  },

  /**
   * A shortcut for checking that the interface orientation in one of the
   * landscape orientations.
   */
  isLandscapeOrientation: function() {
    var orientation = this.interfaceOrientation();
    return orientation == UIA_DEVICE_ORIENTATION_LANDSCAPELEFT ||
      orientation == UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT;
  }
});

extend(UIANavigationBar.prototype, {
  /**
   * Asserts that the left button's name matches the given +name+ argument
   */
  assertLeftButtonNamed: function(name) {
    assertEquals(name, this.leftButton().name());
  },
  
  /**
   * Asserts that the right button's name matches the given +name+ argument
   */
  assertRightButtonNamed: function(name) {
    assertEquals(name, this.rightButton().name());
  }
});

extend(UIATarget.prototype, {
  /**
   * A shortcut for checking that the interface orientation in either
   * portrait mode
   */
  isPortraitOrientation: function() {
    var orientation = this.deviceOrientation();
    return orientation == UIA_DEVICE_ORIENTATION_PORTRAIT ||
      orientation == UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN;
   },

  /**
   * A shortcut for checking that the interface orientation in one of the
   * landscape orientations.
   */
  isLandscapeOrientation: function() {
    var orientation = this.deviceOrientation();
    return orientation == UIA_DEVICE_ORIENTATION_LANDSCAPELEFT ||
      orientation == UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT;
   },

   /**
    * A convenience method for detecting that you're running on an iPad
    */
    isDeviceiPad: function() {
      //model is iPhone Simulator, even when running in iPad mode
      return this.model().match(/^iPad/) !== null ||
        this.name().match(/iPad Simulator/) !== null;
    },

    /**
     * A convenience method for detecting that you're running on an
     * iPhone or iPod touch
     */
    isDeviceiPhone: function() {
      return this.model().match(/^iPad/) === null &&
        this.name().match(/^iPad Simulator$/) === null;
    }
});
extend(UIAKeyboard.prototype,{
  KEYBOARD_TYPE_UNKNOWN :-1,
  KEYBOARD_TYPE_ALPHA : 0,
  KEYBOARD_TYPE_ALPHA_CAPS : 1,
  KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION:2,
  KEYBOARD_TYPE_NUMBER:3,
  keyboardType : function() {
  if (this.keys().length < 12){
    return this.KEYBOARD_TYPE_NUMBER;
  } else if (this.keys().firstWithName("a").toString() != "[object UIAElementNil]") {
    return this.KEYBOARD_TYPE_ALPHA;
  } else if (this.keys().firstWithName("A").toString() != "[object UIAElementNil]") {
    return this.KEYBOARD_TYPE_ALPHA_CAPS;
  } else if (this.keys().firstWithName("1").toString() != "[object UIAElementNil]") {
    return this.KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION;
  } else {
    return this.KEYBOARD_TYPE_UNKNOWN;
  }
  }
});

/*
TODO: Character keyboard is super slow.
*/
var typeString = function(pstrString, pbClear) {
  pstrString += ''; // convert number to string
  if (!this.hasKeyboardFocus()){
    this.tap();
  }

  UIATarget.localTarget().delay(0.5);

  if (pbClear || pstrString.length === 0) {
    this.clear();
  }

  if (pstrString.length > 0) {
    var app = UIATarget.localTarget().frontMostApp();
    var keyboard = app.keyboard();
    var keys = app.keyboard().keys();
    var buttons = app.keyboard().buttons();
    for (i = 0; i < pstrString.length; i++) {
      var intKeyboardType = keyboard.keyboardType();
      var bIsAllCaps = (intKeyboardType == keyboard.KEYBOARD_TYPE_ALPHA_CAPS); //Handles autocapitalizationType = UITextAutocapitalizationTypeAllCharacters
      var intNewKeyboardType = intKeyboardType;
      var strChar = pstrString.charAt(i);
      if ((/[a-z]/.test(strChar)) && intKeyboardType == keyboard.KEYBOARD_TYPE_ALPHA_CAPS && !bIsAllCaps) {
        buttons.firstWithName("shift").tap();
        intKeyboardType = keyboard.KEYBOARD_TYPE_ALPHA;
      } else if ((/[A-Z]/.test(strChar)) && intKeyboardType == keyboard.KEYBOARD_TYPE_ALPHA) {
        buttons.firstWithName("shift").tap();
        intKeyboardType = keyboard.KEYBOARD_TYPE_ALPHA_CAPS;
      } else if ((/[A-z]/.test(strChar)) && intKeyboardType == keyboard.KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION) {
        buttons.firstWithName("more, letters").tap();
        intKeyboardType = keyboard.KEYBOARD_TYPE_ALPHA;
      } else if ((/[0-9.]/.test(strChar)) && intKeyboardType != keyboard.KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION && intKeyboardType != keyboard.KEYBOARD_TYPE_NUMBER) {
        buttons.firstWithName("more, numbers").tap();
        intKeyboardType = keyboard.KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION;
      }

      if ((/[a-z]/.test(strChar)) && intKeyboardType == keyboard.KEYBOARD_TYPE_ALPHA_CAPS) {
        strChar = strChar.toUpperCase();
      }
      if (strChar == " ") {
        keys["space"].tap();
      } else if (/[0-9]/.test(strChar)) { // Need to change strChar to the index key of the number because strChar = "0" will tap "1" and strChar = "1" will tap "2"
        if (strChar == "0") {
          if (intKeyboardType == keyboard.KEYBOARD_TYPE_NUMBER_AND_PUNCTUATION) {
            strChar = "9";
          } else {
            strChar = "10";
          }
        } else {
          strChar = (parseInt(strChar, 10) - 1).toString();
        }
        keys[strChar].tap();
      } else {
        keys[strChar].tap(); // TODO: this line is super slow when there are many keys
      }
      UIATarget.localTarget().delay(0.5);
    }
  }
};

extend(UIATextField.prototype,{
  typeString: typeString
});
extend(UIATextView.prototype,{
  typeString: typeString
});
