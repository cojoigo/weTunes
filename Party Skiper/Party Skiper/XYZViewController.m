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
BOOL didload = false;
@interface XYZViewController ()

@end

@implementation XYZViewController

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
}
- (IBAction)JoinParty:(id)sender
{
    [comm joinParty/*:_guest_joinparty_partyid_textbox.text*/];
    //Alert sequence can be used for fails or to enter password
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter party password:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    //alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Enter password";
    alertTextField.secureTextEntry = YES;
    [alert show];
    //thread
    [self performSegueWithIdentifier:@"JPSegue" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)CreateParty:(id)sender
{
    //_host_party_name = _host_createparty_partyname_textbox.text;
    //_host_party_password = _host_createparty_password_textbox.text;
    NSLog(@"!partyname: %@", _host_createparty_partyname_textbox.text);
    NSLog(@"!partypassword: %@", _host_createparty_password_textbox.text);
    [comm createParty:_host_createparty_partyname_textbox.text andPassword:_host_createparty_password_textbox.text];
    //thread
    if (comm.CP)
    {
        [self performSegueWithIdentifier:@"CPSegue" sender:self];
    }
    else
    {
        //Alert sequence can be used for fails or to enter password
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Party Name is not unique" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        
    }
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
