//
//  ObjCViewController.m
//  JWPlayer-SDK-iOS-Demo
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

#import "ObjCViewController.h"

#define videoUrlString @"https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8"
#define posterUrlString @"https://d3el35u4qe4frz.cloudfront.net/bkaovAYt-480.jpg"

@interface ObjCViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerContainerView;

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up the player.
    [self setUpPlayer];
}

/**
 Sets up the player with a simple configuration.
 */
- (void)setUpPlayer {
    NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
    NSURL *posterUrl = [NSURL URLWithString:posterUrlString];

    // First, use the JWPlayerItemBuilder to create a JWPlayerItem that will be used by the player configuration.
    JWError *playerItemError;
    JWPlayerItemBuilder *playerItemBuilder = [[JWPlayerItemBuilder alloc] init];
    [playerItemBuilder file:videoUrl];
    [playerItemBuilder posterImage:posterUrl];
    JWPlayerItem *playerItem = [playerItemBuilder buildAndReturnError:&playerItemError];
    if (playerItemError != nil) {
        // Handle error
        return;
    }

    // Second, create a player config with the created JWPlayerItem.
    JWError *configError;
    JWPlayerConfigurationBuilder *configBuilder = [[JWPlayerConfigurationBuilder alloc] init];
    [configBuilder playlist:@[playerItem]];
    JWPlayerConfiguration *config = [configBuilder buildAndReturnError:&configError];
    if (configError != nil) {
        // Handle error
        return;
    }

    // Lastly, use the created JWPlayerConfiguration to set up the player.
    [self.player configurePlayerWith:config];
}

@end
