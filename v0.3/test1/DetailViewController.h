//
//  DetailViewController.h
//  test1
//
//  Created by Adrien Humilière on 21/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpisodeControllerJacquetteDownloader.h"

@interface DetailViewController : UITableViewController <EpisodeControllerJacquetteDownloaderDelegate> {
	NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath;

@property (strong, nonatomic) id detailItem;

@end
