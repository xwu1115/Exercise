//
//  PPLMediaItem.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLObject.h"

@implementation PPLObject
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height location:(CLLocation *)location date:(NSDate *)creationDate url:(NSString *)url
{
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _location = location;
        _creationDate = creationDate;
        _url = url;
    }
    return self;
}



@end
