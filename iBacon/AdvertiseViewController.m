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

@property(nonatomic,weak) IBOutlet UITextView *advertiseLogTextView;
@property(nonatomic,strong) UIAlertView *alertView;
@property(nonatomic,strong) NSDictionary *beaconPeripheralData;
@property(nonatomic,strong) CLBeaconRegion *beaconRegion;
@property(nonatomic,strong) CBPeripheralManager *peripheralManager;

@end

@implementation AdvertiseViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];

  if (self) {
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[self proximityUUID] major:1 minor:2 identifier:kMTBeaconIdentifier];
    _beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
  }

  return self;
}

#pragma mark - Methods

- (void)logIt:(NSString *)message
{
  [self logIt:message boolValue:-1];
}

- (void)logIt:(NSString *)message boolValue:(BOOL)boolValue
{
  if (boolValue > -1) {
    NSString *formatString = [message stringByAppendingString:@": %d"];
    NSLog(formatString, boolValue);
    formatString = [formatString stringByAppendingString:@"\n"];
    self.advertiseLogTextView.text = [[NSString stringWithFormat:formatString, boolValue] stringByAppendingString:self.advertiseLogTextView.text];
  }
  else {
    NSLog(@"%@", message);
    NSString *newLinedMessage = [message stringByAppendingString:@"\n"];
    self.advertiseLogTextView.text = [newLinedMessage stringByAppendingString:self.advertiseLogTextView.text];
  }
}

- (NSUUID *)proximityUUID
{
  NSString *uuidString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kMTProximityUUIDKey];
  return [[NSUUID alloc] initWithUUIDString:uuidString];
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
  [self logIt:@"peripheralManagerDidStartAdvertising"];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
  if (peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
    [self.peripheralManager startAdvertising:self.beaconPeripheralData];
  }
  else {
    if (!self.alertView.visible) {
      self.alertView = [[UIAlertView alloc] initWithTitle:@"No Bluetooth" message:@"Please enable bluetooth" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
      [self.alertView show];
    }
  }
}

#pragma mark - UIAlertVewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  self.doneBlock();
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  BOOL isMonitoringAvailableForClass = [CLLocationManager isMonitoringAvailableForClass:[self.beaconRegion class]];

  [self logIt:@"isMonitoringAvailableForClass" boolValue:isMonitoringAvailableForClass];

  if (!isMonitoringAvailableForClass) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hardware not supported" message:@"Your device does not support this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
  }
  else {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
  }
}

@end
