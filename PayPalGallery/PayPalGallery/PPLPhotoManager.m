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
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self loadData];
    }
    return self;
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)loadData
{
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
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
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
        if([collection count] == 0)continue;
        
        PHAsset *set = [collection firstObject];
        PPLObject *albumPhoto = [PPLPhotoConverter convert:set];
        PPLAlbum *curAlbum = [[PPLAlbum alloc] initWithTitle:key count:[collection count] photo:albumPhoto];
        curAlbum.lastTimeUpdated = albumPhoto.creationDate;
        [result addObject:curAlbum];
    }
    return [self sortByDate:result];
}

- (NSArray *)sortByDate:(NSMutableArray *)arr
{
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(PPLAlbum *obj1, PPLAlbum *obj2) {
        NSDate *d1 = obj1.lastTimeUpdated;
        NSDate *d2 = obj2.lastTimeUpdated;
        return [d2 compare: d1];
    }];
    return sortedArr;
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

- (NSArray *)searchAlbumPhotosWithkeywords:(NSArray *)keywords
{
    NSArray *array = [NSArray array];
    //TODO: Add the search main methods here.
    return  array;
}


#pragma mark PHPhotoLibraryChangeObserver Methods

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    [self.delegate handlePhotoChanged];
}


#pragma mark - Web Data Methods


- (void)fetchFlickerPhotoWithCompletion:(void (^)(NSArray *data))callback
{
    //TODO: Add method to handle web data.
}

- (void)fetchInstagramPhotoWithCompletion:(void (^)(NSArray *result))callback;{
    //Instagram recently updated its API endpoints, this method is no longer working.
    
    if ((BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:instagramIndentifier] == NO) {
        [self.delegate handleOauthLogin];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:instagramIndentifier];
    }
    [PPLInstagPhotoHelper fetchInstagramPhotoWithCompletion:callback];
}

@end
