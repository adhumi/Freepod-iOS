//
//  EpisodeCell.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeCell : UITableViewCell {
    
}

@property (nonatomic, retain) UIImageView*          cover;
@property (nonatomic, retain) UILabel*              titre;
@property (nonatomic, retain) UILabel*              date;
@property (nonatomic, retain) UILabel*              duration;

@end
