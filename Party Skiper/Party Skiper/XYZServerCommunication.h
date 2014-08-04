//
//  XYZServerCommunication.h
//  Party Skiper
//
//  Created by Connor Igo on 7/30/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZServerCommunication : NSObject

- (void)loadUser;
- (void)createParty;

//save copies of these strings locally for easier access
//user strings
@property (nonatomic, strong) NSString *user_password;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
//party strings
@property (nonatomic, strong) NSString *party_id;
@property (nonatomic, strong) NSString *song_data;
@property (nonatomic, strong) NSString *creation_time;
@property (nonatomic, strong) NSString *update_time;
@end
