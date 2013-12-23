//
//  JRTReputationChangesService.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTReputationChangesService.h"

@implementation JRTReputationChangesResponse

-(NSString*)description
{
    return [NSString stringWithFormat:@"%d %@ %@",self.reputationChange,self.date,self.changeReason];
}

@end

@implementation JRTReputationChangesService

-(NSString *)endpoint
{
    return [NSString stringWithFormat:@"users/%d/reputation-history",self.userID];
}

-(NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [super parameters];
    
    if (!self.pageSize)
    {
        self.pageSize = 20;
    }
    
    parameters[@"pagesize"] = @(self.pageSize);
    return parameters;
}

-(NSArray*)responseObjectFromServiceResponse:(id)serviceResponse
{
    NSMutableArray *returnArray = [NSMutableArray array];
    for (NSDictionary *repChangeDictionary in serviceResponse[@"items"])
    {
        JRTReputationChangesResponse *change = [JRTReputationChangesResponse new];
        change.reputationChange = [repChangeDictionary[@"reputation_change"] integerValue];
        change.changeReason = [self formattedChangeReasonFromResponseString:repChangeDictionary[@"reputation_history_type"]];
        change.date = [self dateFromResponseItem:repChangeDictionary[@"creation_date"]];
        change.postURL = [self postURLForPostID:[repChangeDictionary[@"post_id"] integerValue]];
        [returnArray addObject:change];
    }
    return returnArray;
}


-(NSString*)formattedChangeReasonFromResponseString:(NSString*)responseString
{
    NSMutableString *reason = [responseString mutableCopy];
    [reason replaceOccurrencesOfString:@"_" withString:@" " options:0 range:NSMakeRange(0, [reason length])];
    if ([reason length])
    {
        [reason replaceCharactersInRange:NSMakeRange(0, 1) withString:[[reason substringToIndex:1] uppercaseString]];
    }
    return reason;
}

-(NSURL*)postURLForPostID:(NSInteger)postID
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://stackoverflow.com/q/%d",postID]];
}


@end
