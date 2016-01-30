//
//  PPLTableViewCell.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/29/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLCollectionViewCell.h"

@interface PPLCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PPLCollectionViewCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

@end
