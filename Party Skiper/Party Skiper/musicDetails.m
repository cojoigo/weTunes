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

//This function is triggered whenever the song changes in the music player.
//It retrieves the song information from the music player, and puts it in a string in the format "<Title> by <Artist>".
- (void)handleNowPlayingItemChanged:(id)notification {
     musicDetails *musicObject = [[musicDetails alloc] init];
     musicObject.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
     musicObject.musicPlayer.nowPlayingItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
         
     musicObject.title = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
     musicObject.artist = [musicObject.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
     musicObject.songData = [NSMutableString string];
     NSLog(@"songtitle: %@", musicObject.title);
     if (musicObject.title != nil){
     [musicObject.songData appendString:musicObject.title];
     [musicObject.songData appendString:@" by "];
     [musicObject.songData appendString:musicObject.artist];
     }
    //[comm updateParty:musicObject.songData];
    
}

@end