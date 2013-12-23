//
//  JRTAsyncTest.m
//  NiceOverflow
//
//  Created by Richard Turton on 23/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//



#import "JRTAsyncTest.h"

@implementation JRTAsyncTest

-(void)waitUntilDone
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!done)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];
        date = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
}

@end
