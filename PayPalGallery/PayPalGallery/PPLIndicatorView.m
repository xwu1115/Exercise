//
//  PPLIndicatorView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLIndicatorView.h"
#import "Masonry.h"

@interface PPLIndicatorView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation PPLIndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor darkTextColor];
        self.alpha = 0.6;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        self.indicator = [[UIActivityIndicatorView alloc]init];
        [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)start
{
    [self.indicator startAnimating];
}

- (void)stop
{
    [self.indicator stopAnimating];
    self.alpha = 0;
    
}

- (void)updateConstraints
{
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    [super updateConstraints];
}

@end
