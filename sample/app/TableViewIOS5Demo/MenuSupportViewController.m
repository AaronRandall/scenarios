//
//  MenuSupportViewController.m
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuSupportViewController.h"

@implementation MenuSupportViewController
@synthesize menuSupportTableView, contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"myIdentifier";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if(indexPath.row == 0)
    {
        if (action == @selector(copy:))
        {
            return YES;
        }
    }
    if(indexPath.row == 1)
    {
        if (action == @selector(paste:))
        {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0)
    {
        if(action == @selector(copy:))
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:cell.textLabel.text];
        }
    }
    if(indexPath.row == 1)
    {
        if(action == @selector(paste:))
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [self.contentArray replaceObjectAtIndex:1 withObject:pasteboard.string];
            [self.menuSupportTableView reloadData];
        }
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentArray = [[NSMutableArray alloc] init];
    [self.contentArray addObject: @"Copy Me!"];
    [self.contentArray addObject: @"Replace Me!"];
}

- (void)viewDidUnload
{
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
