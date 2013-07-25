//
//  GSNetworkMockDataStringParameterTests.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/25/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

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
