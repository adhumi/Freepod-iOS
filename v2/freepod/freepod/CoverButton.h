//
//  CoverButton.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Podcast.h"

@protocol CoverButtonDelegate <NSObject>

- (void)coverTouched:(Podcast *)podcast;

@end

@interface CoverButton : UIView <NSURLConnectionDelegate> {
    UIButton *          _cover;
    Podcast *           _podcast;
}

@property (nonatomic, retain) id delegate;

- (id)initWithFrame:(CGRect)frame andPodcast:(Podcast *)podcast;

@end
