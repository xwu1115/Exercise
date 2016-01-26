//
//  PPLMediaItem.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLMediaItem.h"

@implementation PPLMediaItem
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height filename:(NSString *)filename date:(NSDate *)creationDate
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _filename = filename;
        _creationDate = creationDate;
    }
    return self;
}



@end
