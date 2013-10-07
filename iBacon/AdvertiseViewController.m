//
//  AdvertiseViewController.m
//  iBacon
//
//  Created by Wes Gibbs on 10/7/13.
//  Copyright (c) 2013 Wes Gibbs. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "AdvertiseViewController.h"

NSString *const kMTProximityUUIDKey = @"MTProximityUUID";

@interface AdvertiseViewController ()
<CBPeripheralManagerDelegate>

@property(nonatomic,strong) CBPeripheralManager *peripheralManager;
@property(nonatomic,strong) NSDictionary *beaconPeripheralData;

@end

@implementation AdvertiseViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:[self proximityUUID]];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"com.majoritythird.baconregion"];
    _beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    [self.peripheralManager startAdvertising:self.beaconPeripheralData];
  }
  return self;
}

#pragma mark - Methods

- (NSString *)proximityUUID
{
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kMTProximityUUIDKey];
}

- (IBAction)stopAdvertising:(id)sender {
  [self.peripheralManager stopAdvertising];
  self.doneBlock();
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
  NSLog(@"foop");
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
  if (peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
    //    [self.peripheralManager stopAdvertising];
  }
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
