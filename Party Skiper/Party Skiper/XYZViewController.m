//
//  XYZViewController.m
//  Party Skiper
//
//  Created by Connor Igo on 7/16/14.
//  Copyright (c) 2014 Software Engineering 1. All rights reserved.
//

#import "XYZViewController.h"
#import "XYZServerCommunication.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    XYZServerCommunication* comm = [[XYZServerCommunication alloc] init];
    [comm loadUser];
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
