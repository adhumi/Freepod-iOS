//
//  JacquetteDownloader.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "JacquetteDownloader.h"
#import "Podcast.h"

#define kAppIconHeight 80


@implementation JacquetteDownloader

@synthesize podcast;
@synthesize indexPathInTableView;
@synthesize delegate = _delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)startDownload:(int) width {
    self.activeDownload = [NSMutableData data];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_normal&width=%d", [podcast idPodcast], width]]] delegate:self];
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
    
    self.podcast.jacquette208 = image;
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
    // call our delegate and tell it that our icon is ready for display
    [_delegate jacquetteDidLoad:self.indexPathInTableView];
}

@end