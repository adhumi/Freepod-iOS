//
//  PlayerMainViewController.m
//  freepod
//
//  Created by Adrien Humilière on 23/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "PlayerMainViewController.h"

@interface PlayerMainViewController ()

@end

@implementation PlayerMainViewController

static PlayerMainViewController* instance;

+ (PlayerMainViewController*)instance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    return instance;
}

- (id)init {
	_player = [PlayerViewController instance];
    self = [super initWithRootViewController:_player];
	
    if (self) {
		//
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.navigationBar setOpaque:YES];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1.]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
