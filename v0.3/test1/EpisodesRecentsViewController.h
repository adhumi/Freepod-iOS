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
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) UIImageView *banner;

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath;

@property (strong, nonatomic) id detailItem;

@end
