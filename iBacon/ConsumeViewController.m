//
//  ConsumeViewController.m
//  iBacon
//
//  Created by Wes Gibbs on 10/7/13.
//  Copyright (c) 2013 Wes Gibbs. All rights reserved.
//

#import "ConsumeViewController.h"

@interface ConsumeViewController ()

@end

@implementation ConsumeViewController

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Methods

- (IBAction)stopConsuming:(id)sender {
  self.doneBlock();
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
