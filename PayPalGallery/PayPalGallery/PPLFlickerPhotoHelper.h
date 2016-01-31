//
//  PPLFlickerPhotoHelper.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPLFlickerPhotoHelper : NSObject

+ (void)fetchFlickerPhotoWithCompletion:(void (^)(NSData *result, NSDictionary *info))callback;

@end
