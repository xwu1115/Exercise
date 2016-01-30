//
//  ViewController.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "MasterViewController.h"
#import "PPLPhotoManager.h"
#import "DetailViewController.h"

#import "PPLCollectionViewCell.h"

static NSString* cellReuseIdentifier = @"ppl";
static NSString* segueIdentifier = @"detail";
static NSString* defaultGalleryIdentifier = @"AllPhotos";

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PPLPhotoManager *manager;
@property (nonatomic, strong) NSArray *selectedAssets;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[PPLPhotoManager alloc] init];
    self.selectedAssets = [self.manager getAssetFromIdentifier:defaultGalleryIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:segueIdentifier])
    {
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.manager = self.manager;
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
    id item = [self.selectedAssets objectAtIndex:indexPath.item];

    [self.manager displayPhoto:item size:CGSizeMake(120, 120) completion:^(UIImage *result, NSDictionary *info) {
        cell.thumbnailImage = result;
        
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.manager setCurrentSelectedItem: [self.selectedAssets objectAtIndex:indexPath.item]];
    [self performSegueWithIdentifier:segueIdentifier sender:nil];
}

@end
