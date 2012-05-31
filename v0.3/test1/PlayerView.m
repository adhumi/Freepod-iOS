//
//  PlayerView.m
//  test1
//
//  Created by Adrien Humilière on 31/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

extern AVPlayer *audioPlayer;

@synthesize audioPlayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
	NSLog(@"player setté");
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
