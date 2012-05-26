//
//  PodcastTableViewCell.m
//  test1
//
//  Created by Adrien Humilière on 24/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "PodcastTableViewCell.h"

@implementation PodcastTableViewCell

@synthesize nomPodcast = _nomPodcast;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
