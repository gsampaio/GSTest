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

#import <XCTest/XCTest.h>
#import "GSNetworkMockURLProtocol.h"
#import "GSNetworkMockData.h"
#import "GSNetworkMockDataStringParameter.h"
#import "GSNetworkMockDataJSONParameter.h"

@interface GSNetworkMockURLProtocolTests : XCTestCase
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSError *error;
@end

@implementation GSNetworkMockURLProtocolTests

- (void)setUp
{
    [super setUp];
    self.URL = [NSURL URLWithString:@"http://apple.com"];
    self.request = [NSURLRequest requestWithURL:self.URL];
    self.error = [NSError errorWithDomain:@"com.gsampaio" code:101 userInfo:nil];
}

- (void)tearDown
{
    self.URL = nil;
    self.request = nil;
    self.error = nil;
    [super tearDown];
}

- (void)testNetworkMockURLProtocolIsKindOfNSURLProtocol
{
    BOOL networkMockURLProtocolIsSubclass = [[GSNetworkMockURLProtocol class] isSubclassOfClass:[NSURLProtocol class]];
    
    XCTAssertTrue(networkMockURLProtocolIsSubclass, @"GSNetworkMockURLProtocol should be subclass of NSURLProtocol");
}

#pragma mark - +[GSNetworkMockURLProtocol executeMockData:withTestBlock:] tests

- (void)testMockDataErrorWhenStatusIs500
{
    GSNetworkMockData *mockData = [[GSNetworkMockData alloc] init];
    mockData.status = 500;
    
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        
        NSError *error;
        [NSData dataWithContentsOfURL:self.URL options:0 error:&error];
        
        XCTAssertNotNil(error, @"The NSError should not be nil since the status is 500");
        
    }];
}

- (void)testMockdataErrorWhenWePassAErrorEvenWeStatusIs200
{
    GSNetworkMockData *mockData = [[GSNetworkMockData alloc] init];
    mockData.status = 200;
    mockData.error = self.error;
    
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        
        NSError *requestError;
        [NSData dataWithContentsOfURL:self.URL options:0 error:&requestError];
        
        XCTAssertNotNil(requestError, @"The request error should be equal to the error inject on the mock data");
    }];
}

- (void)testMockDataShouldReturnPassedDataStringWhenMakingARequest
{
    NSString * expectedString = @"Test string";
    
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    mockData.parameter = [GSNetworkMockDataStringParameter mockDataParameterWithParameter:expectedString];
    
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:self.URL
                                             options:NSDataReadingUncached
                                               error:&error];
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        
        XCTAssertEqualObjects(expectedString, responseString, @"The string passed to the mock data should be equal to the returned string from the [NSData dataWithContentsOfURL:options:error:]");
    
    }];
}

- (void)testMockDataShouldReturnPassedDataJSONDictionary
{
    NSDictionary *jsonData = @{
                               @"key" : @"value"
                               };
    
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    mockData.parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:jsonData];
    
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:self.URL options:NSDataReadingUncached error:&error];
        
        XCTAssertNil(error, @"Error data should be nil since mocked status is 200");
        
        NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        XCTAssertTrue([dataAsJSON isKindOfClass:[NSDictionary class]], @"The JSON data should be a dictionary");
        XCTAssertEqualObjects(jsonData, dataAsJSON, @"The returned JSON should be equals to the mocked one");
    }];
}

- (void)testMockDataShouldReturnPassedDataJSONArray
{
    NSArray *jsonArray = @[@{@"key" : @"value1"}, @{@"key" : @"value2"}];
    
    GSNetworkMockData *mockData = [[GSNetworkMockData alloc] init];
    mockData.parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:jsonArray];
    mockData.status = 200;
    
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:self.URL options:NSDataReadingUncached error:&error];
        
        XCTAssertNil(error, @"Error data should be nil since mocked status is 200");
        
        NSArray *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        XCTAssertTrue([dataAsJSON isKindOfClass:[NSArray class]], @"The JSON data should be an array");
        XCTAssertEqualObjects(jsonArray, dataAsJSON, @"The returned JSON should be equals to the mocked one");
    }];
}

- (void)testExecuteTestWithBlockCallsTheBlockAndExecuteSynchronous
{
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    __block BOOL wasAccessed = NO;
    [GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:^{
        wasAccessed = YES;
    }];
    
    XCTAssertTrue(wasAccessed, @"The block should have been accessed and run synchronous.");
}

- (void)testExecuteTestWithBlockWithANilBlockWorks
{
    GSNetworkMockData *mockData = [GSNetworkMockData status200MockData];
    XCTAssertNoThrow([GSNetworkMockURLProtocol executeMockData:mockData withTestBlock:nil], @"The call of executeTestWithBlock should not throw an exception");
}

#pragma mark - +[GSNetworkMockURLProtocol canInitWithRequest:] tests
- (void)testNetworkMockCanNotInitWithInvalidURLRequest
{
    XCTAssertFalse([GSNetworkMockURLProtocol canInitWithRequest:nil], @"Calling GSNetowrkMockURLProtocol with a nil request should not be able to init ");
}

- (void)testNetworkMockCanInitWithValidURLRequest
{
    XCTAssertTrue([GSNetworkMockURLProtocol canInitWithRequest:self.request], @"Calling GSNetowrkMockURLProtocol with a valid request should be able to init ");

}

#pragma mark - +[GSNetworkMockURLProtocol canonicalRequestForRequest:] tests

- (void)testCanonicalRequestForRequestIsTheSame
{
    NSURLRequest *response = [GSNetworkMockURLProtocol canonicalRequestForRequest:nil];
    XCTAssertNil(response, @"The canonicalRequestForRequest should be nil");
    
    response = [GSNetworkMockURLProtocol canonicalRequestForRequest:self.request];
    XCTAssertEqualObjects(response, self.request, @"The canonicalRequesForRequest should be equal to  self.request");
}


@end
