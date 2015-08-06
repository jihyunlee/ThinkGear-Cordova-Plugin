/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVThinkGear.h"

@implementation CDVThinkGear

// @synthesize delegate;

- (void)pluginInitialize {
    NSLog(@"------------------------------");
    NSLog(@" ThinkGear Cordova Plugin");
    NSLog(@" (c)2015 Jihyun Lee");
    NSLog(@"------------------------------");

    [super pluginInitialize];

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    TGAccessoryType accessoryType = (TGAccessoryType)[defaults integerForKey:@"accessory_type_preference"];
    //
    // to use a connection to the ThinkGear Connector for
    // Simulated Data, uncomment the next line
    //accessoryType = TGAccessoryTypeSimulated;
    //
    // NOTE: this wont do anything to get the simulated data stream
    // started. See the ThinkGear Connector Guide.
    //
    BOOL rawEnabled = [defaults boolForKey:@"raw_enabled"];
    
    if(rawEnabled)
		// setup the TGAccessoryManager to dispatch dataReceived notifications every 0.05s (20 times per second)
        [[TGAccessoryManager sharedTGAccessoryManager] setupManagerWithInterval:0.05 forAccessoryType:accessoryType];
    else
        [[TGAccessoryManager sharedTGAccessoryManager] setupManagerWithInterval:0.2 forAccessoryType:accessoryType];

    [[TGAccessoryManager sharedTGAccessoryManager] setDelegate:self];
    [[TGAccessoryManager sharedTGAccessoryManager] setRawEnabled:rawEnabled];

    if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
        [[TGAccessoryManager sharedTGAccessoryManager] startStream];
}

- (void)version:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[[TGAccessoryManager sharedTGAccessoryManager]getVersion]];
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isConnected:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[[TGAccessoryManager sharedTGAccessoryManager] connected]];
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startStream:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil &&
	   [[TGAccessoryManager sharedTGAccessoryManager] connected] ) {
		[[TGAccessoryManager sharedTGAccessoryManager] startStream];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopStream:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil &&
	   [[TGAccessoryManager sharedTGAccessoryManager] connected] ) {
		[[TGAccessoryManager sharedTGAccessoryManager] stopStream];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getSignalStatus:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil) {
		NSString *signalStatus;
		if(signalStrength == 0)
			signalStatus = @"connected";
		else if(signalStrength > 0 && signalStrength < 50)
			signalStatus = @"connecting3";
		else if(signalStrength > 50 && signalStrength < 200)
			signalStatus = @"connecting2";
		else if(signalStrength == 200)
			signalStatus = @"connecting1";
		else
			signalStatus = @"disconnected";
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:signalStatus];
	}
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getESense:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil) {
		NSDictionary *eSense = [[NSDictionary alloc] initWithObjectsAndKeys:
								[NSNumber numberWithInteger:eSenseValues.attention], @"attention",
								[NSNumber numberWithInteger:eSenseValues.meditation], @"meditation", nil];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:eSense];
	}
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getEEG:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil) {
		NSDictionary *eeg = [[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithInteger:eegValues.delta], @"delta",
							 [NSNumber numberWithInteger:eegValues.theta], @"theta",
							 [NSNumber numberWithInteger:eegValues.lowAlpha], @"lowAlpha",
							 [NSNumber numberWithInteger:eegValues.highAlpha], @"highAlpha",
							 [NSNumber numberWithInteger:eegValues.lowBeta], @"lowBeta",
							 [NSNumber numberWithInteger:eegValues.highBeta], @"highBeta",
							 [NSNumber numberWithInteger:eegValues.lowGamma], @"lowGamma",
							 [NSNumber numberWithInteger:eegValues.highGamma], @"highGamma", nil];
		
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:eeg];
	}
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getBlinkStrength:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:blinkStrength];
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getSensorValue:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:rawValue];
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getRawCount:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	
	if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:rawCount];
	else
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark -
#pragma mark TGAccessoryDelegate protocol methods

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is connected.
- (void)accessoryDidConnect:(EAAccessory *)accessory {

  // start the data stream to the accessory
  [[TGAccessoryManager sharedTGAccessoryManager] startStream];
}

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is disconnected.
- (void)accessoryDidDisconnect {

}

//  This method gets called by the TGAccessoryManager when data is received from the
//  ThinkGear-enabled device.
- (void)dataReceived:(NSDictionary *)data
{
	// [data retain];
	
	if([data valueForKey:@"blinkStrength"])
		blinkStrength = [[data valueForKey:@"blinkStrength"] intValue];
	
	if([data valueForKey:@"raw"])
		rawValue = [[data valueForKey:@"raw"] shortValue];
	
	if([data valueForKey:@"rawCount"])
		rawCount = [[data valueForKey:@"rawCount"] intValue];
	
	if([data valueForKey:@"poorSignal"])
		signalStrength = [[data valueForKey:@"poorSignal"] intValue];
	
	if([data valueForKey:@"eSenseAttention"])
		eSenseValues.attention = [[data valueForKey:@"eSenseAttention"] intValue];
	if([data valueForKey:@"eSenseMeditation"])
		eSenseValues.meditation = [[data valueForKey:@"eSenseMeditation"] intValue];
	
	if([data valueForKey:@"eegDelta"])
		eegValues.delta = [[data valueForKey:@"eegDelta"] intValue];
	if([data valueForKey:@"eegTheta"])
		eegValues.theta = [[data valueForKey:@"eegTheta"] intValue];
	if([data valueForKey:@"eegLowAlpha"])
		eegValues.lowAlpha = [[data valueForKey:@"eegLowAlpha"] intValue];
	if([data valueForKey:@"eegHighAlpha"])
		eegValues.highAlpha = [[data valueForKey:@"eegHighAlpha"] intValue];
	if([data valueForKey:@"eegLowBeta"])
		eegValues.lowBeta = [[data valueForKey:@"eegLowBeta"] intValue];
	if([data valueForKey:@"eegHighBeta"])
		eegValues.highBeta = [[data valueForKey:@"eegHighBeta"] intValue];
	if([data valueForKey:@"eegLowGamma"])
		eegValues.lowGamma = [[data valueForKey:@"eegLowGamma"] intValue];
	if([data valueForKey:@"eegHighGamma"])
		eegValues.highGamma = [[data valueForKey:@"eegHighGamma"] intValue];
	
	NSLog(@"===========================================");
	NSLog(@" Signal Strength | %d", signalStrength);
	NSLog(@"-------------------------------------------");
	NSLog(@" ESense          | attention   %d", eSenseValues.attention);
	NSLog(@"                 | meditation  %d", eSenseValues.meditation);
	NSLog(@"-------------------------------------------");
	NSLog(@" EEG             | delta       %d", eegValues.delta);
	NSLog(@"                 | theta       %d", eegValues.theta);
	NSLog(@"                 | low Alpha   %d", eegValues.lowAlpha);
	NSLog(@"                 | high Alpha  %d", eegValues.highAlpha);
	NSLog(@"                 | low Beta    %d", eegValues.lowBeta);
	NSLog(@"                 | high Beta   %d", eegValues.highBeta);
	NSLog(@"                 | low Gamma   %d", eegValues.lowGamma);
	NSLog(@"                 | high Gamma  %d", eegValues.highGamma);
	
	// [data release];
}

@end