//
//  PPLImageCollection.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLObject.h"
@import Photos;

@interface PPLPhotoCollection : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *mediaData;

- (void)addMedia:(id)item;

@end
