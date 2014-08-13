//
//  ErrorHandler.h
//  weTunes
//
//  Created by AJ Pereira on 8/9/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject
+ (NSString*) parseError:(NSDictionary *)error;
@end
