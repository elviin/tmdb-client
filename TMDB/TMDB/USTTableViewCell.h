//
//  USTTableViewCell.h
//  TMDB
//
//  Created by Vladimír Slavík on 28/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USTTableViewCell : UITableViewCell

- (void) configureCellWithTitle:(NSString*)textLabel value:(NSString*)detailTextLabel;

@end
