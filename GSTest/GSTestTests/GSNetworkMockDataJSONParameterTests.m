//
//  GSNetworkMockDataJSONParameterTests.m
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
#import "GSNetworkMockDataJSONParameter.h"

@interface GSNetworkMockDataJSONParameterTests : XCTestCase
@property (nonatomic, strong) NSDictionary *jsonDictionary;
@property (nonatomic, strong) NSArray * jsonArray;
@end

@implementation GSNetworkMockDataJSONParameterTests

- (void)setUp
{
    [super setUp];
    self.jsonDictionary = @{@"key" : @"value1"};
    self.jsonArray = @[@{@"key" : @"value1"}, @{@"key" : @"value2"}];
}

- (void)tearDown
{
    self.jsonArray = nil;
    self.jsonDictionary = nil;
    [super tearDown];
}

#pragma mark - +[GSNetworkMockDataStringParameter mockDataParameterWithParameter:] tests


- (void)testMockDataParameterWithParameterReturnsAStringParameter
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:self.jsonDictionary];
    XCTAssertTrue([parameter isKindOfClass:[GSNetworkMockDataJSONParameter class]], @"The returned class should be equal to GSNetworkDataStringParameter");
}

- (void)testMockDataParameterWithParameterThrowsExceptionWithString
{
    XCTAssertThrows([GSNetworkMockDataJSONParameter mockDataParameterWithParameter:@"string"], @"mockDataParameterWithParameter should throw a exception when reciving a string");
}

#pragma mark - -[GSNetworkMockDataStringParameter dataForParameter:] tests

- (void)testDataForParameterIsKindOfNSData
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:self.jsonDictionary];
    NSData *data = [parameter dataForParameter];
    XCTAssertTrue([data isKindOfClass:[NSData class]], @"dataForParameter was supposed to return a data");
}

- (void)testDataForParameterIsEqualToJSONDictionaryGivenParameter
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:self.jsonDictionary];
    NSData *data = [parameter dataForParameter];
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertEqualObjects(resultJSON, self.jsonDictionary, @"The result string should be equal to the passed dictionary");
}

- (void)testDataForParameterIsEqualToJSONArrayGivenParameter
{
    GSNetworkMockDataParameter *parameter = [GSNetworkMockDataJSONParameter mockDataParameterWithParameter:self.jsonArray];
    NSData *data = [parameter dataForParameter];
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    XCTAssertEqualObjects(resultJSON, self.jsonArray, @"The result string should be equal to the passed array");
}


@end
