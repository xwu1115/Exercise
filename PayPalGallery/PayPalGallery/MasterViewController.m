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

static NSString* CellReuseIdentifier = @"ppl";

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) PPLPhotoManager *manager;
@property (nonatomic, strong) NSArray *selectedAssets;
@property (nonatomic, weak) UICollectionView *gridView;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[PPLPhotoManager alloc] init];
    NSLog(@"%@", self.manager);
    self.selectedAssets = [self.manager.assetCollections objectForKey:@"AllPhotos"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detail"])
    {
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.manager = self.manager;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    id item = [self.selectedAssets objectAtIndex:indexPath.item];

    [self.manager displayPhoto:item size:CGSizeMake(100, 100) completion:^(UIImage *result, NSDictionary *info) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:result];
        
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    [self.manager setCurrentSelectedItem: [self.selectedAssets objectAtIndex:indexPath.item]];
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

@end
