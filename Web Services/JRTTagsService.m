//
//  JRTTagsService.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTTagsService.h"

@implementation JRTTagsService

-(NSString *)endpoint
{
    return [NSString stringWithFormat:@"tags/%@/related",self.mainTag];
}

-(NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [super parameters];
    // This filter string makes the call return name only.
    parameters[@"filter"] = @"!nEU0Tsoj.1";
    parameters[@"pagesize"] = @10;
    return parameters;
}

-(id)responseObjectFromServiceResponse:(id)serviceResponse
{
    NSArray *items = serviceResponse[@"items"];
    return [@[self.mainTag] arrayByAddingObjectsFromArray:[items valueForKey:@"name"]];
}

@end
