//
//  LiveViewController.h
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LiveViewController : UIViewController {
	IBOutlet UIImageView *onOffAir;
	IBOutlet UINavigationBar *navBar;
	IBOutlet UIButton *playPause;
	NSTimer *timer;
}

@property NSTimer *timer;
@property AVPlayer *audioPlayer;

@property (strong, nonatomic) IBOutlet UIImageView *onOffAir;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIButton *playPause;

- (IBAction)goLive:(id)sender;

@end
