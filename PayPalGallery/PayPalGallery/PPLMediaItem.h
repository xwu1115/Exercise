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
enum {
    video = 0,
    photo = 1
};
typedef NSInteger Type;//check grammar

@interface PPLMediaItem : NSObject

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSDate *creationDate;
@property Type type;


@end
