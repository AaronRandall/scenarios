//
//  MenuSupportViewController.h
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSupportViewController : UIViewController
{
    UITableView     *menuSupportTableView;
    NSMutableArray  *contentArray;
}
@property (nonatomic, strong) IBOutlet UITableView *menuSupportTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@end
