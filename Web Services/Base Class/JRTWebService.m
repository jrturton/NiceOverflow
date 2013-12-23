//
//  JRTWebService.m
//  NiceOverflow
//
//  Created by Richard Turton on 20/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import "JRTWebService.h"
#import "NSJSONSerialization+RemovingNulls.h"

NSString *const baseURL = @"http://api.stackexchange.com/2.1/";
NSString *const networkErrorDomain = @"uk.co.commandshift.networkError";
NSString *const serviceErrorDomain = @"uk.co.commandshift.serviceError";

@implementation JRTWebService

#pragma mark - Shared session
-(NSURLSession*)session
{
    // This session object is shared for all services.
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPAdditionalHeaders:@{@"Accept":@"application/json"}];
        configuration.HTTPMaximumConnectionsPerHost = 1;
        session = [NSURLSession sessionWithConfiguration:configuration];
    });
    return session;
}

#pragma mark - Creating URLs

-(NSURL*)requestURL
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",baseURL,[self endpoint],[self queryString]];
    return [NSURL URLWithString:urlString];
}

-(NSString *)queryString
{
    // This is a very naive implementation compared to something like AFNetworking, but for this example project I wanted to have no dependencies.
    NSMutableArray *pairedParameters = [NSMutableArray new];
    [self.parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [pairedParameters addObject:[NSString stringWithFormat:@"%@=%@",key,[[value description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }];
    
    if ([pairedParameters count])
    {
        NSString *queryString = [@"?" stringByAppendingString:[pairedParameters componentsJoinedByString:@"&"]];
        return queryString;
    }
    else
    {
        return @"";
    }
}

#pragma mark - Networking

- (void)startWithCompletion:(JRTWebServiceCompletionBlock)completionBlock
{
    if (!completionBlock)
    {
        completionBlock = ^(id response, NSError *error)
        {
            
        };
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self requestURL]];
    [self configureRequest:request];
    
    NSURLSessionDataTask *task = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            NSError *returnError = [self errorFromNetworkError:error];
            dispatch_async(dispatch_get_main_queue(), ^{completionBlock(nil,returnError);});
            return;
        }
        
        NSError *jsonError = nil;
        id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&jsonError removingNulls:YES ignoreArrays:NO];
        if (jsonError)
        {
            NSError *returnError = [self errorFromNetworkError:error];
            dispatch_async(dispatch_get_main_queue(), ^{completionBlock(nil,returnError);});
            return;
        }
        
        NSError *serviceLevelError = [self serviceLevelErrorFromServiceResponse:responseJSON];
        if (serviceLevelError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{completionBlock(nil,serviceLevelError);});
            return;
        }
        
        id processedResponse = [self responseObjectFromServiceResponse:responseJSON];
        dispatch_async(dispatch_get_main_queue(), ^{completionBlock(processedResponse,nil);});
    }];
    
    [task resume];
}

-(NSError *)errorFromNetworkError:(NSError *)error
{
    NSString *description = NSLocalizedString(@"Could not connect to service. Please check your network settings.", @"");
    return [NSError errorWithDomain:networkErrorDomain code:error.code userInfo:@{NSLocalizedDescriptionKey:description}];
}

- (NSMutableDictionary *)parameters
{
    // Any common parameters to all services to be implemented here. Subclasses call super and add their own.
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"site"] = @"stackoverflow";
    return parameters;
}

- (NSString *)endpoint
{
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}

- (id)responseObjectFromServiceResponse:(id)serviceResponse
{
    NSAssert(NO, @"Subclasses must implement this method");
    return nil;
}

-(NSError*)serviceLevelErrorFromServiceResponse:(id)serviceResponse
{
    // If the API served up any sort of errors in the response, detect and return them here
    return nil;
}

-(void)configureRequest:(NSMutableURLRequest *)request
{
    // Subclasses to implement if required
}

#pragma mark - Dates

-(NSDate*)dateFromResponseItem:(id)responseItem
{
    NSTimeInterval interval = [responseItem doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

-(id)responseItemFromDate:(NSDate*)date
{
    return @([date timeIntervalSince1970]);
}

@end
