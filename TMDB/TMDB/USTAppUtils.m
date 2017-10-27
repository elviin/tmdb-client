//
//  USTAppUtils.m
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USTAppUtils.h"

NSString *const USTAppUtilsDateFormatFromApi = @"yyyy-MM-dd"; //e.g. "2016-06-18"

@implementation USTAppUtils


+ (NSDate*) dateFromString:(NSString*)string format:(NSString*)format {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat dateFromString:string];
}

+ (NSString*) stringFromDate:(NSDate*)date format:(NSString*)format {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

/**
 Getting the row height from the nib

 @param reusableCellIdentifier the cell identifier, could be the cell class name
 @param tableView table view holding the cell
 @return float with the value of the height of the designed cell
 */
+ (CGFloat)rowHeightForReusableCellIdentifier:(NSString *)reusableCellIdentifier
                                 andTableView:(UITableView *)tableView {
    CGFloat height = 0;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    height = cell.frame.size.height;
    return height;
}

+ (void)downloadImageWithURL:(NSString *)urlString completionBlock:(void (^)(BOOL succeeded, UIImage *image, NSData* data))completionBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if ( !error )
        {
            NSData* data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            if(image) {
                completionBlock(YES, image, data);
            } else {
                NSLog(@"[ERROR] Could not compose the image from the data.");
            }
        } else{
            completionBlock(NO, nil, nil);
        }
        
    }];
    
    [downloadPhotoTask resume];
}

void dispatch_after_delay(float delayInSeconds,
                          dispatch_queue_t queue,
                          dispatch_block_t block)
{
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, queue, block);
}

void dispatch_after_delay_on_main_queue(float delayInSeconds,
                                        dispatch_block_t block)
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after_delay(delayInSeconds, queue, block);
}

void dispatch_async_on_high_priority_queue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   block);
}

void dispatch_async_on_background_queue(dispatch_block_t block)
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

void dispatch_async_on_main_queue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}


@end
