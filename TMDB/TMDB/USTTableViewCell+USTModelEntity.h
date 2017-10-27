//
//  USTTableViewCell+USTModelEntity.h
//  TMDB
//
//  Created by Vladimír Slavík on 28/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDB+CoreDataModel.h"
#import "USTTableViewCell.h"

@interface USTTableViewCell (USTModelEntity)

- (void)configureWithEntity:(USTModelEntity*)modelEntityFilm;

@end
