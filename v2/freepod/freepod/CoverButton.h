//
//  CoverButton.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoverButtonDelegate <NSObject>

- (void)coverTouched:(int)podcastId;

@end

@interface CoverButton : UIView <NSURLConnectionDelegate> {
    UIButton*           _cover;
    int                 _podcast;
    NSMutableData*      _coverData;
}

@property (nonatomic, retain) id    delegate;

- (id) initWithFrame:(CGRect)frame andPodcastId:(int)podcast;

@end
