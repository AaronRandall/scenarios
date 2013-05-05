//
//  AppDelegate.h
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController      *mainViewController;
    UINavigationController *navigationController;
}
@property (strong, nonatomic) UIWindow *window;

@end
