//
//  MultiEditViewController.h
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiEditViewController : UIViewController
{
    UITableView     *editableTableView;
    NSMutableArray  *contentArray;
}

@property (nonatomic, strong) IBOutlet UITableView *editableTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end