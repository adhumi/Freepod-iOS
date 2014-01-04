//
//  CoverButton.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "CoverButton.h"

@implementation CoverButton

- (id) initWithFrame:(CGRect)frame andPodcast:(Podcast *)podcast {
    self = [self initWithFrame:frame];
    if (self) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cover setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)],
		[_cover setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.]];
        [_cover addTarget:self action:@selector(onCoverTouch) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_cover];
		
        _podcast = podcast;
        
		[self updateCover];
    }
    return self;
}

- (void)onCoverTouch {
    [_delegate coverTouched:_podcast];
}

- (void)updateCover {
	NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.adhumi.fr/api/get-img-podcast.php?id=%d&nom=logo_normal&width=%f", [_podcast podcastId], _cover.frame.size.width * [[UIScreen mainScreen] scale]]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (connectionError) {
			NSLog(@"Error loading cover");
		} else {
			UIImage *image = [[UIImage alloc] initWithData:data];
			[_cover setBackgroundImage:image forState:UIControlStateNormal];
		}
	}];
}


@end
