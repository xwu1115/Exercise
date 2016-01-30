//
//  PPLPhotoManager.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoManager.h"
#import "PPLPhotoConverter.h"

#import "PPLInstagPhotoHelper.h"

@import CoreLocation;

@interface PPLPhotoManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, strong) NSArray *selectedAsset;

@end

@implementation PPLPhotoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self fetchInstagramPhoto];
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

- (NSArray *)getAssetFromIdentifier:(NSString *)indentifier
{
    self.selectedAsset = [self.assetCollections objectForKey:indentifier];
    return self.selectedAsset;
}

- (void)setSelectedAsset:(NSArray *)selectedAsset
{
    if(_selectedAsset != selectedAsset)
    {
        _selectedAsset = selectedAsset;
    }
}

- (void)setSelectedItem:(id)selectedItem
{
    if (selectedItem != _selectedItem) {
        _selectedItem = selectedItem;
    }
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

- (void)fetchInstagramPhoto
{
    if ((BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:@"instagram"] == NO) {
        [self.delegate handleOauthLogin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"instagram"];
    }
    [PPLInstagPhotoHelper fetchInstagramPhoto];
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

- (id)navigateSelectedItemToNext
{
    int index = (int)[self.selectedAsset indexOfObject:self.selectedItem]+1;
    if(index > [self.selectedAsset count]) return nil;
    else {
        self.selectedItem = [self.selectedAsset objectAtIndex:index];
        return self.selectedItem;
    }
}

- (id)navigateSelectedItemToPrevious
{
    int index = (int)[self.selectedAsset indexOfObject:self.selectedItem]-1;
    if(index < 0) return nil;
    else {
        self.selectedItem = [self.selectedAsset objectAtIndex:index];
        return self.selectedItem;
    }
}

- (CLLocation *)getLocationFromPhoto:(id)photo
{
    return [PPLPhotoConverter getLocationFromItem:photo];
}

- (void)locationNameUpdatedWithPhoto:(id)photo completion:(void (^)(NSString*result))callback
{
    CLLocation *location = [self getLocationFromPhoto:photo];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation: location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString * address = [placemark name];
            address = [address stringByAppendingString:@" "];
            address = ([placemark locality]== nil)?address:[address stringByAppendingString:[placemark locality]];
            callback(address);
        }
    }];
}

- (void)locationNameUpdatedWithSelectedPhotoAndCompletion:(void (^)(NSString*result))callback
{
    [self locationNameUpdatedWithPhoto:self.selectedItem completion:callback];
}

- (void)creationTimeFromPhoto:(id)photo format:(NSString*)format completion:(void (^)(NSString*result))callback
{
    NSDate *date = [PPLPhotoConverter getCreationTimeFromItem:photo];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    callback(stringFromDate);
}

- (void)creationTimeFromSelectedPhotoAndFormat:(NSString*)format completion:(void (^)(NSString*result))callback
{
    [self creationTimeFromPhoto:self.selectedItem format:format completion:callback];
}

#pragma mark PHPhotoLibraryChangeObserver Methods

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self.delegate handlePhotoChanged];
}

@end
