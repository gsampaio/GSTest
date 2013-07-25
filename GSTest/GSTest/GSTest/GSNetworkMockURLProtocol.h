//
//  GSNetworkMockURLProtocol.h
//  GSTest
//
//  Created by Guilherme Sampaio on 7/20/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSNetworkMockData.h"

@interface GSNetworkMockURLProtocol : NSURLProtocol
+ (void)executeMockData:(GSNetworkMockData*)mockData withTestBlock:(void(^)(void))block;
@end
