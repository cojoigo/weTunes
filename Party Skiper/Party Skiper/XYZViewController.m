//
//  XYZViewController.m
//  weTunes
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
BOOL hostingparty = false;
BOOL joinparty = false;
@interface XYZViewController ()

@end

@implementation XYZViewController

//handles when the host presses Skip Song, skips current song and updates local song data
- (IBAction)skipButtonPressed:(id)sender {
    musicDetails *musicObject = [[musicDetails alloc] init];
    [musicObject nextSong:(id)sender];
    
    musicObject.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicObject.musicPlayer.nowPlayingItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:musicObject
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:musicObject.musicPlayer];
    
    //MPMediaItem *currentItem = musicObject.musicPlayer.nowPlayingItem;
    musicObject.title = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    musicObject.artist = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    musicObject.songData = [NSMutableString string];
    NSLog(@"songtitle: %@", musicObject.title);
    if (musicObject.title != nil)
    {
        [musicObject.songData appendString:musicObject.title];
        [musicObject.songData appendString:@" by "];
        [musicObject.songData appendString:musicObject.artist];
        self.host_party_nowplaying_textbox.text = musicObject.songData;
        [self.host_party_nowplaying_textbox setNeedsDisplay];
        [comm updateParty:musicObject.songData];
    }
}

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

//called when each view loads, handles setting text and music info
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
    
    //[self.host_party_skip_button addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    if (hostingparty)
    {
        musicDetails *musicObject = [[musicDetails alloc] init];
        musicObject.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        musicObject.musicPlayer.nowPlayingItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:musicObject
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:musicObject.musicPlayer];
    
        //MPMediaItem *currentItem = musicObject.musicPlayer.nowPlayingItem;
        musicObject.title = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        musicObject.artist = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        musicObject.songData = [NSMutableString string];
        NSLog(@"songtitle: %@", musicObject.title);
        if (musicObject.title != nil)
        {
            [musicObject.songData appendString:musicObject.title];
            [musicObject.songData appendString:@" by "];
            [musicObject.songData appendString:musicObject.artist];
            self.host_party_nowplaying_textbox.text = musicObject.songData;
            [comm updateParty:musicObject.songData];
        }
        //Update the party info for guest and host!!
        [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:YES];
        NSLog(@"Vote skip, Vote dontskip: %@, %@", comm.skipvotes, comm.dontskipvotes);
    }
    if (joinparty)
    {
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(timerFired:)
                                       userInfo:nil
                                        repeats:YES];
        NSLog(@"songtitle:%@", [comm valueForKeyPath:@"song_data.song_title"]);
        self.guest_party_nowplaying_textbox.text = [comm valueForKeyPath:@"song_data.song_title"];
    }
}
//handles what happens on the 1s timer loop
- (void) timerFired:(NSTimer*)theTimer
{
    if (hostingparty)
    {
        musicDetails *musicObject = [[musicDetails alloc] init];
        musicObject.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        musicObject.musicPlayer.nowPlayingItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:musicObject
                               selector:@selector(handleNowPlayingItemChanged:)
                                   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                 object:musicObject.musicPlayer];
        
        //MPMediaItem *currentItem = musicObject.musicPlayer.nowPlayingItem;
        musicObject.title = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        musicObject.artist = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        musicObject.songData = [NSMutableString string];
        if (musicObject.title != nil)
        {
            [musicObject.songData appendString:musicObject.title];
            [musicObject.songData appendString:@" by "];
            [musicObject.songData appendString:musicObject.artist];
            self.host_party_nowplaying_textbox.text = musicObject.songData;
            [self.host_party_nowplaying_textbox setNeedsDisplay];
        }
    }
    if (joinparty)
    {
        self.guest_party_nowplaying_textbox.text = [comm valueForKeyPath:@"song_data.song_title"];
        [self.guest_party_nowplaying_textbox setNeedsDisplay];
    }
    [comm refreshParty];
    [self viewDidAppear:(YES)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(comm.user_count != nil)
        self.host_partyinfo_numberguests_label.text = comm.user_count;
    self.host_party_skip.text = comm.skipvotes;
    self.host_party_dontskip.text = comm.dontskipvotes;
    
    
}
//handles joining a party - making sure server responds before joining
- (IBAction)JoinParty:(id)sender
{
    NSString *rsp;
    rsp = [comm joinParty:_guest_joinparty_partyid_textbox.text andPassword:_guest_joinparty_password_textbox.text];
    if ([rsp  isEqual: @"success"])
    {
        joinparty = true;
        hostingparty = false;
        [self performSegueWithIdentifier:@"JPSegue" sender:self];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:rsp delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
//handles party creation - making sure server has responded before returning a party
- (IBAction)CreateParty:(id)sender
{
    NSString *rsp;
    rsp = [comm createParty:_host_createparty_partyname_textbox.text andPassword:_host_createparty_password_textbox.text andSongName:_host_party_nowplaying_textbox.text];
    if ([rsp  isEqual: @"success"])
    {
        NSLog(@"PartyID : %@", comm.party_id);
        hostingparty = true;
        joinparty = false;
        [self performSegueWithIdentifier:@"CPSegue" sender:self];
        [self viewDidAppear:(YES)];
    }
    else
    {
        //Alert sequence can be used for fails or to enter password
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:rsp delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        
    }
}
//handles when host presses the PartyInfo button
- (IBAction)PartyInfo:(id)sender
{
    //self.host_partyinfo_partyid.text = @"lol";
    [self performSegueWithIdentifier:@"HPISegue" sender:self];
    [comm refreshParty];
    while(comm.user_count ==  nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self viewDidAppear:(YES)];
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

- (IBAction)guestVote_Skip:(id)sender {
    
    [comm vote:[NSNumber numberWithInt:1] withSongName:_guest_party_nowplaying_textbox.text];
}

- (IBAction)guestVote_DontSkip:(id)sender {
    [comm vote:[NSNumber numberWithInt:-1] withSongName:_guest_party_nowplaying_textbox.text];
}
@end
