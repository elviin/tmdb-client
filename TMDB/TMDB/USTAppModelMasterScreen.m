//
//  USTAppModelMasterScreen.m
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTAppModelMasterScreen.h"
#import "USTTableViewCell+USTModelEntity.h"
#import "USTAppModel.h"
#import "USTAppUtils.h"

@interface USTAppModelMasterScreen ()
@property (weak, nonatomic) USTAppModel* appModel;
@property (strong, nonatomic) NSFetchedResultsController<USTModelEntityFilm *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSNumber* totalResults;
@property (nonatomic, copy) NSNumber* totalPages;

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, weak) UISearchController* searchController;

@end

@implementation USTAppModelMasterScreen

-(instancetype)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext appModel:(USTAppModel*)appModel {
    if ( self = [super init] ) {
        _managedObjectContext = managedObjectContext;
        _appModel = appModel;
    }
    return self;
}

#pragma mark - --------------- USTAppModelScreenProtocol ----------------

- (void) getPopularMoviesWithLanguage:(NSString*)language region:(NSString*)region {
    
    dispatch_async_on_main_queue(^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    if(self.pageNumber == nil) self.pageNumber = @(1);
    
    [self.appModel.client getPopularMoviesWithLanguage:language page:@([self.pageNumber integerValue] + 1) region:region completion:^(NSDictionary *responseDictionary, NSError *error) {
        
        dispatch_async_on_main_queue(^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });

        
        if (!error) {
            
            // update the page index only when load has been successful
            self.pageNumber     = [responseDictionary objectForKey:@"page"];
            
            self.totalResults   = [responseDictionary objectForKey:@"total_results"];
            self.totalPages     = [responseDictionary objectForKey:@"total_pages"];
            
            // get the local film instances, so we do not store multiple instances
            // of the same film
            NSArray* localFilms = [self findExistingFilmsStoredLocally];
            
            
            for(NSDictionary* film in [[responseDictionary objectForKey:@"results"] allObjects]) {
            
                NSInteger filmId = [[film objectForKey:@"id"] integerValue];
                
                // find existing films
                BOOL isStoreAlreadyFilm = NO;
                for(USTModelEntityFilm* localFilm in localFilms) {
                    
                    if(localFilm.entityId == filmId) {
                        isStoreAlreadyFilm = YES;
                        break;
                    }
                }
                
                if(isStoreAlreadyFilm == YES) {
                    
                    // e.g. compare/update data in the local film
                    
                } else {
                
                    // add a new one
                    // from time to time the data are empty, or invalid
                    // before stored in core data, the validity of the data should be tested
                    USTModelEntityFilm *newModelEntityFilm = [[USTModelEntityFilm alloc] initWithContext:self.managedObjectContext];
                    
                    id nullityTest = [film objectForKey:@"adult"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setAdult:[nullityTest boolValue]];
                    
                    nullityTest = [film objectForKey:@"backdrop_path"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setBackdrop_path:nullityTest];
                    
                    nullityTest = [film objectForKey:@"id"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setEntityId:[[film objectForKey:@"id"] integerValue]];
                    
                    nullityTest = [film objectForKey:@"original_language"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setOriginal_language:nullityTest];
                    
                    nullityTest = [film objectForKey:@"original_title"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setOriginal_title:[film objectForKey:@"original_title"]];
                    
                    nullityTest = [film objectForKey:@"overview"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setOverview:[film objectForKey:@"overview"]];
                    
                    nullityTest = [film objectForKey:@"popularity"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setPopularity:nullityTest];
                    
                    nullityTest = [film objectForKey:@"poster_path"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setPoster_path:nullityTest];
                    
                    nullityTest = [film objectForKey:@"release_date"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setRelease_date:[USTAppUtils dateFromString:nullityTest
                                                                                   format:USTAppUtilsDateFormatFromApi]];
                    
                    nullityTest = [film objectForKey:@"title"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setTitle:nullityTest];
                    
                    nullityTest = [film objectForKey:@"video"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setVideo:nullityTest];
                    
                    nullityTest = [film objectForKey:@"vote_average"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setVote_average:nullityTest];
                    
                    nullityTest = [film objectForKey:@"vote_count"];
                    if(nullityTest && ![nullityTest isKindOfClass:[NSNull class]]) [newModelEntityFilm setVote_count:[nullityTest integerValue]];
                    
                    [newModelEntityFilm setTimestamp:[NSDate date]];
                
                }
                
            }
        
        }
        
    }];
}

- (NSArray*) findExistingFilmsStoredLocally {
    
     NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"USTModelEntityFilm"];
     
     NSError *fetchError = nil;
     NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
     if (!results) {
         NSLog(@"Error fetching USTModelEntityFilm objects: %@\n%@", [fetchError localizedDescription], [fetchError userInfo]);
     }
    
    return results;
}


- (USTModelEntity*)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - --------------- UITableViewDataSource --------------------


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.tableView == nil && tableView) {
        // we have to get the referece to the table view
        // in order to handle the data changes from the fetch controller
        self.tableView = tableView;
    }
    
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellFilm" forIndexPath:indexPath];
    [cell configureWithEntity:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        }
    }
}

#pragma mark - ------------ NSFetchedResultsControllerDelegate ----------------

- (NSFetchedResultsController<USTModelEntityFilm *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<USTModelEntityFilm *> *fetchRequest = USTModelEntityFilm.fetchRequest;
    
    if(self.searchController.isActive) { // search the items' properties for the string
        
        NSString *searchString = self.searchController.searchBar.text;
        // search in USTModelEntityFilm.title property
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ", searchString];
        
        [fetchRequest setPredicate:predicate];
    }
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    // There is a bug in ios10, https://stackoverflow.com/a/40430288/3389683, workaround is to make cacheName = nil //should be @"Master"
    NSFetchedResultsController<USTModelEntityFilm *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void) refreshFetch {
    
    self.fetchedResultsController = nil;
    
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    else
        [self.tableView reloadData];

}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
    // we wait on the very last moment the table appeared
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        
        dispatch_after_delay_on_main_queue(1.0, ^{
            // and store the data
            [self saveDataInContext];
        });
        
    }];
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
                USTTableViewCell* cell = (USTTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell configureWithEntity:anObject];
             }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    
    [CATransaction commit];
}

- (void) saveDataInContext {
    
    // Save the context.
    
//    NSError *coreDataError = nil;
//    if (![self.managedObjectContext save:&coreDataError]) {
//        NSLog(@"Unresolved error %@, %@", coreDataError, coreDataError.userInfo);
//    }
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        [managedObjectContext performBlock:^{
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }];
    }
}


#pragma mark - ----------------- UISearchResultsUpdating ---------------------

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // remember the search bar with isActive property
    // see - (NSFetchedResultsController<USTModelEntityFilm *> *)fetchedResultsController
    // method definition
    self.searchController = searchController;
    
    [self refreshFetch];
}




@end
