//
//  GSNetworkMockDataParameter.h
//  GSTest
//
//  Created by Guilherme Sampaio on 7/21/13.
//  Copyright (c) 2013 Guilherme Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSNetworkMockDataParameter : NSObject
@property (nonatomic, strong) id parameter;
+ (instancetype) mockDataParameterWithParameter:(id)parameter;
- (NSData*)dataForParameter;
@end
