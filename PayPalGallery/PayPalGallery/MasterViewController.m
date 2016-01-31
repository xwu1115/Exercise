//
//  ViewController.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AlbumViewController.h"

#import "PPLCollectionViewCell.h"

static CGFloat const thumbnailWidth = 100.0f;
static CGFloat const thumbnailHeight = 100.0f;

static NSString* const cellReuseIdentifier = @"ppl";
static NSString* const detailSegueIdentifier = @"detail";
static NSString* const defaultGalleryIdentifier = @"AllPhotos";


@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *selectedAssets;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.galleryIdentifier == nil) {
        self.galleryIdentifier = defaultGalleryIdentifier;
    }
}

- (void)loadDataWith:(NSString *)galleryIdentifier
{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        if(self.manager == nil) {
            self.manager = [[PPLPhotoManager alloc] init];
        }
        //self.selectedAssets = [self.manager getAssetFromIdentifier:galleryIdentifier];
        self.selectedAssets = [self.manager getAblumPhotoArrayFromTitle:galleryIdentifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gridView reloadData];
        });
    });
}

- (void)setGalleryIdentifier:(NSString *)galleryIdentifier
{
    if(_galleryIdentifier != galleryIdentifier)
    {
        _galleryIdentifier = galleryIdentifier;
        [self loadDataWith:_galleryIdentifier];
    }
}


#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:detailSegueIdentifier])
    {
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.manager = self.manager;
        detailViewController.selectedAsset = self.selectedAssets;
        detailViewController.selectedItem = sender;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selectedAssets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    PPLObject *item = [self.selectedAssets objectAtIndex:indexPath.item];

    [self.manager displayPhoto:item size:CGSizeMake(thumbnailWidth, thumbnailHeight) completion:^(UIImage *result, NSDictionary *info) {
        cell.thumbnailImage = result;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPLObject *cur = [self.selectedAssets objectAtIndex:indexPath.item];
    [self performSegueWithIdentifier:detailSegueIdentifier sender:cur];
}

@end
