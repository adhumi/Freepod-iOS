//
//  PlayerMainViewController.h
//  freepod
//
//  Created by Adrien Humilière on 23/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

@interface PlayerMainViewController : UINavigationController {
	PlayerViewController *	_player;
}

+ (PlayerViewController*)instance;

@end
