//
//  PPLDetailImageView.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLPhotoManager.h"

@protocol PPLDetailImageViewDelegate

- (void)handleImageViewTapped;
- (void)handleImageViewChanged:(NSInteger)index;

@end

@interface PPLDetailImageView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<PPLDetailImageViewDelegate>delegate;

- (instancetype)initWith:(NSArray *)selectedAssets photo:(PPLObject *)selectedPhoto manager:(PPLPhotoManager *)manager;
- (void)setup;
@end
