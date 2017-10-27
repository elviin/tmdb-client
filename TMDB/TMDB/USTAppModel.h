//
//  USTAppModel.h
//  TMDB
//
//  Created by Vladimír Slavík on 25/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "USTClientProtocol.h"

@class USTAppModelMasterScreen, USTAppModelDetailScreen;
@interface USTAppModel : NSObject
@property (readonly, strong) NSObject<USTClientProtocol>* _Nonnull client;
@property (readonly, strong) NSPersistentContainer * _Nonnull persistentContainer;
- (void) saveContext;
- (void) removePersistentStore;
- (NSPersistentContainer * _Null_unspecified)persistentContainerWithCompletion:(void (^ _Null_unspecified )(NSPersistentStoreDescription * _Null_unspecified, NSError * _Nullable))block;


+ (instancetype _Null_unspecified)appModel;

- (USTAppModelMasterScreen*_Null_unspecified)appModelMasterScreen;
- (USTAppModelDetailScreen*_Null_unspecified)appModelDetailScreen;
- (USTAppModelDetailScreen*_Null_unspecified)appModelDetailScreenWithFilmIndex:(NSIndexPath*_Null_unspecified)filmIndex;

- (NSString*_Null_unspecified) serverUrl;
- (NSString*_Null_unspecified) serverImagesUrlWithSize:(NSString*_Null_unspecified)imgSize;
- (NSString*_Null_unspecified) serverApiKey;

@end
