//
//  PPLWebPhotoConverter.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLObject.h"

@import Photos;

@interface PPLPhotoConverter : NSObject

+ (void)imageWith:(PPLObject *)item size:(CGSize)size manager:(PHCachingImageManager *)manager completion:(void (^)(UIImage *result, NSDictionary *info))callback;

+ (CLLocation *)getLocationFromItem:(id)item;
+ (NSDate *)getCreationTimeFromItem:(id)item;

+ (PPLObject *)convert:(id)item;
@end
