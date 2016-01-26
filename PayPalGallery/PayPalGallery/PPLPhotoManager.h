//
//  PPLPhotoManager.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLPhotoCollection.h"
#import "PPLPhoto.h"
#import "PPLVideo.h"

@import Photos;

@interface PPLPhotoManager : NSObject
@property (nonatomic, strong) NSDictionary *assetCollections;
@end
