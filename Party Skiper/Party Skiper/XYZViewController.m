//
//  XYZViewController.m
//  Party Skiper
//
//  Created by Connor Igo on 7/16/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "XYZViewController.h"
#import "XYZServerCommunication.h"
#import "musicDetails.h"
#import <MediaPlayer/MediaPlayer.h>

XYZServerCommunication* comm;
BOOL didload = false;
@interface XYZViewController ()

@end

@implementation XYZViewController


- (IBAction)unwindMainView:(UIStoryboardSegue *)segue
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.host_createparty_password_textbox) {
        [self CreateParty:0];
        //Call CreatePartyFunction
    }
    if(textField == self.guest_joinparty_partyid_textbox) {
        [self JoinParty:0];
        //Call Login function
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!didload)
    {
        comm = [[XYZServerCommunication alloc] init];
        [comm createUser];
        didload = true;
    }
    self.host_createparty_partyname_textbox.delegate = self;
    self.host_createparty_password_textbox.delegate = self;
    self.guest_joinparty_partyid_textbox.delegate = self;
    self.guest_joinparty_password_textbox.delegate = self;
    self.host_partyinfo_partyid.text = comm.party_id;
    self.host_partyinfo_partyname_label.text = comm.party_name;
    
    [self.view addSubview:self.host_party_nowplaying_textbox];
    
    musicDetails *musicObject;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:musicObject];
    
    MPMediaItem *currentItem = musicObject.song.nowPlayingItem;
    NSString *title = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    NSMutableString *song_data = [NSMutableString string];
    if (title != nil){
        [song_data appendString:title];
        [song_data appendString:@" by "];
        [song_data appendString:artist];
    }
    self.host_party_nowplaying_textbox.text = song_data;
    
}

- (IBAction)JoinParty:(id)sender
{
    NSString *rsp;
    rsp = [comm joinParty:_guest_joinparty_partyid_textbox.text andPassword:_guest_joinparty_password_textbox.text];
    if ([rsp  isEqual: @"success"])
    {
           [self performSegueWithIdentifier:@"JPSegue" sender:self];
    }
    else
    {
        //Alert sequence can be used for fails or to enter password
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please Enter a party password" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)CreateParty:(id)sender
{
    NSString *rsp;
    rsp = [comm createParty:_host_createparty_partyname_textbox.text andPassword:_host_createparty_password_textbox.text];
    if ([rsp  isEqual: @"success"])
    {
        NSLog(@"PartyID : %@", comm.party_id);
        [self performSegueWithIdentifier:@"CPSegue" sender:self];
    }
    else
    {
        //Alert sequence can be used for fails or to enter password
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Party Name is not unique" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)PartyInfo:(id)sender
{
        //self.host_partyinfo_partyid.text = @"lol";
        [self performSegueWithIdentifier:@"HPISegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)handleNowPlayingItemChanged:(id)notification {
    musicDetails *musicObject;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:musicObject];
    
    MPMediaItem *currentItem = musicObject.song.nowPlayingItem;
    NSString *title = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    NSMutableString *song_data = [NSMutableString string];
    if (title != nil){
        [song_data appendString:title];
        [song_data appendString:@" by "];
        [song_data appendString:artist];
    }
    self.host_party_nowplaying_textbox.text = song_data;
    [self viewDidLoad];
}

@end
