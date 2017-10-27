//
//  USTAppModelDetailScreen.m
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTAppModelDetailScreen.h"
#import "USTTableViewCellPoster.h"
#import "USTTableViewCellParagraph.h"
#import "USTAppModel.h"
#import "USTClientRemoteService.h"
#import "USTAppUtils.h"

@interface USTAppModelDetailScreen ()
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation USTAppModelDetailScreen

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.tableView == nil && tableView) {
        // we have to get the referece to the table view
        // in order to handle the data changes from the fetch controller
        self.tableView = tableView;
    }
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4; //image, release date, rating, description
}

typedef NS_ENUM(NSInteger, USTAppModelDetailScreenIndex) {
    USTAppModelDetailScreenIndexImage   = 0,
    USTAppModelDetailScreenIndexDate    = 1,
    USTAppModelDetailScreenIndexRating  = 2,
    USTAppModelDetailScreenIndexText    = 3
};


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == USTAppModelDetailScreenIndexImage) {

        USTTableViewCellPoster *cell = [tableView dequeueReusableCellWithIdentifier:@"USTTableViewCellPoster" forIndexPath:indexPath];
        
        UIImage* posterImage = nil;
        if(self.film.poster_path_image_data_detail != nil) {
            posterImage = [UIImage imageWithData:self.film.poster_path_image_data_detail.binary_data];
            
        }
        
        
        if(posterImage == nil) {

            // Get the image
            
            NSString* imageUrl = [NSString stringWithFormat:@"%@%@?api_key=%@",
                                  [[USTAppModel appModel] serverImagesUrlWithSize:USTClientRemoteServiceImageSize_w500],
                                  self.film.poster_path,
                                  [[USTAppModel appModel] serverApiKey]];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [USTAppUtils downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *image, NSData* data) {
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                if (succeeded) {
                    
                    dispatch_async_on_main_queue(^{
                        // update the image in the cell
                        [cell configureWithImage:image];
                    });
                    
                    NSAssert([data length] > 0, @"[ASSERT] The data should be initialized");
                    NSAssert(self.film.managedObjectContext != nil, @"[ASSERT] The context should be initialized modelEntityFilm.managedObjectContext");
                    
                    // update the store with the image data
                    self.film.poster_path_image_data_detail = [[USTModelEntityImageDataPosterDetail alloc] initWithContext:self.film.managedObjectContext];
                    self.film.poster_path_image_data_detail.binary_data = data;
                    
                    dispatch_async_on_background_queue(^{
                        [[USTAppModel appModel] saveContext];
                    });
                    
                } else {
                    
                    NSLog(@"[ERROR] The poster image could not be downloaded.");
                    
                    dispatch_async_on_main_queue(^{
                        [cell configureWithImage:[UIImage imageNamed:@"DummyPoster"]];
                    });
                }
            }];
            
        } else {
            
            [cell configureWithImage:posterImage];
        }

        return cell;
        
    } else if(indexPath.row == USTAppModelDetailScreenIndexDate) {
        
        USTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USTTableViewCell" forIndexPath:indexPath];
        
        NSString* releaseDate = [USTAppUtils stringFromDate:self.film.release_date format:@"dd-MM-yyyy"];
        [cell configureCellWithTitle:NSLocalizedString(@"Release date: ", nil) value:releaseDate];
        
        return cell;
        
    } else if(indexPath.row == USTAppModelDetailScreenIndexRating) {
        
        USTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USTTableViewCell" forIndexPath:indexPath];
        
        NSString* ratingValue = [NSString stringWithFormat:@"%@ / %lld", self.film.vote_average, self.film.vote_count];
        [cell configureCellWithTitle:NSLocalizedString(@"Rating: ", nil) value:ratingValue];
        
        return cell;
        
    } else if(indexPath.row == USTAppModelDetailScreenIndexText) {
        
        USTTableViewCellParagraph *cell = [tableView dequeueReusableCellWithIdentifier:@"USTTableViewCellParagraph" forIndexPath:indexPath];
        
        [cell configureCellWithText:self.film.overview];
        
        return cell;
        
    }
    
    NSAssert(NO, @"[ASSERT] The cell index does not meet the table model.");
    
    return nil;
}



#pragma mark - ------------------ USTAppModelScreenProtocol --------------------


@end
