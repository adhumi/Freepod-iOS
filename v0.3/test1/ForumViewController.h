//
//  ForumViewController.h
//  freepod
//
//  Created by Adrien Humilière on 05/06/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ForumViewController : UIViewController <UIActionSheetDelegate>{
	IBOutlet UIWebView *webView;
	IBOutlet UIBarButtonItem *playerButton;
	IBOutlet UINavigationBar *navBar;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *playerButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)displayPlayer:(id)sender;
- (IBAction)showActionSheet:(id)sender;


@end
