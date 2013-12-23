//
//  JRTTopUsersService.h
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTWebService.h"

@interface JRTTopUsersResponse : NSObject

@property (nonatomic) NSInteger postCount;
@property (nonatomic) NSInteger score;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,strong) NSURL *userProfileURL;
@property (nonatomic,strong) NSURL *userImageURL;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger reputation;

@end

@interface JRTTopUsersService : JRTWebService

@property (nonatomic, copy) NSString *tag;

@end
