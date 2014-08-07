//
//  ViewController.m
//  music_test
//
//  Created by Russell E Walker on 8/2/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>



@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *songLabel;

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	// Do any additional setup after loading the view, typically from a nib.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:self.musicPlayer];
    //self.songLabel.text   = @"test";
    MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
    self.songLabel.text   = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleNowPlayingItemChanged:(id)notification
{
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    // Ask the music player for the current song.
    MPMediaItem *currentItem2 = self.musicPlayer.nowPlayingItem;
    
    self.songLabel.text   = [currentItem2 valueForProperty:MPMediaItemPropertyTitle];
    if (self.songLabel.text == nil){
        self.songLabel.text = @"You changed the song";
    }

}

@end
