//
//  JRTWebService.h
//  NiceOverflow
//
//  Created by Richard Turton on 20/12/2013.
//  Copyright (c) 2013 CommandShift. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JRTWebServiceCompletionBlock)(id response, NSError *error);

@interface JRTWebService : NSObject

/// Date transformations (could be a date formatter, for this API, UNIX epoch dates are returned and used)
-(NSDate*)dateFromResponseItem:(id)responseItem;
-(id)responseItemFromDate:(NSDate*)date;

/// Starts the service
-(void)startWithCompletion:(JRTWebServiceCompletionBlock)completionBlock;

/// Configure the request before it is called
-(void)configureRequest:(NSMutableURLRequest*)request;

/// Returns a dictionary containing the parameters used for the web service. Subclasses should override this method to add additional parameters to the default ones
-(NSMutableDictionary*)parameters;

/// Returns the API endpoint of the specific service. Subclasses override this to provide the specific endpoint.
-(NSString*)endpoint;

/// Creates a response object with named parameters which is returned in the completion block instead of a dictionary
-(id)responseObjectFromServiceResponse:(id)serviceResponse;

/// Creates an error object from a valid JSON response, if applicable.
- (NSError *)serviceLevelErrorFromServiceResponse:(id)serviceResponse;
@end