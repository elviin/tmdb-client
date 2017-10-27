//
//  USTClientRemoteService.h
//  TMDB
//
//  Created by Vladimír Slavík on 29/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USTClientProtocol.h"

FOUNDATION_EXPORT NSString *const USTClientRemoteServiceHTTPMethodGET;
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceHTTPMethodPOST;
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceHTTPMethodDELETE;
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceHTTPMethodPUT;

FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_w92;        
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_w154;       
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_w342;       
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_w500;       
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_w780;       
FOUNDATION_EXPORT NSString *const USTClientRemoteServiceImageSize_original;



@interface USTClientRemoteService : NSObject<USTClientProtocol>

@end
