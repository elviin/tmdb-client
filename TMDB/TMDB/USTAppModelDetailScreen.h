//
//  USTAppModelDetailScreen.h
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "USTAppModelScreenProtocol.h"
#import "TMDB+CoreDataModel.h"

@interface USTAppModelDetailScreen : NSObject<USTAppModelScreenProtocol,
                                              UITableViewDataSource>

@property (nonatomic, strong) USTModelEntityFilm* film;

@end
