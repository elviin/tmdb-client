//
//  UITableViewCellFilm.m
//  TMDB
//
//  Created by Vladimír Slavík on 28/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//


#import "UITableViewCellFilm.h"
#import "USTTableViewCell+USTModelEntity.h"
#import "USTAppUtils.h"
#import "USTAppModel.h"
#import "USTClientRemoteService.h"

@implementation UITableViewCellFilm

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.title.textColor                = RGBCOLORTINT;
    self.voteAverage.textColor          = RGBCOLORTINT;
    
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:RGBCOLORMINOR]; // set color here
    [self setSelectedBackgroundView:selectedBackgroundView];
}

- (void)configureWithEntity:(USTModelEntityFilm*)modelEntityFilm {
    
    self.title.text       = modelEntityFilm.title;
    self.voteAverage.text = [NSString stringWithFormat:@"%@ / 10",[modelEntityFilm.vote_average stringValue]];
    
    UIImage* posterImage = nil;
    if(modelEntityFilm.poster_path_image_data != nil) {
        posterImage = [UIImage imageWithData:modelEntityFilm.poster_path_image_data.binary_data];
        
    }
    
    
    if(posterImage == nil) {

        NSString* imageUrl = [NSString stringWithFormat:@"%@%@?api_key=%@",
                              [[USTAppModel appModel] serverImagesUrlWithSize:USTClientRemoteServiceImageSize_w92],
                              modelEntityFilm.poster_path,
                              [[USTAppModel appModel] serverApiKey]];
        
        
        [USTAppUtils downloadImageWithURL:imageUrl completionBlock:^(BOOL succeeded, UIImage *image, NSData* data) {
            
            if (succeeded) {

                dispatch_async_on_main_queue(^{
                    // change the image in the cell
                    self.image.image = image;
                });

                NSAssert([data length] > 0, @"[ASSERT] The data should be initialized");
                NSAssert(modelEntityFilm.managedObjectContext != nil, @"[ASSERT] The context should be initialized modelEntityFilm.managedObjectContext");
                
                // update the store with the image data
                modelEntityFilm.poster_path_image_data = [[USTModelEntityImageDataPoster alloc] initWithContext:modelEntityFilm.managedObjectContext];
                modelEntityFilm.poster_path_image_data.binary_data = data;

                // will be saved after the table view is complete or in the delegate
                
            } else {
                NSLog(@"[ERROR] The poster image could not be downloaded.");
                
                dispatch_async_on_main_queue(^{
                    self.image.image = [UIImage imageNamed:@"DummyPoster"];
                });
            }
        }];
        
    } else {
        
        self.image.image = posterImage;
    }
}

@end
