//
//  MultiEditViewController.m
//  TableViewIOS5Demo
//
//  Created by Uppal'z on 19/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiEditViewController.h"

@interface MultiEditViewController (Private)
- (void) deleteButtonPressed;
@end

@implementation MultiEditViewController
@synthesize editableTableView, contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Private Methods
- (void) deleteButtonPressed
{
    NSArray *selectedRows = [[NSArray alloc] initWithArray: [self.editableTableView indexPathsForSelectedRows]];
    
    NSMutableIndexSet *indexSetToDelete = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in selectedRows)
    {
        [indexSetToDelete addIndex:indexPath.row];
    }
    [self.contentArray removeObjectsAtIndexes:indexSetToDelete];
    [self.editableTableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.editableTableView reloadData];
}

#pragma mark - TableView Methods
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

#pragma mark - TableView Edit methods
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.contentArray removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing)
    {
        [self.editableTableView setEditing:YES animated:YES];
        
        //Make a toolbar and add it to the view
        UIToolbar *bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480-44-44-20, 320, 44)];
        bottomToolbar.tag = 1001;
        
        //Add a delete button to the toolbar
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
                                                                                       target:self
                                                                                       action:@selector(deleteButtonPressed)];
        
        [self.view addSubview:bottomToolbar];
        NSArray *items = [NSArray arrayWithObject:barButtonItem];
        [bottomToolbar setItems:items];
    }
    else
    {
        //Remove the toolbar
        for(UIView *view in self.view.subviews)
        {
            if(view.tag == 1001)
                [view removeFromSuperview];
        }
        [self.editableTableView setEditing:NO animated:YES];
    }
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add an edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editableTableView.allowsMultipleSelectionDuringEditing = YES;
    
    contentArray = [[NSMutableArray alloc] init];
    [self.contentArray addObject: @"One"];
    [self.contentArray addObject: @"Two"];
    [self.contentArray addObject: @"Three"];
    [self.contentArray addObject: @"Four"];
    [self.contentArray addObject: @"Five"];
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
