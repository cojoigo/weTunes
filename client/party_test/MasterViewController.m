//
//  MasterViewController.m
//  party_test
//
//  Created by AJ Pereira on 7/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "MasterViewController.h"
#import "User.h"
#import "Party.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *parties;

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"REST Party Test";
    [self loadUser];
}

- (void)loadUser
{
    //initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
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
         _users = mappingResult.array;
         [self.tableView reloadData];
         
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
    User *user = _users[0];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sgoodwin.pythonanywhere.com"]];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
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
                                                                                        method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    NSDictionary *queryParams = @{
                                  @"name" : @"abcdefgh",
                                  @"password" : @"",
                                  @"song_data" : @""
                                  };
    //queryParams must have proper JSON structure to get a response
    
    [objectManager postObject:nil
                         path:@"/create_party"
                   parameters:queryParams
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         NSLog(@"Success");
         _parties = mappingResult.array;
         //[self.tableView reloadData];
     }
                      failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error creating party: %@", error);
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    User *user = _users[indexPath.row];
    cell.textLabel.text = user.user_password;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
