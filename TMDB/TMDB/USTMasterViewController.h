//
//  USTMasterViewController.h
//  TMDB
//
//  Created by Vladimír Slavík on 24/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TMDB+CoreDataModel.h"

@class USTDetailViewController;

@interface USTMasterViewController : UITableViewController

@property (strong, nonatomic) USTDetailViewController *detailViewController;


@end

