//
//  LiveViewController.h
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LiveViewController : UIViewController {
	IBOutlet UIImageView *onOffAir;
}
@property (strong, nonatomic) IBOutlet UIImageView *onOffAir;

- (IBAction)goLive:(id)sender;

@end
