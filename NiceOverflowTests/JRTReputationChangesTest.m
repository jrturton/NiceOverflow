//
//  JRTReputationChangesTest.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTAsyncTest.h"
#import "JRTReputationChangesService.h"

@interface JRTReputationChangesTest : JRTAsyncTest

@end

@implementation JRTReputationChangesTest

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

- (void)testRepChanges
{
    JRTReputationChangesService *service = [JRTReputationChangesService new];
    service.userID = 852828;
    __block NSError *error = nil;
    __block id responseObject = nil;
    done = NO;
    [service startWithCompletion:^(id response, NSError*serviceError){
        responseObject = response;
        error = serviceError;
        done = YES;
    }];
    [self waitUntilDone];
    
    XCTAssertNotNil(responseObject);
    NSLog(@"%@",responseObject);

}

@end
