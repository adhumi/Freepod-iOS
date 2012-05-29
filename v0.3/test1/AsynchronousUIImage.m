//
//  AsynchronousUIImage.m
//  test1
//
//  Created by Adrien Humilière on 30/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "AsynchronousUIImage.h"

@implementation AsynchronousUIImage
@synthesize delegate;
@synthesize tag;

- (void)loadImageFromURL:(NSString *)anUrl {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:anUrl] 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:30.0];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
  	[self.delegate imageDidLoad:[self initWithData:data]];
}

@end