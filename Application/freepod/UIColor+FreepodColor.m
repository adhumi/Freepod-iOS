//
//  UIColor+FreepodColor.m
//  freepod
//
//  Created by Adrien Humilière on 24/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "UIColor+FreepodColor.h"

@implementation UIColor (FreepodColor)

+ (UIColor *)freepodDarkBlueColor {
	return [UIColor greenColor];
}

+ (UIColor *)freepodLightBlueColor {
	return [UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1.];
}

+ (UIColor *)freepodYellowColor {
	return [UIColor colorWithRed:255/225.f green:186/255.f blue:2/255.f alpha:1];
}

+ (UIColor *)darkGrayBackgroundColor {
	return [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.];
}

@end
