//
//  PPLHelper.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLHelper.h"

@implementation PPLHelper

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:35.0/255.0 green:50.0/255.0 blue:73.0/255.0 alpha:1];
}

+ (UIFont *)pplLightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"VisbyCF-Light" size:size];
}

+ (UIFont *)pplMediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"VisbyCF-Medium" size:size];
}
@end
