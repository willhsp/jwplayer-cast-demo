//
//  ObjCViewController.m
//  JWPlayer-SDK-iOS-Demo
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

#import "ObjCViewController.h"
#import "JWPlayer_SDK_iOS_Demo-Swift.h"
#import <JWPlayer_iOS_SDK/JWPlayerController.h>

@interface ObjCViewController ()

@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic) JWPlayerController *player;

@end

@implementation ObjCViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    JWConfig *config = [JWConfig configWithContentURL:@"http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4"];
    self.player = [[JWPlayerController alloc]initWithConfig:config];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIView *playerView = self.player.view;
    [self.playerContainerView addSubview:playerView];
    [playerView constrainToSuperview];
    
    [self addCastButton];
    [self startListening];
}

- (void)addCastButton {
    NSLog(@"Adding Cast Button");

    GCKUICastButton *castButton = [[GCKUICastButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    castButton.tintColor = [UIColor grayColor];    castButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:castButton];


//    [self addButtonToControlsOverlay:castButton
//                   distanceFromRight:-35.0];
}

- (void)addButtonToControlsOverlay:(UIView *)button
                 distanceFromRight:(NSInteger)distanceFromRight {
    UIView *controlsOverlayView = [UIView new];
    
    [controlsOverlayView addSubview:button];

    NSLayoutConstraint *viewBottom;
    NSLayoutConstraint *viewRight;
    NSLayoutConstraint *viewHeight;
    
    viewHeight = [button.heightAnchor constraintEqualToConstant: 22];

    if (@available(iOS 11.0, *)) {
        viewBottom = [NSLayoutConstraint constraintWithItem:button
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                      // Attaching to the safeAreaLayoutGuide of the view causes weird layouts between iPhone X and previous devices
                                                     toItem:controlsOverlayView
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1
                                                   constant:-12];
        viewRight = [NSLayoutConstraint constraintWithItem:button
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:controlsOverlayView.safeAreaLayoutGuide
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1
                                                  constant:distanceFromRight];
    } else {
        viewBottom = [NSLayoutConstraint constraintWithItem:button
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:controlsOverlayView.layoutMarginsGuide
                                                  attribute:NSLayoutAttributeBottom
                                                 multiplier:1
                                                   constant:0];
        viewRight = [NSLayoutConstraint constraintWithItem:button
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:controlsOverlayView.layoutMarginsGuide
                                                 attribute:NSLayoutAttributeRight
                                                multiplier:1
                                                  constant:distanceFromRight];
    }
    [NSLayoutConstraint activateConstraints:@[ viewBottom, viewRight, viewHeight ]];
}

- (void)startCastSession {
    GCKSession *session = GCKCastContext.sharedInstance.sessionManager.currentSession;

    GCKMediaInformation *mediaInformation = [self getMediaInformation];
    
    GCKMediaLoadOptions *loadOptions = [GCKMediaLoadOptions new];
    loadOptions.playPosition = 10.0;
    
    [session.remoteMediaClient loadMedia:mediaInformation withOptions:loadOptions];

    // This needs a one second delay so that if the player is currently presented, it has time to get
    // dismissed first. Otherwise the chromecast library will try to present the expanded controls
    // on the dismissed player view.
    //    [ChromecastService performSelector:@selector(presentMediaControls) withObject:nil afterDelay:5];
}

- (GCKMediaInformation *)getMediaInformation {
    GCKMediaMetadata *chromecastMetadata = [[GCKMediaMetadata alloc] initWithMetadataType:GCKMediaMetadataTypeTVShow];
    [chromecastMetadata setString:@"Episode Title" forKey:kGCKMetadataKeyTitle];
    [chromecastMetadata setString:@"Show Title" forKey:kGCKMetadataKeySeriesTitle];

    [chromecastMetadata addImage:[[GCKImage alloc] initWithURL:[NSURL URLWithString: @"http://api-images-production.channel5.com/images/episode/C5219550002/1920x1080.jpg"] width:180 height:180]];

    GCKMediaInformationBuilder *mediaInfoBuilder =
            [[GCKMediaInformationBuilder alloc] initWithEntity:@"https://www.channel5.com/episode/C5219550002"];
    mediaInfoBuilder.streamType = GCKMediaStreamTypeBuffered;
    
    mediaInfoBuilder.metadata = chromecastMetadata;
    mediaInfoBuilder.customData = @{
        @"c5Id": @"C5219550002",
        @"iabConsentString": @"",
        @"metadata": @{@"genre": @"Milkshake"},
        @"defaultSubtitlesOn": @NO,
        @"defaultAudioDescriptionOn": @NO,
        @"adobeAnalytics": @{
            @"deviceName": @"iPhone",
            @"deviceOS": @"iOS 14.6",
            @"gigyaId": @"",
            @"isUserLoggedIn": @0,
            @"network": @"C5",
            @"senderAppName": @"C5TestApp",
            @"senderAppVersion": @"1.0.0",
            @"userAgeBracket": @"",
            @"userGender": @""
        }
};;
    return [mediaInfoBuilder build];
}

- (void)startListening {
    [GCKCastContext.sharedInstance.sessionManager addListener:self];
}

# pragma mark GCKSessionManagerListener
- (void)sessionManager:(GCKSessionManager *)sessionManager didStartSession:(GCKSession *)session {
    [[GCKCastContext sharedInstance] presentDefaultExpandedMediaControls];
    [self startCastSession];
}

@end
