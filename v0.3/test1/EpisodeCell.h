//
//  EpisodeCell.h
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeCell : UITableViewCell {
	IBOutlet UIImageView *jacquette;
	IBOutlet UILabel *nom;
	IBOutlet UILabel *date;
	IBOutlet UILabel *duration;
}

@property (strong, nonatomic) IBOutlet UIImageView *jacquette;
@property (strong, nonatomic) IBOutlet UILabel *nom;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *duration;

@end
