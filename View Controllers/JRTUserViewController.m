//
//  JRTUserViewController.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTUserViewController.h"
#import "JRTReputationChangesService.h"
#import "JRTPostDisplayViewController.h"

@interface JRTUserViewController () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingActivity;
@property (strong, nonatomic) IBOutlet UILabel *repLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagScoreLabel;
@property (strong, nonatomic) IBOutlet UITableView *repTable;

@property(nonatomic,copy) NSArray *reputationChanges;

@end

@implementation JRTUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.repLabel.text = [NSString stringWithFormat:@"Reputation: %d",self.userReputation];
    self.tagScoreLabel.text = self.userTagScore;
    
    // Load the image view
    __weak UIImageView *imageView = self.profileImage;
    __weak UIActivityIndicatorView *indicator = self.imageLoadingActivity;
    [self.imageLoadingActivity startAnimating];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:self.userImageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            [indicator stopAnimating];
        });
    }] resume];
    
    JRTReputationChangesService *changes = [JRTReputationChangesService new];
    changes.userID = self.userID;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [changes startWithCompletion:^(NSArray *response, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.reputationChanges = response;
        [self.repTable reloadData];
    }];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reputationChanges count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Recent reputation changes";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    JRTReputationChangesResponse *repChange = self.reputationChanges[indexPath.row];
    NSString *prefix = repChange.reputationChange > 0 ? @"+" : @"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@%d)",repChange.changeReason,prefix,repChange.reputationChange];
    cell.detailTextLabel.text = [[self dateFormatter] stringFromDate:repChange.date];
    return cell;
}
                           
-(NSDateFormatter*)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    return dateFormatter;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    JRTReputationChangesResponse *response = self.reputationChanges[[self.repTable indexPathForCell:sender].row];
    JRTPostDisplayViewController *destination = segue.destinationViewController;
    destination.postURL = response.postURL;
}


@end
