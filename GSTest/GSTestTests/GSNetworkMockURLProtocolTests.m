//
//  GSNetworkMockURLProtocol.m
//  GSTest
//
//  Created by Guilherme Sampaio on 7/20/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GSNetworkMockURLProtocol.h"

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

#pragma mark - +[GSNetworkMockURLProtocol mockData] tests
- (void)testMockDataIsNilShouldThrowException
{
    XCTAssertThrows([GSNetworkMockURLProtocol mockData:nil], @"Calling GSNetworkMockURLProtocol mockData with nil parameter should throws a NSInvalidParameterExeception");
}

- (void)testMockDataNotNilShouldNotThrowException
{
    XCTAssertNoThrow([GSNetworkMockURLProtocol mockData:@{}], @"Calling GSNetworkMockURLProtocol mockData with a valid parameter should not throw a NSInvalidParameterExeception");
}

- (void)testMockDataThrowExceptionIfThereIsResposeDataAndNotResponseType
{
    NSDictionary *mockData = @{GSMockDataResponseDataKey : @""};
    XCTAssertThrows([GSNetworkMockURLProtocol mockData:mockData], @"Calling mockData passing a ResponseData but not passing a ResponseType should throw an exception");
}

- (void)testMockDataThrowsWhenStatusIsNotANumber
{
    NSDictionary *mockData = @{GSMockDataStatusKey: @"TEST"};
    XCTAssertThrows([GSNetworkMockURLProtocol mockData:mockData], @"Calling mockData passing a NSString on the GSMockDataStatusKey should throw a exception");
}

- (void)testMockDataNotThrowsWhenStatusIsANumber
{
    NSDictionary *mockData = @{GSMockDataStatusKey: @(200)};
    XCTAssertNoThrow([GSNetworkMockURLProtocol mockData:mockData], @"Calling mockData passing a NSNumber on the GSMockDataStatusKey should not throw a exception");
}

- (void)testMockDataDefaulStatusIs200
{
    [GSNetworkMockURLProtocol executeTestWithBlock:^{
    
        NSError *error;
        [NSData dataWithContentsOfURL:self.URL options:0 error:&error];
        
        XCTAssertNil(error, @"The NSError should be nil since the default status is 200");
    
    }];
}

- (void)testMockDataErrorWhenStatusIs500
{
    [GSNetworkMockURLProtocol mockData:@{GSMockDataStatusKey: @(500)}];
    
    [GSNetworkMockURLProtocol executeTestWithBlock:^{
        
        NSError *error;
        [NSData dataWithContentsOfURL:self.URL options:0 error:&error];
        
        XCTAssertNotNil(error, @"The NSError should not be nil since the status is 500");
        
    }];
}

- (void)testMockDataThrowsExceptionWhenWePassAErrorThatIsNotKindOfNSError
{
    XCTAssertThrows([GSNetworkMockURLProtocol mockData:@{GSMockDataErrorKey : @"error"}], @"Mock data should throw a exception when the user pass a class that isnt NSError for the error key");
}

- (void)testMockDataDoesNotThrowsExceptionWhenWePassAErrorThatIsKindOfNSError
{
    XCTAssertNoThrow([GSNetworkMockURLProtocol mockData:@{GSMockDataErrorKey : self.error}], @"Mock data should throw a exception when the user pass a class that isnt NSError for the error key");
}

- (void)testMockdataErrorWhenWePassAErrorEvenWeStatusIs200
{
    [GSNetworkMockURLProtocol mockData:@{
                                         GSMockDataStatusKey : @(200),
                                         GSMockDataErrorKey : self.error
                                         }];
    [GSNetworkMockURLProtocol executeTestWithBlock:^{
        NSError *requestError;
        [NSData dataWithContentsOfURL:self.URL options:0 error:&requestError];
        
        XCTAssertNotNil(requestError, @"The request error should be equal to the error inject on the mock data");
    }];
}

- (void)testMockDataShouldReturnPassedDataWhenMakingARequest
{
    NSString * expectedString = @"Test string";
    NSDictionary *mockData = @{
                               GSMockDataResponseDataKey : expectedString,
                               GSMockDataResponseTypeKey : @(GSNetworkMockDataResponseTypeString),
                             };
    [GSNetworkMockURLProtocol mockData:mockData];
    
    [GSNetworkMockURLProtocol executeTestWithBlock:^{
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:self.URL
                                             options:NSDataReadingUncached
                                               error:&error];
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        
        XCTAssertEqualObjects(expectedString, responseString, @"The string passed to the mock data should be equal to the returned string from the [NSData dataWithContentsOfURL:options:error:]");
    
    }];
}

#pragma mark - +[GSNetworkMockURLProtocol executeTestWithBlock:] tests
- (void)testExecuteTestWithBlockCallsTheBlockAndExecuteSynchronous
{
    __block BOOL wasAccessed = NO;
    [GSNetworkMockURLProtocol executeTestWithBlock:^{
        wasAccessed = YES;
    }];
    
    XCTAssertTrue(wasAccessed, @"The block should have been accessed and run synchronous.");
}

- (void)testExecuteTestWithBlockWithANilBlockWorks
{
    XCTAssertNoThrow([GSNetworkMockURLProtocol executeTestWithBlock:nil], @"The call of executeTestWithBlock should not throw an exception");
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
