//
//  WWGViewController.m
//  iBacon
//
//  Created by Wes Gibbs on 10/7/13.
//  Copyright (c) 2013 Wes Gibbs. All rights reserved.
//

#import "RoleSelectionViewController.h"
#import "AdvertiseViewController.h"
#import "ConsumeViewController.h"

@interface RoleSelectionViewController ()

@end

@implementation RoleSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"Advertise"]) {
    AdvertiseViewController *advertiseViewController = segue.destinationViewController;

    advertiseViewController.doneBlock = ^{
      [self dismissViewControllerAnimated:YES completion:nil];
    };
  }

  else if ([[segue identifier] isEqualToString:@"Consume"]) {
    ConsumeViewController *consumerViewController = segue.destinationViewController;

    consumerViewController.doneBlock = ^{
      [self dismissViewControllerAnimated:YES completion:nil];
    };
  }
}

@end
