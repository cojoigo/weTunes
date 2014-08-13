//
//  XYZServerCommunication.m
//  weTunes
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

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* method:       createUser
* parameters:   none
* return value: none
* description:  sends a POST request to fill in the User class with id, name, and password
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
- (void)createUser
{
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

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       createParty
 * parameters:   party name, party password(optional), song name(optional)
 * return value: server response flag
 * description:  sends a POST request to fill in the Party class with the above information
 *                  the song name parameter can be filled to initialize the class with a song
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
- (NSString*) createParty:(NSString*)name andPassword:(NSString *)pwd andSongName:(NSString*)song_name
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
    
    NSDictionary *temp_song_data = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                            song_name, @"song_title",
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
                                    _party_id = party.party_id;
                                    _party_name = party.party_name;
                                    _party_password = pwd;
                                    _skipvotes = @"0";
                                    _dontskipvotes = @"0";
                                    _server_rsp = @"success";
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    _server_rsp = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error creating party: %@", _server_rsp);
                                }];
    while (_server_rsp == nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _server_rsp;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       getParties
 * parameters:   none
 * return value: none
 * description:  sends a GET request to display a list of all parties on the server
 * 
 * NOTE: Unfinished and not integrated with the rest of the code. Kept here for future development
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
                                }
                     failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    NSString* errorparse;
                                    errorparse = [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error getting parties: %@", errorparse);
                                }];
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       joinParty
 * parameters:   party ID, party password
 * return value: server response flag
 * description:  sends a POST request to fill in the Party class to join the selected party
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    _party_id = party.party_id;
                                    _party_name = party.party_name;
                                    _party_password = pwd;
                                    _server_rsp = @"success";
                                    _song_data = party.song_data;
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

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       updateParty
 * parameters:   song name
 * return value: none
 * description:  sends a POST request to update information on the server regarding a specific
 *                  party - only the host may ever call this method
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
                                    song_name, @"song_title",
                                    nil];
    
    NSLog (@"UPDATE PARTY song name: %@", song_name);
    
    //queryParams is the message sent to the server as part of the POST
    NSDictionary *queryParams = @{
                                  @"name" : _party_name, //test is the party name, must be unique
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
                                    party = parties[0];
                                    _song_data = party.song_data;
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    [ErrorHandler parseError:error.userInfo];
                                    //NSLog(@"Error updating party: %@", error);
                                }];
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       refreshParty
 * parameters:   none
 * return value: none
 * description:  sends a POST request to update the Party class with new information pulled
 *                  from the server about the song name & vote data
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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

    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Refresh Party Success");
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    _user_count = party.user_count;
                                    _song_data = party.song_data;
                                    _skipvotes = [NSString stringWithFormat:@"%@",[party valueForKeyPath:@"_song_data.vote_data.1"]];
                                    _dontskipvotes = [NSString stringWithFormat:@"%@",[party valueForKeyPath:@"_song_data.vote_data.-1"] ];
                                    NSLog(@"Refresh: VOTING: %@ to %@",_skipvotes, _dontskipvotes);
                                    NSLog(@"Refresh: SONG NAME: %@",[party valueForKeyPath:@"_song_data.song_title"]);
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error refreshing party: %@", error);
                                }];

}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * method:       vote
 * parameters:   vote decision, current song name
 * return value: none
 * description:  sends a POST request to the server with a vote and song name attached - with
 *                  the current song name, the server can check for repeat votes
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
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
                                  @"vote" : votedecision //vote will be 1 for skip or -1 for don't skip, depending on user input
                                  };
    
    [objectManager postObject:nil
                         path:partyPathUrl
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                                {
                                    NSLog(@"Vote Success");
                                    parties = mappingResult.array;
                                    party = parties[0];
                                    _user_count = party.user_count;
                                    _song_data = party.song_data;
                                    _skipvotes = [NSString stringWithFormat:@"%@",[party valueForKeyPath:@"_song_data.vote_data.1"]];
                                    _dontskipvotes = [NSString stringWithFormat:@"%@",[party valueForKeyPath:@"_song_data.vote_data.-1"] ];
                                    NSLog(@"Vote: VOTING: %@ to %@",_skipvotes, _dontskipvotes);
                                    NSLog(@"Vote: SONG NAME: %@",[party valueForKeyPath:@"_song_data.song_title"]);
                                }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
                                {
                                    [ErrorHandler parseError:error.userInfo];
                                    NSLog(@"Error updating party (vote): %@", error);
                                }];
}
@end
