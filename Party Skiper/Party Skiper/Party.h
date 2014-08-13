//
//  Party.h
//  weTunes
//
//  Created by AJ Pereira on 7/26/14.
//  Copyright (c) 2014 AJ Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Party : NSObject

@property (nonatomic, strong) NSString *party_id;
@property (nonatomic, strong) NSString *party_name;
@property (nonatomic, strong) NSDictionary *song_data;
@property (nonatomic, strong) NSString *creation_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *user_count;

@end
