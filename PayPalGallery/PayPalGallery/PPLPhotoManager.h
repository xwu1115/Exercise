//
//  PPLPhotoManager.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLPhoto.h"
#import "PPLVideo.h"

@import Photos;

@protocol PPLPhotoManagerDelegate

- (void) handleOauthLogin;
- (void) handlePhotoChanged;

@end


@interface PPLPhotoManager : NSObject

@property (nonatomic, weak) id<PPLPhotoManagerDelegate>delegate;

/**
 *  Load the local gallery. This is the inital step for PPL photo manager.
 */
- (void)loadData;


/**
 *  Display a photo.
 *  @param item  The photo user wants to display, it can be either a local gallery photo or web photo.
 *  @param size  The size of the photo the user wants to display.
 *  @param callback The funtion user passed into, to manipluate the generated UIImage.
 */
- (void)displayPhoto:(PPLObject *)item size:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback;


/**
 *  Get the location data from the input item.
 *  @param photo The photo data.
 *  @param callback The funtion user passed into, to manipluate the generated result.
 */
- (void)locationNameUpdatedWithPhoto:(PPLObject *)photo completion:(void (^)(NSString*result))callback;


/**
 *  Get the time data from the input item.
 *  @param photo The photo data.
 *  @param callback The funtion user passed into, to manipluate the generated result.
 */
- (void)creationTimeFromPhoto:(PPLObject *)photo format:(NSString*)format completion:(void (^)(NSString*result))callback;

/**
 *  Return the whole photo collection.
 *
 *  @return The array of ablum.
 */
- (NSArray *)getAlbumCollection;


/**
 *  Return a specfic photo collection.
 *  @param title The album title.
 *
 *  @return The photo collection of the title.
 */
- (NSArray *)getAblumPhotoArrayFromTitle:(NSString *)title;


/**
 *  Return a photo collection according to the keywords array.
 *  @param keywords The keywords array users want to search.
 *
 *  @return The photo collection contains the keywords.
 */
- (NSArray *)searchAlbumPhotosWithkeywords:(NSArray *)keywords;


/**
 *  Ask the manager to fetch photos from Flicker.
 *  @param callback The funtion user passed into, to manipluate the generated result.
 */
- (void)fetchFlickerPhotoWithCompletion:(void (^)(NSArray*result))callback;


/**
 *  Ask the manager to fetch photos from Instagram.
 *  @param callback The funtion user passed into, to manipluate the generated result.
 */
- (void)fetchInstagramPhotoWithCompletion:(void (^)(NSArray*result))callback;

@end
