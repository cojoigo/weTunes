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
	// Do any additional setup after loading the view, typically from a nib.
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
    // Ask the music player for the current song.
    MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
    
    // Display the artist, album, and song name for the now-playing media item.
    // These are all UILabels.
    self.songLabel.text   = [currentItem valueForProperty:MPMediaItemPropertyTitle];

}

@end
