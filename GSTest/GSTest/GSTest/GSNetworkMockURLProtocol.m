//
//  GSNetworkMockURLProtocol.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/20/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import "GSNetworkMockURLProtocol.h"

// Undocumented initializer obtained by class-dump - don't use this in production code destined for the App Store
@interface NSHTTPURLResponse(UndocumentedInitializer)
- (id)initWithURL:(NSURL*)URL statusCode:(NSInteger)statusCode headerFields:(NSDictionary*)headerFields requestTime:(double)requestTime;
@end


@implementation GSNetworkMockURLProtocol

static GSNetworkMockData *GSNetworkMockURLProtocolMockData;

+ (void)executeMockData:(GSNetworkMockData*)mockData withTestBlock:(void(^)(void))block
{
    // Assert that the mockData is valid
    NSAssert(mockData, @"Mock Data should not be nil");
    
    
    // Register the class on the NSURLProtocol
    [NSURLProtocol registerClass:[GSNetworkMockURLProtocol class]];
    
    // Set the mockData settings on the protocol
    [self setMockData:mockData];
    
    // Execute the test block if it exists
    if (block) block();
    
    // Reset the variable settings when finished executing the blocks
    [self resetMockData];
    
    // Unregiste the class on the NSURLProtocol
    [NSURLProtocol unregisterClass:[GSNetworkMockURLProtocol class]];

}

+ (void)setMockData:(GSNetworkMockData *)mockData
{
    GSNetworkMockURLProtocolMockData = mockData;
}

+ (void)resetMockData
{
    GSNetworkMockURLProtocolMockData = nil;
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
    
    if (GSNetworkMockURLProtocolMockData.error) {
        [client URLProtocol:self didFailWithError:GSNetworkMockURLProtocolMockData.error];
    } else {
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                                  statusCode:GSNetworkMockURLProtocolMockData.status
                                                                headerFields:nil
                                                                 requestTime:0.0];
        
        [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        NSData *data = [GSNetworkMockURLProtocolMockData.parameter dataForParameter];
        [client URLProtocol:self didLoadData:data];
        [client URLProtocolDidFinishLoading:self];
        
    }
}

- (void) stopLoading
{
    
}


@end
