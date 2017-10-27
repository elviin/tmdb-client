//
//  USTTableViewCellPoster.m
//  TMDB
//
//  Created by Vladimír Slavík on 30/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTTableViewCellPoster.h"

@interface USTTableViewCellPoster ()

@property(nonatomic, weak) IBOutlet UIImageView* posterImage;

@end

@implementation USTTableViewCellPoster

- (void) configureWithImage:(UIImage*)image {
    
    self.posterImage.image = image;
}

@end
