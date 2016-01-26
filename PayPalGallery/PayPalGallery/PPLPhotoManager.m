//
//  PPLPhotoManager.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoManager.h"

@interface PPLPhotoManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end


@implementation PPLPhotoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)setup
{
    self.assetCollections = [self fetchLocalPhotoGallery];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (NSDictionary *)fetchLocalPhotoGallery
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [dictionary setObject:allPhotos forKey:@"AllPhotos"];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    for (PHCollection *collection in smartAlbums) {
        [dictionary setObject:collection forKey:collection.localizedTitle];
    }
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    ;
    for (PHCollection *collection in topLevelUserCollections) {
        [dictionary setObject:collection forKey:collection.localizedTitle];
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark PHPhotoLibraryChangeObserver Methods

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    
}

@end
