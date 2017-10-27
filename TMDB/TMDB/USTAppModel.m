//
//  USTAppModel.m
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTAppModel.h"
#import "USTAppModelMasterScreen.h"
#import "USTAppModelDetailScreen.h"
#import "USTClientDemoService.h"
#import "USTClientRemoteService.h"

@interface USTAppModel ()

@property (readwrite, strong) NSObject<USTClientProtocol>* _Nonnull client;
@property (readwrite, strong) NSPersistentContainer * _Nonnull persistentContainer;

@property(nonatomic, strong) USTAppModelMasterScreen* appModelMasterScreen;
@property(nonatomic, strong) USTAppModelDetailScreen* appModelDetailScreen;

@end

@implementation USTAppModel

static USTAppModel *sharedInstance;

+ (instancetype)appModel
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[USTAppModel alloc] init];
        [sharedInstance initializeModel];
    });
    
    return sharedInstance;
}

- (NSString*_Null_unspecified) serverUrl {
    
    return [self.client serverUrl];
}

- (NSString*_Null_unspecified) serverImagesUrlWithSize:(NSString*)imgSize {

    return [self.client serverImagesUrlWithSize:imgSize];
}

- (NSString*_Null_unspecified) serverApiKey {
    return [self.client serverApiKey];
}

- (void) initializeModel {
    
    if(_client == nil) {
#ifdef DEMO_RUNTIME
    _client = [USTClientDemoService new];
#else
    _client = [USTClientRemoteService new];
#endif
    }
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (void) removePersistentStore {

    @try {
        
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"USTModelEntityFilm"];
        NSBatchDeleteRequest* deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
        NSError *deleteError = nil;
        [self.persistentContainer.persistentStoreCoordinator executeRequest:deleteRequest withContext:self.persistentContainer.viewContext error:&deleteError];
        
        [[self appModelMasterScreen] refreshFetch];
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"[ERROR] The deletion of the store was not successful");
        
    } @finally {
        
    }

}

- (NSPersistentContainer *)persistentContainerWithCompletion:(void (^)(NSPersistentStoreDescription *storeDescription, NSError * _Nullable error))block {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TMDB"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                    
                } else {
                    
                    if(block) block(storeDescription, error);
                }
            }];
        }
    }
    
    return _persistentContainer;
}


#pragma mark - ------------- Core Data Saving support -------------

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    }
}

#pragma mark - ------------- View models creation method -------------

- (USTAppModelMasterScreen*)appModelMasterScreen {
    
    NSAssert(self.persistentContainer, @"[ASSERT] Before the view model can be created, first the persistent container must be initialized.");
    
    if(_appModelMasterScreen == nil) {
        _appModelMasterScreen = [[USTAppModelMasterScreen alloc] initWithManagedObjectContext:self.persistentContainer.viewContext appModel:self];
    }
    
    return _appModelMasterScreen;
}

- (USTAppModelDetailScreen*)appModelDetailScreen {

    if(_appModelDetailScreen == nil) {
        _appModelDetailScreen = [[USTAppModelDetailScreen alloc] init];
    }
    
    return _appModelDetailScreen;
    
}

- (USTAppModelDetailScreen*_Null_unspecified)appModelDetailScreenWithFilmIndex:(NSIndexPath*_Null_unspecified)filmIndex {
    
    USTAppModelDetailScreen* detailScreen = [self appModelDetailScreen];
    detailScreen.film = (USTModelEntityFilm*)[[self appModelMasterScreen] objectAtIndexPath:filmIndex];
    return detailScreen;
}






@end
