//
//  PlayerDetailsViewController.m
//  freepod
//
//  Created by Adrien Humilière on 24/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "PlayerDetailsViewController.h"

@interface PlayerDetailsViewController ()

@end

@implementation PlayerDetailsViewController

- (id)initWithEpisode:(Episode *)episode {
    self = [super init];
    if (self) {
        _episode = episode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	[[self view] setBackgroundColor:[UIColor darkGrayBackgroundColor]];
	
	UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	[title setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
	[title setTextColor:[UIColor freepodYellowColor]];
	[title setText:[_episode title]];
	[title setNumberOfLines:0];
	[title sizeToFit];
	[[self view] addSubview:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
