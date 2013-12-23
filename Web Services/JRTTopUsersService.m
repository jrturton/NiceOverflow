//
//  JRTTopUsersService.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTTopUsersService.h"

@implementation JRTTopUsersResponse

-(NSString*)description
{
    return [NSString stringWithFormat:@"%@ %d",self.userName,self.reputation];
}

@end

@implementation JRTTopUsersService

-(NSString*)endpoint
{
    return [NSString stringWithFormat:@"tags/%@/top-answerers/all_time",self.tag];
}

-(NSArray*)responseObjectFromServiceResponse:(id)serviceResponse
{
    NSMutableArray *returnArray = [NSMutableArray array];
    NSArray *topUsers = serviceResponse[@"items"];
    
    [topUsers enumerateObjectsUsingBlock:^(NSDictionary *userDictionary, NSUInteger idx, BOOL *stop) {
        JRTTopUsersResponse *user = [JRTTopUsersResponse new];
        user.postCount = [userDictionary[@"post_count"] integerValue];
        user.score = [userDictionary[@"score"] integerValue];
        NSDictionary *userObjectDictionary = userDictionary[@"user"];
        user.userName = userObjectDictionary[@"display_name"];
        user.userProfileURL = [NSURL URLWithString:userObjectDictionary[@"link"]];
        user.userImageURL = [NSURL URLWithString:userObjectDictionary[@"profile_image"]];
        user.userID = [userObjectDictionary[@"user_id"] integerValue];
        user.reputation = [userObjectDictionary[@"reputation"] integerValue];
        [returnArray addObject:user];
    }];
    
    return returnArray;
}

@end
