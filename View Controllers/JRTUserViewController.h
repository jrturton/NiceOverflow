//
//  JRTUserViewController.h
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRTUserViewController : UIViewController

@property(nonatomic) NSInteger userReputation;
@property(nonatomic,copy) NSString *userTagScore;
@property(nonatomic,strong) NSURL *userImageURL;
@property(nonatomic) NSInteger userID;

@end
