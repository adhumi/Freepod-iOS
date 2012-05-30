//
//  EpisodeRecentDownloader.h
//  test1
//
//  Created by Adrien Humilière on 30/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@class Episode;
@class DetailViewController;

@protocol EpisodeRecentDownloaderDelegate;

@interface EpisodeRecentDownloader : NSObject {
    Episode *episode;
    NSIndexPath *indexPathInTableView;
    id <EpisodeRecentDownloaderDelegate> delegate;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, strong) Episode *episode;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <EpisodeRecentDownloaderDelegate> delegate;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload:(int)width;
- (void)cancelDownload;

@end

@protocol EpisodeRecentDownloaderDelegate 

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath;

@end