//
//  CoverButton.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "CoverButton.h"

@implementation CoverButton

- (id) initWithFrame:(CGRect)frame andPodcastId:(int)podcast {
    self = [self initWithFrame:frame];
    if (self) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cover setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)],
		[_cover setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.]];
        [[_cover layer] setBorderColor:[UIColor blackColor].CGColor];
		[[_cover layer] setBorderWidth:1.];
		[[_cover layer] setShadowColor:[UIColor blackColor].CGColor];
		[[_cover layer] setShadowOffset:CGSizeMake(0, 0)];
		[[_cover layer] setShadowRadius:3.];
		[[_cover layer] setShadowOpacity:1.];
        [_cover addTarget:self action:@selector(onCoverTouch) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_cover];
        
        _coverData = [[NSMutableData alloc] init];
        
        _podcast = podcast;
        
		[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_normal&width=%f", _podcast, _cover.frame.size.width * [[UIScreen mainScreen] scale]]]] delegate:self];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)onCoverTouch {
    [_delegate coverTouched:_podcast];
}

#pragma mark - delegate NSURLConnection

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Request : podcasts didFinishLoading");
    
    UIImage *image = [[UIImage alloc] initWithData:_coverData];
    [_cover setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_coverData appendData:data];
}

- (void)connectionDidFailWithError:(NSError *)error {
    NSLog(@"Erreur de connexion");
}


@end
