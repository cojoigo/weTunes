//
//  musicDetails.m
//  Party Skiper
//
//  Created by Russell E Walker on 8/7/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "musicDetails.h"

@implementation musicDetails
@synthesize musicPlayer;

- (IBAction)nextSong:(id)sender {
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [musicPlayer skipToNextItem];
}

@end