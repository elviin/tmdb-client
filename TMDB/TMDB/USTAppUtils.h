//
//  USTAppUtils.h
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGBCOLORMAJOR [UIColor colorWithRed:20/225.0f green:35/225.0f blue:32/225.0f alpha:1]
#define RGBCOLORMINOR [UIColor colorWithRed:30/225.0f green:50/225.0f blue:40/225.0f alpha:1]
#define RGBCOLORTINT [UIColor colorWithRed:2/225.0f green:192/225.0f blue:116/225.0f alpha:1]
#define RGBCOLORCONTRAST [UIColor colorWithRed:210/225.0f green:210/225.0f blue:210/225.0f alpha:1]

FOUNDATION_EXPORT NSString *const USTAppUtilsDateFormatFromApi;



@interface USTAppUtils : NSObject

+ (NSDate*) dateFromString:(NSString*)string format:(NSString*)format;
+ (NSString*) stringFromDate:(NSDate*)date format:(NSString*)format;
+ (CGFloat) rowHeightForReusableCellIdentifier:(NSString *)reusableCellIdentifier
                                 andTableView:(UITableView *)tableView;
+ (void)downloadImageWithURL:(NSString *)urlString completionBlock:(void (^)(BOOL succeeded, UIImage *image, NSData* data))completionBlock;

void dispatch_after_delay(float delayInSeconds, dispatch_queue_t queue, dispatch_block_t block);
void dispatch_after_delay_on_main_queue(float delayInSeconds, dispatch_block_t block);
void dispatch_async_on_high_priority_queue(dispatch_block_t block);
void dispatch_async_on_background_queue(dispatch_block_t block);
void dispatch_async_on_main_queue(dispatch_block_t block);


@end
