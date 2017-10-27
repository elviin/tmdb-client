//
//  USTClientProtocol.h
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol USTClientProtocol <NSObject>
- (NSString*_Null_unspecified) serverUrl;
- (NSString*_Null_unspecified) serverImagesUrlWithSize:(NSString*_Null_unspecified)imgSize;
- (NSString*_Null_unspecified) serverApiKey;
- (void) getPopularMoviesWithLanguage:(NSString*_Null_unspecified)language page:(NSNumber*_Null_unspecified)page region:(NSString*_Null_unspecified)region completion:(void (^_Null_unspecified)(NSDictionary *_Null_unspecified responseDictionary, NSError *_Null_unspecified error))completion;


@end
