//
//  GSNetworkMockURLProtocol.m
//  GSTest
//
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

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
