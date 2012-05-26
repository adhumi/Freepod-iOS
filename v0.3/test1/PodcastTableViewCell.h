//
//  PodcastTableViewCell.h
//  test1
//
//  Created by Adrien Humilière on 24/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PodcastTableViewCell : UITableViewCell {
	IBOutlet UILabel *nomPodcast;
	__weak IBOutlet UIImageView *jacquettePodcast;
}

@property (nonatomic, retain) UILabel *nomPodcast;

@end
