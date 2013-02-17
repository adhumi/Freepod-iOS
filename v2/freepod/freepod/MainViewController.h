//
//  ViewController.h
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "CoverButton.h"
#import "PodcastViewController.h"

@interface MainViewController : UIViewController <NSURLConnectionDelegate, CoverButtonDelegate> {
    NSMutableData*          _jsonData;
    NSDictionary*           _podcasts;
    UIScrollView*           _scrollView;
}



@end
