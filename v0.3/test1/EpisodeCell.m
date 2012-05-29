//
//  EpisodeCell.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "EpisodeCell.h"

@implementation EpisodeCell
@synthesize jacquette;
@synthesize nom;
@synthesize date;
@synthesize duration;

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
