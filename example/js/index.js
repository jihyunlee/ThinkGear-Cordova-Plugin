/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var thinkGear;

function isConnected() {
  thinkGear.isConnected(
    function(res) {
      document.getElementById('isConnected').innerHTML = res;
    },
    function(err) {
      console.log('isConnected Failed');
    });
}

function startStream() {
  thinkGear.startStream(
    function(res) {
      run();
    },
    function(err) {
      console.log('startStream Failed');
    });  
}

function stopStream() {
  thinkGear.stopStream(
    function(res) {
    },
    function(err) {
      console.log('stopStream Failed');
    }); 
}

function readSignalStatus() {
  thinkGear.getSignalStatus(
    function(res) {
      // console.log('signal status', res);
      document.getElementById('signalStatus').innerHTML = res;
    },
    function(err) {
      console.log('signalStatus Failed');
    });
}

function readEEG() {
  thinkGear.getEEG(
    function(eeg) {
      // console.log('eeg', eeg);
      if (eeg.hasOwnProperty('delta'))
        document.getElementById('delta').innerHTML = eeg.delta;
      if (eeg.hasOwnProperty('theta'))
        document.getElementById('theta').innerHTML = eeg.theta;
      if (eeg.hasOwnProperty('lowAlpha'))
        document.getElementById('lowAlpha').innerHTML = eeg.lowAlpha;
      if (eeg.hasOwnProperty('highAlpha'))
        document.getElementById('highAlpha').innerHTML = eeg.highAlpha;
      if (eeg.hasOwnProperty('lowBeta'))
        document.getElementById('lowBeta').innerHTML = eeg.lowBeta;
      if (eeg.hasOwnProperty('highBeta'))
        document.getElementById('highBeta').innerHTML = eeg.highBeta;
      if (eeg.hasOwnProperty('lowGamma'))
        document.getElementById('lowGamma').innerHTML = eeg.lowGamma;
      if (eeg.hasOwnProperty('highGamma'))
        document.getElementById('highGamma').innerHTML = eeg.highGamma;
    },
    function(err) {
      console.log('readEEG Failed');
    });
}

function readESense() {
  thinkGear.getESense(
    function(esense) {
      // console.log('esense', esense);
      if (esense.hasOwnProperty('attention'))
        document.getElementById('attention').innerHTML = esense.attention;
      if (esense.hasOwnProperty('meditation'))
        document.getElementById('meditation').innerHTML = esense.meditation;
    },
    function(err) {
      console.log('readESense Failed');
    });
}

function run() {

  readSignalStatus();
  readEEG();
  readESense();

  window.requestAnimationFrame(function() {
    run();
  });
}

function init(event) {

  if (window.cordova.logger)
    window.cordova.logger.__onDeviceReady();

  thinkGear = new ThinkGear();

  thinkGear.version(
    function(res) {
      document.getElementById('version').innerHTML = 'version: ' + res;
      run();
    },
    function(err) {
      console.log('version Failed');
    });
};

function isPhoneGap() {
  return ((cordova || PhoneGap || phonegap) && /^file:\/{3}[^\/]/i.test(window.location.href) && /ios|iphone|ipod|ipad|android/i.test(navigator.userAgent)) ||
    window.tinyHippos; //this is to cover phonegap emulator
}

if (isPhoneGap())
  document.addEventListener("deviceready", init);
else
  window.addEventListener("load", init);