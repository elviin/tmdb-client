//
//  USTClientDemoService.m
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTClientDemoService.h"

@implementation USTClientDemoService

- (NSString*) serverUrl {
    
    return @"https://demomode";
}

- (NSString*_Null_unspecified) serverImagesUrlWithSize:(NSString*)imgSize {
    
    return @"https://demomode";
}

- (NSString*_Null_unspecified) serverApiKey {
    
    return @"demomode";
}

- (void) getPopularMoviesWithLanguage:(NSString*)language page:(NSNumber*)page region:(NSString*)region completion:(void (^ _Null_unspecified)(NSDictionary * _Null_unspecified, NSError * _Null_unspecified))completion {
    
}

@end
