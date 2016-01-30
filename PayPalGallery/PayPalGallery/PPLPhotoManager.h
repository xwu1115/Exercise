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

@protocol PPLPhotoManagerDelegate

- (void) handleOauthLogin;
- (void) handlePhotoChanged;

@end


@interface PPLPhotoManager : NSObject
@property (nonatomic, strong) NSDictionary *assetCollections;
@property (nonatomic, weak) id<PPLPhotoManagerDelegate>delegate;

/**
 *  Display a photo.
 *  @param item  The photo user wants to display, it can be either a local gallery photo or web photo.
 *  @param size  The size of the photo the user wants to display.
 *  @param callback The funtion user passed into, to manipluate the generated UIImage.
 */
- (void)displayPhoto:(id)item size:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback;

/**
 *  Display the current selected photo of the manager class.
 *  @param size  The size of the photo the user wants to display.
 *  @param callback The funtion user passed into, to manipluate the generated UIImage.
 */
- (void)displaySelectedItemWithSize:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback;

/**
 *  Set the current selected photo for the manager class.
 *  @param item  The photo user wants to select, it can be either a local gallery photo or web photo.
 */
- (void)setCurrentSelectedItem:(id)item;

- (id)navigateSelectedItemToNext;

- (id)navigateSelectedItemToPrevious;

- (NSArray *)getAssetFromIdentifier:(NSString *)indentifier;

- (CLLocation *)getLocationFromPhoto:(id)photo;

@end
