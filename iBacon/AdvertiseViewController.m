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
<CBPeripheralManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong) UIAlertView *alertView;
@property(nonatomic,strong) NSDictionary *beaconPeripheralData;
@property(nonatomic,strong) CBPeripheralManager *peripheralManager;

@end

@implementation AdvertiseViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:[self proximityUUID]];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"com.majoritythird.baconregion"];
    self.beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];

    [self.peripheralManager startAdvertising:self.beaconPeripheralData];
  }
  return self;
}

#pragma mark - Methods

- (NSString *)proximityUUID
{
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kMTProximityUUIDKey];
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
