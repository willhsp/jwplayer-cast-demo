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

    GCKDiscoveryCriteria *criteria = [[GCKDiscoveryCriteria alloc] initWithApplicationID:@"20B73138"];
    GCKCastOptions *options = [[GCKCastOptions alloc] initWithDiscoveryCriteria:criteria];
    [GCKCastContext setSharedInstanceWithOptions:options];
    
    [GCKLogger sharedInstance].delegate = self;
    GCKLoggerFilter *filter = [[GCKLoggerFilter alloc] init];
    [filter setMinimumLevel:GCKLoggerLevelVerbose];
    [GCKLogger sharedInstance].filter = filter;
    
    // Wrap main view in the GCKUICastContainerViewController and display the mini controller.
    UIStoryboard *appStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController =
            [appStoryboard instantiateViewControllerWithIdentifier:@"UINavigationController-hC9-kd-PEj"];
    GCKUICastContainerViewController *castContainerVC =
            [[GCKCastContext sharedInstance] createCastContainerControllerForViewController:navigationController];
    castContainerVC.miniMediaControlsItemEnabled = YES;
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = castContainerVC;
    [self.window makeKeyAndVisible];
    
    [GCKCastContext sharedInstance].useDefaultExpandedMediaControls = YES;

    return YES;
}

- (void)logMessage:(NSString *)message
           atLevel:(GCKLoggerLevel)level
      fromFunction:(NSString *)function
          location:(NSString *)location {
    NSLog(@"%@ - %@, %@", function, message, location);
}

@end
