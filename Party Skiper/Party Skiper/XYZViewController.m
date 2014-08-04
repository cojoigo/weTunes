//
//  XYZViewController.m
//  Party Skiper
//
//  Created by Connor Igo on 7/16/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "XYZViewController.h"
#import "XYZServerCommunication.h"

XYZServerCommunication* comm;

@interface XYZViewController ()

@end

@implementation XYZViewController
//Stops multiple instances of XYZServerCommunication from being loaded
BOOL load = false;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!load)
    {
        comm = [[XYZServerCommunication alloc] init];
        [comm loadUser];
        load = true;
    }
}

//test to make sure user ID is being set and passed along fine
- (IBAction)testbutton:(id)sender
{
    NSLog(@"userid: %@",comm.user_id);
}
- (IBAction)JPLogin:(id)sender
{
    //    [comm joinparty];
    /*
     //Alert sequence can be used for fails or to enter password
     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter party password:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     UITextField * alertTextField = [alert textFieldAtIndex:0];
     alertTextField.keyboardType = UIKeyboardTypeNumberPad;
     alertTextField.placeholder = @"Enter password";
     [alert show];
     //[alert release];
     */
}
- (IBAction)CreateParty:(id)sender
{
    [comm createParty];
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

@end
