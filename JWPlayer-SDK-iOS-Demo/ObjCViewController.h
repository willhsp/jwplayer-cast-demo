//
//  ObjCViewController.h
//  JWPlayer-SDK-iOS-Demo
//
//  Created by Amitai Blickstein on 2/26/19.
//  Copyright © 2019 JWPlayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleCast/GoogleCast.h>
#import <JWPlayerKit/JWPlayerKit.h>
#import "JWPlayerKit/JWPlayerObjCViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjCViewController : JWPlayerObjCViewController <GCKSessionManagerListener>

@end

NS_ASSUME_NONNULL_END
