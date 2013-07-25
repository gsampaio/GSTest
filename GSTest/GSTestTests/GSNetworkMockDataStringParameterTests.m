//
//  GSNetworkMockDataStringParameterTests.m
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
#import "GSNetworkMockDataStringParameter.h"

@interface GSNetworkMockDataStringParameterTests : XCTestCase

@end

@implementation GSNetworkMockDataStringParameterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - +[GSNetworkMockDataStringParameter mockDataParameterWithParameter:] tests

- (void)testMockDataParameterWithParameterReturnsAStringParameter
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataStringParameter mockDataParameterWithParameter:@"test"];
    XCTAssertTrue([parameter isKindOfClass:[GSNetworkMockDataStringParameter class]], @"The returned class should be equal to GSNetworkDataStringParameter");
}

- (void)testMockDataParameterWithParameterDoestSupportNSError
{
    XCTAssertThrows([GSNetworkMockDataStringParameter mockDataParameterWithParameter:[[NSError alloc] init]], @"mockDataParameterWithParameter should not accept anything that is not a NSString");
}

#pragma mark - -[GSNetworkMockDataStringParameter dataForParameter:] tests

- (void)testDataForParameterIsKindOfNSData
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataStringParameter mockDataParameterWithParameter:@"test"];
    NSData *data = [parameter dataForParameter];
    XCTAssertTrue([data isKindOfClass:[NSData class]], @"dataForParameter was supposed to return a data");
}

- (void)testDataForParameterIsEqualToTheGivenParameter
{
    NSString *parameterString = @"test string";
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataStringParameter mockDataParameterWithParameter:parameterString];
    NSData *data = [parameter dataForParameter];
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(parameterString, resultString, @"The result string should be equal to the passed string");
}

@end
