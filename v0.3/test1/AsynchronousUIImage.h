//
//  AsynchronousUIImage.h
//  test1
//
//  Created by Adrien Humilière on 30/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AsynchronousUIImage;

@protocol AsynchronousUIImageDelegate <NSObject>

@optional
-(void) imageDidLoad:(AsynchronousUIImage *)anImage;
@end

@interface AsynchronousUIImage : UIImage {
    NSURLConnection *connection;
    NSMutableData *data;
	
}

@property (nonatomic, assign) id <AsynchronousUIImageDelegate> delegate;
@property (nonatomic) int tag;

- (void)loadImageFromURL:(NSString *)anUrl;

@end