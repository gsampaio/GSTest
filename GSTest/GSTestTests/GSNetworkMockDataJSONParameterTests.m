//
//  GSNetworkMockDataJSONParameterTests.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/25/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

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
