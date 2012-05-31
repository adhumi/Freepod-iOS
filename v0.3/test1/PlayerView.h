//
//  PlayerView.h
//  test1
//
//  Created by Adrien Humilière on 31/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView {
}
@property (nonatomic, retain) AVPlayer *audioPlayer;


+ (Class)layerClass;
- (AVPlayer*)player;
- (void)setPlayer:(AVPlayer *)player;

@end