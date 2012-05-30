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
	UIView *refreshHeaderView;
	UILabel *refreshLabel;
	UIImageView *refreshArrow;
	UIActivityIndicatorView *refreshSpinner;
	BOOL isDragging;
	BOOL isLoading;
	NSString *textPull;
	NSString *textRelease;
	NSString *textLoading;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)jacquetteDidLoad:(NSIndexPath *)indexPath;

@end
