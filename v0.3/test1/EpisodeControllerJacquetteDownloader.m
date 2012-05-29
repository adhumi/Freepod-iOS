//
//  EpisodeControllerJacquetteDownloader.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "EpisodeControllerJacquetteDownloader.h"
#import "Episode.h"

#define kAppIconHeight 80


@implementation EpisodeControllerJacquetteDownloader

@synthesize episode;
@synthesize indexPathInTableView;
@synthesize delegate = _delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)startDownload:(int) width {
    self.activeDownload = [NSMutableData data];
	
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get-img-episode.php?id=%d&nom=image&width=%d", [episode idEpisode], width]]] delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    self.episode.jacquette = image;
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
    // call our delegate and tell it that our icon is ready for display
    [_delegate jacquetteDidLoad:self.indexPathInTableView];
}

@end
