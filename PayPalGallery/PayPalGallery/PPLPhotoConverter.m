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

+ (void)imageWith:(PPLObject *)item size:(CGSize)size manager:(PHCachingImageManager *)manager completion:(void (^)(UIImage *result, NSDictionary *info))callback
{
    if(item.asset != nil){
        PHAsset* asset = item.asset;
        [manager requestImageForAsset:asset
                           targetSize:size
                          contentMode:PHImageContentModeAspectFill
                              options:nil
                        resultHandler:callback];

    } else {
        PPLObject* object = item;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.url]]];
        callback(image, nil);
    }
}

+ (CLLocation *)getLocationFromItem:(PPLObject *)item
{
    if (item.asset != nil) {
        PHAsset* asset = item.asset;
        return asset.location;
    }else {
        return item.location;
    }
}

+ (PPLObject *)convert:(id)item
{
    PPLObject *obj = [[PPLObject alloc] init];
    if([item isKindOfClass:[PHAsset class]]){
        PHAsset *asset = item;
        obj.creationDate = asset.creationDate;
        obj.width = asset.pixelWidth;
        obj.height = asset.pixelHeight;
        obj.url = [NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@",asset.localIdentifier];
        obj.location = asset.location;
        obj.asset = asset;
    }else{
        //TODO: add funtion parse JSON format data
    }
    return obj;
}

+ (NSDate *)getCreationTimeFromItem:(PPLObject *)item
{
    if (item.asset != nil) {
        PHAsset* asset = item.asset;
        return asset.creationDate;
    }else {
        //TODO: add funtion parse JSON format data
    }
    return nil;
}

@end
