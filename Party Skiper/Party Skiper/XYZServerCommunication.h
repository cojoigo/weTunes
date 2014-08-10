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
- (NSString*)createParty:(NSString*)name andPassword:(NSString *)pwd;
- (NSString*)joinParty:(NSString*)ID andPassword:(NSString *)pwd;
- (void)updateParty;
- (void)refreshParty;
- (void)vote:(NSNumber*) votedecision;

@property (nonatomic, strong) NSString *server_rsp;
//User variables
@property (nonatomic, strong) NSString *user_password;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
//Party variables
@property (nonatomic, strong) NSString *party_id;
@property (nonatomic, strong) NSString *party_name;
@property (nonatomic, strong) NSDictionary *song_data;
@property (nonatomic, strong) NSString *creation_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *user_count;
@end
