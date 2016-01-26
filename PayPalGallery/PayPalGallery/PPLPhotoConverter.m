//
//  PPLWebPhotoConverter.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoConverter.h"

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

    } else if([item isKindOfClass:[NSURL class]]){
        NSURL *url = item;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        callback(image, nil);
    }
}
@end
