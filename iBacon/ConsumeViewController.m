//
//  ConsumeViewController.m
//  iBacon
//
//  Created by Wes Gibbs on 10/7/13.
//  Copyright (c) 2013 Wes Gibbs. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ConsumeViewController.h"

@interface ConsumeViewController ()
<CLLocationManagerDelegate>

@property(nonatomic,strong) CLBeaconRegion *beaconRegion;
@property(nonatomic,strong) CLLocationManager *locManager;
@property(nonatomic,weak) IBOutlet UITextView *consumeLogTextView;

@end

@implementation ConsumeViewController

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];

  if (self) {
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[self proximityUUID] major:1 minor:2 identifier:kMTBeaconIdentifier];
    _locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
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
    self.consumeLogTextView.text = [[NSString stringWithFormat:formatString, boolValue] stringByAppendingString:self.consumeLogTextView.text];

  }
  else {
    NSLog(@"%@", message);
    NSString *newLinedMessage = [message stringByAppendingString:@"\n"];
    self.consumeLogTextView.text = [newLinedMessage stringByAppendingString:self.consumeLogTextView.text];
  }
}

- (NSUUID *)proximityUUID
{
  NSString *uuidString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kMTProximityUUIDKey];
  return [[NSUUID alloc] initWithUUIDString:uuidString];
}

- (IBAction)stopConsuming:(id)sender {
  [self.locManager stopMonitoringForRegion:self.beaconRegion];
  self.doneBlock();
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  [self logIt:@"didDetermineState" boolValue:state];

  if ([CLLocationManager isRangingAvailable]) {
    if (state == CLRegionStateInside) {
      [manager startRangingBeaconsInRegion:self.beaconRegion];
    }
    else if (state == CLRegionStateOutside || state == CLRegionStateUnknown) {
      [manager stopRangingBeaconsInRegion:self.beaconRegion];
    }
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  [self logIt:@"@didFailWithError"];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
  [self logIt:@"didEnterRegion"];

  if ([CLLocationManager isRangingAvailable]) {
    [manager startRangingBeaconsInRegion:self.beaconRegion];
  }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
  [self logIt:@"didExitRegion"];
  [manager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
  if (beacons.count > 0) {
    CLBeacon *baconBeacon = [beacons firstObject];
    [self logIt:[NSString stringWithFormat:@"Major-Minor (%@-%@)", region.major, region.minor]];

    if (baconBeacon.proximity == CLProximityFar) {
      [self logIt:@"didRangeBeacons: Far"];
    }
    else if (baconBeacon.proximity == CLProximityNear) {
      [self logIt:@"didRangeBeacons: Near"];
    }
    else if (baconBeacon.proximity == CLProximityImmediate) {
      [self logIt:@"didRangeBeacons: Immediate"];
    }
  }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
  [self logIt:@"didStartMonitoringForRegion"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  [self logIt:@"didUpdateLocations"];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  [self logIt:@"monitoringDidFailForRegion"];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
  [self logIt:@"rangingBeaconsDidFailForRegion"];
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
  CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

  [self logIt:@"locationServicesEnabled" boolValue:[CLLocationManager locationServicesEnabled]];
  [self logIt:@"isRangingAvailable" boolValue:[CLLocationManager isRangingAvailable]];
  [self logIt:@"authorizationStatus" boolValue:authorizationStatus];
  [self logIt:@"isMonitoringAvailableForClass" boolValue:isMonitoringAvailableForClass];

  if (!isMonitoringAvailableForClass) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hardware not supported" message:@"Your device does not support this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
  }
  else if (authorizationStatus < kCLAuthorizationStatusAuthorized) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"App not authorized" message:@"This app is currently not authorized to use location services. Fix it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
  }
  else if (NO) { // HOW TO CHECK THAT BLUETOOTH IS ACTUALLY ON?
  }
  else {
    [self.locManager startMonitoringForRegion:self.beaconRegion];
  }
}

@end
