//
//  JRTReputationChangesService.h
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTWebService.h"

@interface JRTReputationChangesResponse : NSObject

@property (nonatomic,strong) NSDate *date;
@property (nonatomic) NSInteger reputationChange;
@property (nonatomic,copy) NSString *changeReason;
@property (nonatomic) NSURL *postURL;

@end

@interface JRTReputationChangesService : JRTWebService

@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger pageSize;

@end
