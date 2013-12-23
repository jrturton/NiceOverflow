//
//  JRTTagsViewController.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTTagsViewController.h"
#import "JRTTagsService.h"
#import "JRTTopUsersViewController.h"

@interface JRTTagsViewController ()

@property (nonatomic,copy) NSArray* tags;
@end

@implementation JRTTagsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JRTTagsService *service = [JRTTagsService new];
    service.mainTag = @"ios";
    [service startWithCompletion:^(NSArray *response, NSError *error) {
        self.tags = response;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.tags[indexPath.row];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    JRTTopUsersViewController *destination = segue.destinationViewController;
    destination.tagID = self.tags[[self.tableView indexPathForCell:sender].row];
}

@end
