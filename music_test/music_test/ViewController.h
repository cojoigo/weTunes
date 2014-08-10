//
//  ViewController.h
//  music_test
//
//  Created by Russell E Walker on 8/2/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

- (IBAction)nextSong:(id)sender;

@end
