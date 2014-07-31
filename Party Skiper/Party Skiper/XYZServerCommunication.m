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

UILabel* userID;
NSArray *users;
NSArray *parties;

- (void)loadUser
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    //setup object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"user_password": @"user_password",
                                                      @"user_name": @"user_name",
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
                                                         @"user_password": @"user_password",
                                                         @"user_name": @"user_name",
                                                         @"id": @"user_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[User class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{ };
    //queryParams must have proper JSON structure to get a response
    //URL at create_user
    
    [objectManager postObject:nil
                         path:@"/create_user"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"Success");
         users = mappingResult.array;
         UILabel* userID;
         userID.text = users[0];
         [self createParty];
     }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error creating user: %@", error);
     }];
}

- (void) createParty
{
    //initialize RestKit
    User *user = users[0];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
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
                                                         @"id": @"party_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{
                                  @"party_name" : @"",
                                  @"party_password" : @"",
                                  @"song_data" : @""
                                  };
    //queryParams must have proper JSON structure to get a response
    
    [objectManager postObject:nil
                         path:@"/create_party"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"Success");
         parties = mappingResult.array;
     }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error creating user: %@", error);
     }];
    
}
@end
