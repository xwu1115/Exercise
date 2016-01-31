//
//  PPLMediaItem.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Photos;

@interface PPLObject : NSObject

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) PHAsset *asset;

@end
