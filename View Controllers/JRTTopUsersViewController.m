//
//  JRTTopUsersViewController.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTTopUsersViewController.h"
#import "JRTTopUsersService.h"
#import "JRTUserViewController.h"

@interface JRTTopUsersViewController ()

@property (nonatomic,copy) NSArray *topUsers;

@end

@implementation JRTTopUsersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.tagID;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    JRTTopUsersService *service = [JRTTopUsersService new];
    service.tag = self.tagID;
    [service startWithCompletion:^(NSArray *response, NSError *error) {
        self.topUsers = response;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRTTopUsersResponse *user = self.topUsers[indexPath.row];
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",user.reputation];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    JRTTopUsersResponse *user = [self.topUsers objectAtIndex:[self.tableView indexPathForCell:sender].row];
    JRTUserViewController *destination = segue.destinationViewController;
    destination.title = user.userName;
    destination.userReputation = user.reputation;
    destination.userTagScore = [NSString stringWithFormat:@"%d for %d %@ questions",user.score,user.postCount,self.tagID];
    destination.userID = user.userID;
    destination.userImageURL = user.userImageURL;
}

@end
