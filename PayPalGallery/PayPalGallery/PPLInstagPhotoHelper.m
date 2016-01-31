//
//  PPLInstagPhotoHelper.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLInstagPhotoHelper.h"
#import "InstagramKit.h"

@implementation PPLInstagPhotoHelper

+ (void)fetchInstagramPhoto
{
    InstagramEngine *engine = [InstagramEngine sharedEngine];
    [engine getPopularMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
}

@end
