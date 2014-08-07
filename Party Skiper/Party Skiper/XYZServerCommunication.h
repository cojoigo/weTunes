//
//  XYZServerCommunication.h
//  Party Skiper
//
//  Created by Connor Igo on 7/30/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZServerCommunication : NSObject
- (void)createUser;
- (void)createParty:(NSString*)name andPassword:(NSString *)pwd;
- (void)joinParty:(NSString*)ID;
- (void)updateParty;
@property bool CP;
//User variables
@property (nonatomic, strong) NSString *user_password;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
//Party variables
@property (nonatomic, strong) NSString *party_id;
@property (nonatomic, strong) NSString *party_name;
@property (nonatomic, strong) NSString *song_data;
@property (nonatomic, strong) NSString *creation_time;
@property (nonatomic, strong) NSString *update_time;
@end
