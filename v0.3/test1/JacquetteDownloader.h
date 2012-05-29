//
//  JacquetteDownloader.h
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Podcast;
@class MasterViewController;

@protocol JacquetteDownloaderDelegate;

@interface JacquetteDownloader : NSObject {
    Podcast *podcast;
    NSIndexPath *indexPathInTableView;
    id <JacquetteDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) Podcast *podcast;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <JacquetteDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload:(int)width;
- (void)cancelDownload;

@end

@protocol JacquetteDownloaderDelegate 

- (void)jacquetteDidLoad:(NSIndexPath *)indexPath;

@end