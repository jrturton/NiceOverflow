#import <XCTest/XCTest.h>

@interface JRTAsyncTest : XCTestCase

{
    BOOL done;
}

-(void)waitUntilDone;

@end