//
//  PPLAlbumTableViewCell.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLAlbumTableViewCell.h"

@implementation PPLAlbumTableViewCell

- (void)setIcon:(UIImageView *)icon{
    if (_icon != icon) {
        _icon = icon;
        _icon.layer.cornerRadius = 5;
        _icon.clipsToBounds = YES;
    }
}

- (void)setTitle:(UILabel *)title
{
    if(_title != title) {
        _title = title;
        [_title setFont: [UIFont fontWithName:@"VisbyCF-Light" size:18.0]];
    }
}

- (void)setCount:(UILabel *)count
{
    if(_count != count) {
        _count = count;
        [_count setFont: [UIFont fontWithName:@"VisbyCF-Light" size:15.0]];
    }
}

@end
