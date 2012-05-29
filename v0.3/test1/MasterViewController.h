//
//  MasterViewController.h
//  test1
//
//  Created by Adrien Humilière on 21/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JacquetteDownloader.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <JacquetteDownloaderDelegate> {
	NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)jacquetteDidLoad:(NSIndexPath *)indexPath;

@end
