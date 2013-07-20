//
//  GSNetworkMockURLProtocol.h
//  GSTest
//
//  Created by Guilherme Sampaio on 7/20/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const * GSMockDataResponseDataKey;
extern NSString const * GSMockDataResponseTypeKey;
extern NSString const * GSMockDataStatusKey;
extern NSString const * GSMockDataErrorKey;
extern NSString const * GSMockDataHeadersKeys;

typedef NS_ENUM(NSUInteger, GSNetworkMockDataResponseType) {
    GSNetworkMockDataResponseTypeString,
    GSNetworkMockDataResponseTypeJSON
};

@interface GSNetworkMockURLProtocol : NSURLProtocol
+ (void)mockData:(NSDictionary*)mockData;
+ (void)executeTestWithBlock:(void(^)(void))block;
@end
