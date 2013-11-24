//
//  AppDelegate.h
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerMainViewController.h"
#import "PodcastsManager.h"

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
