//
//  ProgressSlider.h
//  freepod
//
//  Created by Adrien Humilière on 24/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressSlider : UISlider

@property (nonatomic, assign) float		minProgressValue;
@property (nonatomic, assign) float		maxProgressValue;
@property (nonatomic, assign) float		progressValue;

@end
