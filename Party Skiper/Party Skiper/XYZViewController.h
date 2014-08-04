//
//  XYZViewController.h
//  Party Skiper
//
//  Created by Connor Igo on 7/16/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZViewController : UIViewController
- (IBAction)unwindMainView:(UIStoryboardSegue *)segue;

//UI elements for the Join Party as Guest page
@property (strong, nonatomic) IBOutlet UITextField *guest_joinparty_partyid_textbox;
@property (strong, nonatomic) IBOutlet UIButton *guest_joinparty_browse_button;
@property (strong, nonatomic) IBOutlet UIButton *guest_joinparty_login_button;

//UI elements for the Create Party as Host page
@property (strong, nonatomic) IBOutlet UITextField *host_createparty_partyname_textbox;
@property (strong, nonatomic) IBOutlet UITextField *host_createparty_password_textbox;
@property (strong, nonatomic) IBOutlet UIButton *host_createparty_create_button;


@property (strong, nonatomic) IBOutlet UITextField *host_party_nowplaying_textbox;
@property (strong, nonatomic) IBOutlet UITextField *host_party_nextup_textbox;
@property (strong, nonatomic) IBOutlet UIButton *host_party_skip_button;
@property (strong, nonatomic) IBOutlet UIButton *host_party_dontskip_button;


@property (strong, nonatomic) IBOutlet UITextField *guest_party_nowplaying_textbox;
@property (strong, nonatomic) IBOutlet UIButton *guest_party_skip_button;
@property (strong, nonatomic) IBOutlet UIButton *guest_party_dontskip_button;
@property (strong, nonatomic) IBOutlet UITextField *guest_party_nextup_textbox;

@end
