//
//  AppDelegate.h
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	@public
	NSMutableArray *podcastsList;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end
