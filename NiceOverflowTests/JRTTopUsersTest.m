//
//  JRTTopUsersTest.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTAsyncTest.h"
#import "JRTTopUsersService.h"

@interface JRTTopUsersTest : JRTAsyncTest

@end

@implementation JRTTopUsersTest

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

- (void)testiOS
{
    JRTTopUsersService *service = [JRTTopUsersService new];
    service.tag = @"ios";
    done = NO;
    __block id serviceResponse = nil;
    __block id serviceError = nil;
    [service startWithCompletion:^(JRTTopUsersResponse *response, NSError*error){
        done = YES;
        serviceResponse = response;
        serviceError = error;
    }];
    [self waitUntilDone];
    XCTAssertNotNil(serviceResponse);
}

- (void)testNonsenseTag
{
    JRTTopUsersService *service = [JRTTopUsersService new];
    service.tag = @"eroighdsflghdfl";
    done = NO;
    __block id serviceResponse = nil;
    __block id serviceError = nil;
    [service startWithCompletion:^(JRTTopUsersResponse *response, NSError*error){
        done = YES;
        serviceResponse = response;
        serviceError = error;
    }];
    [self waitUntilDone];
    XCTAssertNotNil(serviceResponse);
}
@end
