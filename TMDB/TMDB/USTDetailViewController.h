//
//  USTDetailViewController.h
//  TMDB
//
//  Created by Vladimír Slavík on 24/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMDB+CoreDataModel.h"

@interface USTDetailViewController : UIViewController<UITableViewDelegate>

@property (strong, nonatomic) NSIndexPath *filmIndex;

@end

