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
 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

#import "TGAccessoryManager.h"

@class CDVThinkGear;

// @protocol ThinkGearDelegate
// @end

// the eSense values
typedef struct {
	int attention;
	int meditation;
} ESenseValues;

// the EEG power bands
typedef struct {
	int delta;
	int theta;
	int lowAlpha;
	int highAlpha;
	int lowBeta;
	int highBeta;
	int lowGamma;
	int highGamma;
} EEGValues;


@interface CDVThinkGear : CDVPlugin <TGAccessoryDelegate> {
    short rawValue;
    int rawCount;
    int blinkStrength;
    int signalStrength;
    ESenseValues eSenseValues;
    EEGValues eegValues;
}

// @property (nonatomic,assign) id <ThinkGearDelegate> delegate;

- (void)version:(CDVInvokedUrlCommand *)command;
- (void)isConnected:(CDVInvokedUrlCommand *)command;
- (void)startStream:(CDVInvokedUrlCommand *)command;
- (void)stopStream:(CDVInvokedUrlCommand *)command;
- (void)getSignalStatus:(CDVInvokedUrlCommand *)command;
- (void)getESense:(CDVInvokedUrlCommand *)command;
- (void)getEEG:(CDVInvokedUrlCommand *)command;
- (void)getBlinkStrength:(CDVInvokedUrlCommand *)command;
- (void)getSensorValue:(CDVInvokedUrlCommand *)command;
- (void)getRawCount:(CDVInvokedUrlCommand *)command;

// TGAccessoryDelegate protocol methods
- (void)accessoryDidConnect:(EAAccessory *)accessory;
- (void)accessoryDidDisconnect;
- (void)dataReceived:(NSDictionary *)data;

@end