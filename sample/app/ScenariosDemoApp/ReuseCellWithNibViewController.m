//
//  ReuseCellWithNibViewController.m
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReuseCellWithNibViewController.h"
#import "ReusableCustomCell.h"

@implementation ReuseCellWithNibViewController
@synthesize reuseCellTableView, contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ReusableCustomCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    NSString *theName = [self.contentArray objectAtIndex:indexPath.row];
    [[(ReusableCustomCell *)cell nameLabel] setText:theName];
    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentArray = [[NSMutableArray alloc] initWithObjects:@"Mark", @"Ryan", nil];
    NSString *myIdentifier = @"ReusableCustomCellIdentifier";
    [self.reuseCellTableView registerNib:[UINib nibWithNibName:@"ReusableCustomCell" bundle:nil] 
                  forCellReuseIdentifier:myIdentifier];
}

- (void)viewDidUnload
{
    self.reuseCellTableView = nil;
    self.contentArray = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{    
    [super didReceiveMemoryWarning];
}

@end
