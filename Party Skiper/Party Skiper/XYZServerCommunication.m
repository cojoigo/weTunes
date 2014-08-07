//
//  XYZServerCommunication.m
//  Party Skiper
//
//  Created by Connor Igo on 7/30/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "User.h"
#import "Party.h"
#import "XYZServerCommunication.h"

@implementation XYZServerCommunication

User *user;
Party *party;
NSArray *users;
NSArray *parties;

- (void)createUser
{
    NSLog(@"Create User start");
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    //setup object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"password": @"user_password",
                                                      @"name": @"user_name",
                                                      @"id": @"user_id"
                                                      }];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/create_user"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //inverse mapping to perform a POST
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"password": @"user_password",
                                                         @"name": @"user_name",
                                                         @"id": @"user_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[User class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{ };
    //queryParams must have proper JSON structure to get a response
    //URL at create_user
    
    [objectManager postObject:nil
                         path:@"/create_user"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Create User Success");
                                    users = mappingResult.array;
                                    user = users[0];
                                    _user_id = user.user_id;
                                    _user_name = user.user_name;
                                    _user_password = user.user_password;
                                    NSLog(@"userid: %@", _user_id);
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSLog(@"Error creating user: %@", error);
                                }];
}

- (void) createParty:(NSString*)name andPassword:(NSString *)pwd
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:_user_id password:_user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"name" : @"party_name",
                                                       @"id": @"party_id"
                                                       }];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:partyMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/create_party"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //inverse mapping to perform a POST
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"update_time": @"update_time",
                                                         @"creation_time": @"creation_time",
                                                         @"song_data": @"song_data",
                                                         @"name" : @"party_name",
                                                         @"id": @"party_id"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];
    NSLog(@"party name: %@",name);
    NSLog(@"party password: %@",pwd);
    NSDictionary *queryParams = @{
                                  @"name" : name,
                                  @"password" : pwd,
                                  @"song_data" : @""
                                  };
    
    //Party *party;
    
    [objectManager postObject:nil
                         path:@"/create_party"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Create Party Success");
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    _party_id = party.party_id;
                                    _party_name = party.party_name;
                                    NSLog(@"PartyID: %@", party.party_id);
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSLog(@"Error creating party: %@", error);
                                }];
}

- (void) joinParty:(NSString*)ID
{
    //initialize RestKit
    User *user = users[0];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"name" : @"party_name",
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"id": @"party_id"
                                                       }];
    
    //We need to append the party name to the end of the join_party url
    NSString *partyPathBase = @"/join_party/";
    
    //IMPORTANT: we need user to input the party name - how in the nine hells do you get user input in Objective-C?
    NSString *partyPathUrl = [partyPathBase stringByAppendingString:ID];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:partyMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:partyPathUrl
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //inverse mapping to perform a POST
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"name" : @"party_name",
                                                         @"update_time": @"update_time",
                                                         @"creation_time": @"creation_time",
                                                         @"song_data": @"song_data",
                                                         @"id": @"party_id"
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    

    
    NSDictionary *queryParams = @{
                                  @"password" : @""
                                  };
    
    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Join Party Success");
                                    parties = mappingResult.array;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSLog(@"Error joining party: %@", error);
                                    //If we get here, implement a check to make sure the error is 'wrong password'
                                    //If so, we need to create a dialog box to prompt the user for the party password and then resend this exact same POST, but with the updated password
                                }];
}

- (void) updateParty
{
    //initialize RestKit
    User *user = users[0];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"name" : @"name",
                                                       @"id": @"party_id"
                                                       }];
    
    //We need to append the party name to the end of the join_party url
    NSString *partyPathBase = @"/update_party";
    
    //IMPORTANT: we need user to input the party name - how in the nine hells do you get user input in Objective-C?
    NSString *partyPathUrl = [partyPathBase stringByAppendingString:@"/test500"];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:partyMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:partyPathUrl
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    //inverse mapping to perform a POST
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"update_time": @"update_time",
                                                         @"creation_time": @"creation_time",
                                                         @"song_data": @"song_data",
                                                         @"name" : @"name",
                                                         @"id": @"party_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{
                                  @"name" : @"test", //test is the party name, must be unique
                                  @"password" : @"",
                                  @"song_data" : @""
                                  };
    
    
    
    //Due to the nature of updateParty, we have to call this function repeatedly.
    //Not sure how to best go about that...
    
    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Update Party Success");
                                    parties = mappingResult.array;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSLog(@"Error updating party: %@", error);
                                }];
}
@end
