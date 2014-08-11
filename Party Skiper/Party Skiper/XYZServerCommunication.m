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
#import "ErrorHandler.h"
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
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
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
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{ };
    
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
                                    NSString* errorparse;
                                    errorparse = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error creating user: %@", errorparse);
                                }];
}

- (NSString*) createParty:(NSString*)name andPassword:(NSString *)pwd
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
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
    
    NSDictionary *temp_song_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"This is a song title", @"song_title",
                                        nil];
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"name" : name,
                                  @"password" : pwd,
                                  @"song_data" : temp_song_data
                                  };
    _server_rsp = nil;
    [objectManager postObject:nil
                         path:@"/create_party"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Create Party Success");
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    NSLog(@"%@", [party valueForKeyPath:@"_song_data.vote_data"]);
                                    _party_id = party.party_id;
                                    _party_name = party.party_name;
                                    _party_password = pwd;
                                    _server_rsp = @"success";
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    _server_rsp = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error creating party: %@", _server_rsp);
                                    //_server_rsp = @"failure";

                                }];
    while (_server_rsp == nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _server_rsp;
}

- (void) getParties
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"user_count" : @"user_count",
                                                       @"name" : @"party_name",
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"id": @"party_id"
                                                       }];
    
    //register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:partyMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:@"/get_parties"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager getObject:nil
                        path:@"/get_parties"
                  parameters:nil
                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Get Parties Success");
                                    //parties = mappingResult.array;
                                }
                     failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSString* errorparse;
                                    errorparse = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error getting parties: %@", errorparse);
                                }];
}

- (NSString*) joinParty:(NSString*)ID andPassword:(NSString *)pwd
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
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
    
    //IMPORTANT: we need to update the other party methods to have this ID as well!
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
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"password" : pwd
                                  };
    _server_rsp = nil;
    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Join Party Success");
                                    _party_id = party.party_id;
                                    _party_name = party.party_name;
                                    _party_password = pwd;
                                    _server_rsp = @"success";
                                    parties = mappingResult.array;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    _server_rsp = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error joining party: %@", _server_rsp);
                                }];
    while (_server_rsp == nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _server_rsp;
}

- (void) updateParty: (NSMutableString *)song_name
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
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
                                                       @"name" : @"party_name",
                                                       @"id": @"party_id"
                                                       }];
    
    //We need to append the party name to the end of the join_party url
    NSString *partyPathBase = @"/update_party/";
    NSString *partyPathUrl = [partyPathBase stringByAppendingString:_party_id];
    
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
                                                         @"name" : @"party_name",
                                                         @"id": @"party_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *temp_song_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"This is a song title", @"song_title",
                                    nil];
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"name" : @"1test", //test is the party name, must be unique
                                  @"password" : _party_password, //password should be saved from create_party
                                  @"song_data" : temp_song_data
                                  };
    
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
                                    [ErrorHandler parseError:error.userInfo];
                                    //NSLog(@"Error updating party: %@", error);
                                }];
}

- (void) refreshParty
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"user_count" : @"user_count",
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"name" : @"party_name",
                                                       @"id": @"party_id"
                                                       }];
    
    //We need to append the party id to the end of the url
    NSString *partyPathBase = @"/refresh_party/";
    NSString *partyPathUrl = [partyPathBase stringByAppendingString:_party_id];
    
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
                                                         @"user_count" : @"user_count",
                                                         @"update_time": @"update_time",
                                                         @"creation_time": @"creation_time",
                                                         @"song_data": @"song_data",
                                                         @"name" : @"party_name",
                                                         @"id": @"party_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"password" : _party_password
                                  };
    
    //Due to the nature of refreshParty, we have to call this function repeatedly.
    //Not sure how to best go about that...
    

    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Refresh Party Success");
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    _user_count = party.user_count;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    [ErrorHandler parseError:error.userInfo];
                                    //NSLog(@"Error refreshing party: %@", error);
                                }];

}

- (void) vote:(NSNumber*) votedecision withSongName:(NSString*) songname
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://sgoodwin.pythonanywhere.com"]];
    //Make sure all REST requests are json
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    //Send user credentials along with request
    [objectManager.HTTPClient setAuthorizationHeaderWithUsername:user.user_id password:user.user_password];
    
    //setup object mappings
    RKObjectMapping *partyMapping = [RKObjectMapping mappingForClass:[Party class]];
    [partyMapping addAttributeMappingsFromDictionary:@{
                                                       @"user_count" : @"user_count",
                                                       @"update_time": @"update_time",
                                                       @"creation_time": @"creation_time",
                                                       @"song_data": @"song_data",
                                                       @"name" : @"party_name",
                                                       @"id": @"party_id"
                                                       }];
    
    //We need to append the party name to the end of the join_party url
    NSString *partyPathBase = @"/vote/";
    
    //IMPORTANT: we need user to input the party id - NOT THE NAME - to the url.
    //How do we get that?
    NSString *partyPathUrl = [partyPathBase stringByAppendingString:_party_id];
    
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
                                                         @"user_count" : @"user_count",
                                                         @"update_time": @"update_time",
                                                         @"creation_time": @"creation_time",
                                                         @"song_data": @"song_data",
                                                         @"name" : @"party_name",
                                                         @"id": @"party_id"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[Party class]
                                                                                   rootKeyPath:@""
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"song_title" : songname, //song_title requires data from media player
                                  @"vote" : votedecision //vote should be 1 for skip or -1 for don't skip, depending on user input
                                  };
    
    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Vote Success");
                                    parties = mappingResult.array;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    [ErrorHandler parseError:error.userInfo];
                                    //NSLog(@"Error updating party: %@", error);
                                }];
}
@end
