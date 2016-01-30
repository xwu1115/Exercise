//
//  PPLWebPhotoConverter.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoConverter.h"
#import "PPLObject.h"
@implementation PPLPhotoConverter

+ (void)imageWith:(id)item size:(CGSize)size manager:(PHCachingImageManager *)manager completion:(void (^)(UIImage *result, NSDictionary *info))callback
{
    if([item isKindOfClass:[PHObject class]]){
        PHAsset* asset = item;
        [manager requestImageForAsset:asset
                           targetSize:size
                          contentMode:PHImageContentModeAspectFill
                              options:nil
                        resultHandler:callback];

    } else if([item isKindOfClass:[PPLObject class]]){
        PPLObject* object = item;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.url]]];
        callback(image, nil);
    }
}

+ (CLLocation *)getLocationFromItem:(id)item
{
    if ([item isKindOfClass: [PHObject class]]) {
        PHAsset* asset = item;
        return asset.location;
    }else {
        return nil;
    }
}


+ (NSDate *)getCreationTimeFromItem:(id)item
{
    if ([item isKindOfClass: [PHObject class]]) {
        PHAsset* asset = item;
        return asset.creationDate;
    }else {
        return nil;
    }
}

@end
