//
//  EpisodeControllerJacquetteDownloader.h
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@class Episode;
@class DetailViewController;

@protocol EpisodeControllerJacquetteDownloaderDelegate;

@interface EpisodeControllerJacquetteDownloader : NSObject {
    Episode *episode;
    NSIndexPath *indexPathInTableView;
    id <EpisodeControllerJacquetteDownloaderDelegate> delegate;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, strong) Episode *episode;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <EpisodeControllerJacquetteDownloaderDelegate> delegate;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload:(int)width;
- (void)cancelDownload;

@end

@protocol EpisodeControllerJacquetteDownloaderDelegate 

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath;

@end