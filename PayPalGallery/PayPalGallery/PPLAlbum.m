//
//  PPLAlbum.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLAlbum.h"

@implementation PPLAlbum

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count photo:(PPLObject *)photo
{
    self = [super init];
    if (self) {
        _title = title;
        _count = count;
        _albumPhoto = photo;
    }
    return self;
}

@end
