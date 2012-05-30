//
//  EpisodesRecentsViewController.h
//  test1
//
//  Created by Adrien Humilière on 28/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EpisodeControllerJacquetteDownloader.h"
#import "AsynchronousUIImage.h"

@interface EpisodesRecentsViewController : UITableViewController <EpisodeControllerJacquetteDownloaderDelegate, AsynchronousUIImageDelegate> {
	NSMutableDictionary *imageDownloadsInProgress;
	UIImageView *banner;
	
	// Pull To Refresh
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

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) UIImageView *banner;

// Pull To Refresh
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath;

@property (strong, nonatomic) id detailItem;

@end
