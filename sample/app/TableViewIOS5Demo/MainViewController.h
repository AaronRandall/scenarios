//
//  MainViewController.h
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSupportViewController.h"
#import "ReuseCellWithNibViewController.h"
#import "MultiEditViewController.h"
#import "MultipleSelectionViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView                     *mainTableView;
    NSMutableArray                  *contentArray;
    MenuSupportViewController       *menuSupportViewController;
    ReuseCellWithNibViewController  *reuseCellViewController;
    MultipleSelectionViewController *multipleSelectionViewController;
    MultiEditViewController         *multiEditViewController;
}
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end
