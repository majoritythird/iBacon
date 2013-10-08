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

@interface AdvertiseViewController ()
<CBPeripheralManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIAlertView *alertView;
@property(nonatomic,strong) CBPeripheralManager *peripheralManager;

@end

@implementation AdvertiseViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];

  if (self) {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[self proximityUUID] identifier:kMTBeaconIdentifier];
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];

    [self.peripheralManager startAdvertising:beaconPeripheralData];
  }

  return self;
}

#pragma mark - Methods

- (NSUUID *)proximityUUID
{
  NSString *uuidString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kMTProximityUUIDKey];
  return [[NSUUID alloc] initWithUUIDString:uuidString];
}

- (void)showNoBluetoothAlert
{
  if (!self.alertView.visible) {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"No Bluetooth" message:@"Please enable bluetooth" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [self.alertView show];
  }
}

- (IBAction)stopAdvertising:(id)sender {
  if (self.peripheralManager.state >= CBPeripheralManagerStatePoweredOn) {
    [self.peripheralManager stopAdvertising];
  }
  self.doneBlock();
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
  if (error || self.peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
    [self showNoBluetoothAlert];
  }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
  if (peripheralManager.state < CBPeripheralManagerStatePoweredOn) {
    [self.peripheralManager stopAdvertising];
    [self showNoBluetoothAlert];
  }
}

#pragma mark - UIAlertVewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  self.doneBlock();
}

@end
