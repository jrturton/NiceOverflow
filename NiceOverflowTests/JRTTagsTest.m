//
//  JRTTagsTest.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTAsyncTest.h"
#import "JRTTagsService.h"

@interface JRTTagsTest : JRTAsyncTest

@end

@implementation JRTTagsTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testTags
{
    JRTTagsService *service = [JRTTagsService new];
    service.mainTag = @"ios";
    done = NO;
    __block id serviceResponse = nil;
    __block NSError *serviceError = nil;
    
    [service startWithCompletion:^(id response, NSError *error) {
        serviceResponse = response;
        serviceError = error;
        done = YES;
    }];
    
    [self waitUntilDone];
    XCTAssertNotNil(serviceResponse);
}

@end
