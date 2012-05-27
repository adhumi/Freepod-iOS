//
//  AudioEpisodeViewController.h
//  test1
//
//  Created by Adrien Humilière on 26/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioEpisodeViewController : UIViewController {
	IBOutlet UIImageView *jacquette;
	IBOutlet UILabel *nom;
}

@property (nonatomic, retain) IBOutlet UIImageView *jacquette;
@property (nonatomic, retain) IBOutlet UILabel *nom;

@property (strong, nonatomic) id episode;

@end
