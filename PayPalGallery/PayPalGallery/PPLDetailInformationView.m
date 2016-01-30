//
//  PPLDetailInformationView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLDetailInformationView.h"

@implementation PPLDetailInformationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIButton *exitButton = [[UIButton alloc] init];
    [self addSubview:exitButton];
    
    UILabel *location = [[UILabel alloc] init];
    [self addSubview:location];
    
    UILabel *time = [[UILabel alloc] init];
    [self addSubview:time];
    
    [self setupLayout];
}

- (void)setupLayout
{
    
}

@end
