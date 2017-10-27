//
//  USTAppModelMasterScreen.h
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "TMDB+CoreDataModel.h"
#import "USTAppModelScreenProtocol.h"

@class USTAppModel, USTAppModelDetailScreen;
@interface USTAppModelMasterScreen : NSObject<USTAppModelScreenProtocol,
                                              NSFetchedResultsControllerDelegate,
                                              UITableViewDataSource,
                                              UISearchResultsUpdating>

@property (nonatomic, copy) NSNumber* pageNumber;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext appModel:(USTAppModel*)appModel;
- (void) refreshFetch;
- (void) getPopularMoviesWithLanguage:(NSString*)language region:(NSString*)region;
- (USTModelEntity*)objectAtIndexPath:(NSIndexPath *)indexPath;


@end
