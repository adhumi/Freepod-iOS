//
//  AppDelegate.h
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

#define SERVER_URL @"http://webserv.freepod.net/"

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
