//
//  EpisodeCell.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "EpisodeCell.h"

@implementation EpisodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 65)];
        
        _cover = [[UIImageView alloc] init];
        [_cover setFrame:CGRectMake(0, 0, 65, 65)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
