//
//  GSNetworkMockURLProtocol.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/20/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import "GSNetworkMockURLProtocol.h"

NSString const * GSMockDataResponseDataKey = @"GSMockDataResponseData";
NSString const * GSMockDataResponseTypeKey = @"GSMockDataResponseType";
NSString const * GSMockDataStatusKey = @"GSMockDataStatus";
NSString const * GSMockDataErrorKey = @"GSMockDataError";
NSString const * GSMockDataHeadersKey = @"GSMockDataHeaders";

// Undocumented initializer obtained by class-dump - don't use this in production code destined for the App Store
@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end


@implementation GSNetworkMockURLProtocol

static NSData *GSNetworkMockURLProtocolResponse;
static NSUInteger GSNetworkMockURLProtocolStatusCode = 200;
static NSError * GSNetworkMockURLProtocolError;

+ (NSData*) responseDataWithObject:(id)object forResponseType:(GSNetworkMockDataResponseType)type
{
    switch (type) {
        case GSNetworkMockDataResponseTypeString:
        {
            GSNetworkMockURLProtocolResponse = [object dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        default:
            GSNetworkMockURLProtocolResponse = nil;
            break;
    }
    
    return GSNetworkMockURLProtocolResponse;
}

+ (void)setNetworkStatusCode:(NSNumber *)networkStatus
{
    GSNetworkMockURLProtocolStatusCode = [networkStatus unsignedIntegerValue];
}

+ (void)setError:(NSError*)error
{
    GSNetworkMockURLProtocolError = error;
}

+ (void)mockData:(NSDictionary*)mockData
{
    // Assert that we have a mockData dictionary
    NSParameterAssert(mockData);
    
    // Asserts that if we have a responseData we have a responseType
    NSAssert(!mockData[GSMockDataResponseDataKey] || (mockData[GSMockDataResponseDataKey] && mockData[GSMockDataResponseTypeKey]), @"If you pass a ResponseData you need to pass a Response Type");

    // Parse the response data
    if (mockData[GSMockDataResponseDataKey]) {
        [GSNetworkMockURLProtocol responseDataWithObject:mockData[GSMockDataResponseDataKey] forResponseType:[mockData[GSMockDataResponseTypeKey] unsignedIntegerValue]];
    }
    
    // Parse the response data
    if (mockData[GSMockDataStatusKey]) {
        NSAssert([mockData[GSMockDataStatusKey] isKindOfClass:[NSNumber class]], @"The status code must be kind of NSNumber class");
        [self setNetworkStatusCode:mockData[GSMockDataStatusKey]];
    }
    
    // Parse the error data
    if (mockData[GSMockDataErrorKey]) {
        NSAssert([mockData[GSMockDataErrorKey] isKindOfClass:[NSError class]], @"The error must be kind of NSError");
        [self setError:mockData[GSMockDataErrorKey]];
    }
}

+ (void)executeTestWithBlock:(void(^)(void))block
{
    // Register the class on the NSURLProtocol
    [NSURLProtocol registerClass:[GSNetworkMockURLProtocol class]];
    
    // Execute the test block if it exists
    if (block) block();
    
    // Reset the variable settings when finished executing the blocks
    [self resetMockData];
    
    // Unregiste the class on the NSURLProtocol
    [NSURLProtocol unregisterClass:[GSNetworkMockURLProtocol class]];
    
}

+ (void)resetMockData
{
    GSNetworkMockURLProtocolError = nil;
    GSNetworkMockURLProtocolResponse = nil;
    GSNetworkMockURLProtocolStatusCode = 200;
}

#pragma mark - NSURLProtocol methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return request != nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading {
    NSURLRequest *request = [self request];
    id<NSURLProtocolClient> client = [self client];
    
    if (GSNetworkMockURLProtocolError) {
        [client URLProtocol:self didFailWithError:GSNetworkMockURLProtocolError];
    } else {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                                  statusCode:GSNetworkMockURLProtocolStatusCode
                                                                headerFields:nil
                                                                 requestTime:0.0];
        
        [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:self didLoadData:GSNetworkMockURLProtocolResponse];
        [client URLProtocolDidFinishLoading:self];
        
    }
}

- (void) stopLoading
{
    
}


@end
