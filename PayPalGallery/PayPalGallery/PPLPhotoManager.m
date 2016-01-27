//
//  PPLPhotoManager.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoManager.h"
#import "PPLPhotoConverter.h"

@interface PPLPhotoManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) id selectedItem;
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
    self.imageManager = [[PHCachingImageManager alloc] init];
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
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];

    [self saveCollectionResult:smartAlbums toDictionary:dictionary];
    [self saveCollectionResult:topLevelUserCollections toDictionary:dictionary];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)saveCollectionResult:(PHFetchResult *)result toDictionary:(NSMutableDictionary *)dictionary
{
    for (PHCollection *collection in result) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        [dictionary setObject:assetResult forKey:collection.localizedTitle];
    }
}

- (void)displayPhoto:(id)item size:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback
{
    [PPLPhotoConverter imageWith:item size:size manager:self.imageManager completion:callback];
}

- (void)displaySelectedItemWithSize:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback
{
    if (self.selectedItem == nil) {
        return;
    } else {
        [self displayPhoto:self.selectedItem size:size completion:callback];
    }
}

- (void)setCurrentSelectedItem:(id)item
{
    self.selectedItem = item;
}

- (void)setSelectedItem:(id)selectedItem
{
    if (selectedItem != _selectedItem) {
        _selectedItem = selectedItem;
    }
}
#pragma mark PHPhotoLibraryChangeObserver Methods

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    
}

@end
