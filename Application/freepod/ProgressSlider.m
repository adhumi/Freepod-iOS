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
	float trackHeight = [self trackRectForBounds:rect].size.height;
	float trackPosY = [self trackRectForBounds:rect].origin.y;
	float trackWidth = self.frame.size.width - 40;
	
    CGContextRef c = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth, trackHeight));
	
    [[UIColor whiteColor] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth * progress, trackHeight));
	
    [[UIColor colorWithRed:255/225.f green:186/255.f blue:2/255.f alpha:1] set];
    CGContextFillRect(c, CGRectMake(19, trackPosY, trackWidth * valueRatio, trackHeight));
}


@end
