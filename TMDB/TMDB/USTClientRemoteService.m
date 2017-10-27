//
//  USTClientRemoteService.m
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTClientRemoteService.h"


NSString *const USTClientRemoteServiceHTTPMethodGET        = @"GET";
NSString *const USTClientRemoteServiceHTTPMethodPOST       = @"POST";
NSString *const USTClientRemoteServiceHTTPMethodDELETE     = @"DELETE";
NSString *const USTClientRemoteServiceHTTPMethodPUT        = @"PUT" ;


NSString *const USTClientRemoteServiceImageSize_w92         = @"w92";
NSString *const USTClientRemoteServiceImageSize_w154        = @"w154";
NSString *const USTClientRemoteServiceImageSize_w342        = @"w342";
NSString *const USTClientRemoteServiceImageSize_w500        = @"w500";
NSString *const USTClientRemoteServiceImageSize_w780        = @"w780";
NSString *const USTClientRemoteServiceImageSize_original    = @"original";


static NSString* const USTClientRemoteServiceTMDbApiKey         = @"4aa883f95999ec813b8bfaf319f3972b";
static NSString* const USTClientRemoteServiceTMDbApiVersion     = @"3";
static NSString* const USTClientRemoteServiceTMDbServer         = @"api.themoviedb.org";
static NSString* const USTClientRemoteServiceTMDbServerImages   = @"image.tmdb.org/t/p"; //http--> added exception in the plist

/// The client certificate from was signed by RapidSSL SHA256 CA
/// openssl s_client -servername api.themoviedb.org -connect api.themoviedb.org:443
/// But this cert authority is not recognised by Apple, see https://support.apple.com/en-us/HT207177
/// That is why there must be an exception in the default TMDB target plist for api.themoviedb.org.

@interface USTClientRemoteService ()

@end

@implementation USTClientRemoteService

- (void) sendRequestWithMethod:(NSString*)method queryParams:(NSDictionary*)queryParams
                  endpointPath:(NSString*)endpointPath object:(id)object
                    completion:(void (^)(NSDictionary *responseDictionary, NSError *error))completion {
    
    // Session configuration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    // Request and header setup
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:120.0];
    
    
    // Query params
    NSAssert(endpointPath, @"[ASSERT] The endpointPath parameter must be defined");
    NSString* serverString = [NSString stringWithFormat:@"%@/%@", [self serverUrl], endpointPath];
    NSURLComponents *components = [NSURLComponents componentsWithString:serverString];
    NSMutableArray *queryItems = [NSMutableArray array];
    
    for (NSString *key in queryParams) {
        id value = queryParams[key];
        if([value isKindOfClass:[NSNull class]]) continue;
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:value]];
    }
    // Add the api token
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"api_key" value:[self serverApiKey]]];
    components.queryItems = queryItems;
    
    
    // Complete URL
    [request setURL:components.URL];

    
    // Post data //TODO should be added body configuration for POST, PUT, etc
    // For this GET case this code is enough
    NSData *postData = [[NSData alloc] initWithData:[@"{}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    
    // Initialize the session task
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            if (error) {
                NSLog(@"[UST] Error:%@", error);
                completion(nil, error);
            } else {
                completion(dictionary, error);
            }
            
        } else {
            NSLog(@"[UST] Error:%@", error);
            completion(nil, error);
        }
    }];
    
    
    [postDataTask resume];
}





#pragma mark - -------------------- USTClientProtocol ---------------------

- (NSString*_Null_unspecified) serverUrl {
    return [NSString stringWithFormat:@"https://%@/%@", USTClientRemoteServiceTMDbServer, USTClientRemoteServiceTMDbApiVersion];
}

- (NSString*_Null_unspecified) serverImagesUrlWithSize:(NSString*)imgSize {
    return [NSString stringWithFormat:@"http://%@/%@", USTClientRemoteServiceTMDbServerImages, imgSize];
}

- (NSString*_Null_unspecified) serverApiKey {
    
    return USTClientRemoteServiceTMDbApiKey;
}

- (void) getPopularMoviesWithLanguage:(NSString*)language page:(NSNumber*)page region:(NSString*)region
                           completion:(void (^)(NSDictionary *responseDictionary, NSError *error))completion {
    
    NSDictionary* queryParams = @{@"language"   : language  ? language              : [NSNull null],
                                  @"page"       : page      ? [page stringValue]    : [NSNull null],
                                  @"region"     : region    ? region                : [NSNull null]};
    
    [self sendRequestWithMethod:USTClientRemoteServiceHTTPMethodGET
                    queryParams:queryParams endpointPath:@"movie/popular"
                         object:nil
                     completion:^(NSDictionary * responseDictionary, NSError *error) {
        
        if(completion) completion(responseDictionary, error);
    }];
}


@end
