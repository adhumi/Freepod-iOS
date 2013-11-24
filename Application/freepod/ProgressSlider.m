//
//  ProgressSlider.m
//  freepod
//
//  Created by Adrien Humilière on 24/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "ProgressSlider.h"

@implementation ProgressSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMinimumTrackImage:[UIImage imageNamed:@"void"] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[UIImage imageNamed:@"void"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	float progress = ((_progressValue - _minProgressValue) / (_maxProgressValue - _minProgressValue));
	float valueRatio = (([self value] - [self minimumValue]) / ([self maximumValue] - [self minimumValue]));
	float trackHeight = [self trackRectForBounds:rect].size.height + 2;
	float trackPosY = [self trackRectForBounds:rect].origin.y - 1;
	float trackWidth = self.frame.size.width - 40;
	
    CGContextRef c = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth, trackHeight));
	
    [[UIColor lightGrayColor] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth * progress, trackHeight));
	
    [[UIColor freepodYellowColor] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth * valueRatio, trackHeight));
}


@end
