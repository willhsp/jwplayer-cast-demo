//
//  AppDelegate.m
//  JWPlayer-SDK-iOS-Demo
//
//  Created by Max Mikheyenko on 1/7/15.
//  Copyright (c) 2015 JWPlayer. All rights reserved.
//

#import "AppDelegate.h"
#import <JWPlayerKit/JWPlayerKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    [JWPlayerKitLicense setLicenseKey: @"UpXncXa5/f97eyfgs8pOfZ6SQaGqA046djwe1VIdweLb5+Oa"];

    return YES;
}

@end
