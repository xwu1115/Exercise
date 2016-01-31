//
//  PPLPhotoManager.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoManager.h"
#import "PPLPhotoConverter.h"
#import "PPLAlbum.h"

#import "PPLInstagPhotoHelper.h"
#import "PPLFlickerPhotoHelper.h"

@import CoreLocation;
@import AssetsLibrary;

static NSString * const allPhotosIndentifier = @"AllPhotos";
static NSString * const instagramIndentifier = @"instagram";

@interface PPLPhotoManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) NSDictionary *assetCollections;

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

- (NSArray *)getAssetFromIdentifier:(NSString *)indentifier
{
    return [self.assetCollections objectForKey:indentifier];
}

- (NSDictionary *)fetchLocalPhotoGallery
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [dictionary setObject:allPhotos forKey:allPhotosIndentifier];
    
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

- (void)displayPhoto:(PPLObject *)item size:(CGSize)size completion:(void (^)(UIImage *result, NSDictionary *info))callback
{
    [PPLPhotoConverter imageWith:item size:size manager:self.imageManager completion:callback];
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

- (void)creationTimeFromPhoto:(PPLObject *)photo format:(NSString*)format completion:(void (^)(NSString*result))callback
{
    NSDate *date = [PPLPhotoConverter getCreationTimeFromItem:photo];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    callback(stringFromDate);
}

- (CLLocation *)getLocationFromPhoto:(PPLObject *)photo
{
    return [PPLPhotoConverter getLocationFromItem:photo];
}

- (NSArray *)getAlbumCollection
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *key in self.assetCollections){
        NSArray *collection = [self.assetCollections objectForKey:key];
        PPLAlbum *curAlbum = [[PPLAlbum alloc] initWithTitle:key count:[collection count]];
        [result addObject:curAlbum];
    }
    return result;
}

/*Two methods about converting PHAsset to PPLObject, however, ALAssetLibray has been depcrecated in iOS 9.*/

- (NSArray *)getAblumPhotoArrayFromTitle:(NSString *)title
{
    NSArray *assetArr = [self getAssetFromIdentifier:title];
    return [self convertPHAssetCollection:assetArr];
}

- (NSArray *)convertPHAssetCollection:(NSArray *)collection
{
    NSMutableArray *result = [NSMutableArray array];
    for (PHAsset *item in collection) {
        PPLObject *obj =  [PPLPhotoConverter convert:item];
        if (obj != nil) {
            [result addObject:obj];
        }
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark PHPhotoLibraryChangeObserver Methods

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self.delegate handlePhotoChanged];
}


#pragma mark - Web Data Methods

//Instagram recently updated its API endpoints, this method is no longer working.

- (void)fetchFlickerPhoto
{
    //TODO: Add method to handle web data.
}

- (void)fetchInstagramPhoto
{
    if ((BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:instagramIndentifier] == NO) {
        [self.delegate handleOauthLogin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:instagramIndentifier];
    }
    [PPLInstagPhotoHelper fetchInstagramPhoto];
}

@end
