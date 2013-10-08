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

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  __weak typeof(self) weakSelf = self;

  if ([[segue identifier] isEqualToString:@"Advertise"]) {
    AdvertiseViewController *advertiseViewController = segue.destinationViewController;

    advertiseViewController.doneBlock = ^{
      [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
  }

  else if ([[segue identifier] isEqualToString:@"Consume"]) {
    ConsumeViewController *consumerViewController = segue.destinationViewController;

    consumerViewController.doneBlock = ^{
      [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
  }
}

@end
