//
//  UITableViewCellFilm.h
//  TMDB
//
//  Created by Vladimír Slavík on 28/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USTTableViewCell.h"

@interface UITableViewCellFilm : USTTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* image;
@property (nonatomic, weak) IBOutlet UILabel* title;
@property (nonatomic, weak) IBOutlet UILabel* voteAverage;

@end
