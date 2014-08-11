//
//  musicDetails.h
//  Party Skiper
//
//  Created by Russell E Walker on 8/7/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface musicDetails : NSObject <MPMediaPickerControllerDelegate>

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSMutableString *songData;
- (IBAction)nextSong:(id)sender;
- (void)handleNowPlayingItemChanged:(id)notification;

@end
