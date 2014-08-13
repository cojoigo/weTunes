//
//  musicDetails.m
//  weTunes
//
//  Created by Russell E Walker on 8/7/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "musicDetails.h"
#import "XYZServerCommunication.h"

@implementation musicDetails
@synthesize musicPlayer;

- (IBAction)nextSong:(id)sender {
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer skipToNextItem];
}

- (void)handleNowPlayingItemChanged:(id)notification {
     musicDetails *musicObject = [[musicDetails alloc] init];
     musicObject.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
     musicObject.musicPlayer.nowPlayingItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    
     /*NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
     [notificationCenter addObserver:self
     selector:@selector(handleNowPlayingItemChanged:)
     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:musicObject.musicPlayer];*/
     
     //MPMediaItem *currentItem = musicObject.musicPlayer.nowPlayingItem;
     musicObject.title = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
     musicObject.artist = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
     musicObject.songData = [NSMutableString string];
     NSLog(@"111songtitle: %@", musicObject.title);
     if (musicObject.title != nil){
     [musicObject.songData appendString:musicObject.title];
     [musicObject.songData appendString:@" by "];
     [musicObject.songData appendString:musicObject.artist];
     }
    //[comm updateParty:musicObject.songData];
    NSLog(@"iojfphow98wfhp289hfpoihefwpiohfewqiouefhwiouweqfhiuowqhofeiuwhqwefoiuhfqwoiuqefhfqweoiuh");
}

@end