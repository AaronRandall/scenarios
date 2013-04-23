//
//  MultipleSelectionViewController.h
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultipleSelectionViewController : UIViewController
{
    UITableView     *multipleSelectionTableView;
    NSMutableArray         *contentArray;
}

@property (nonatomic, strong) IBOutlet UITableView *multipleSelectionTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end
