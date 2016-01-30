//
//  PPLDetailInformationView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLDetailInformationView.h"
#import "Masonry.h"

@interface PPLDetailInformationView ()

@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

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
    self.exitButton = [[UIButton alloc] init];
    [self.exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitButton];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.locationLabel setText: @"Location"];
    [self addSubview:self.locationLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    [self addSubview:self.timeLabel];
}

- (void)updateConstraints
{
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        make.top.equalTo(self.mas_top).offset(-50);
        make.right.equalTo(self.mas_right).offset(-50);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(100));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(100));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.locationLabel.mas_bottom).offset(10);
    }];
    
    [super updateConstraints];
}

- (void)handleButtonPress:(id)sender
{
    [self.delegate handleExitButtonPressed];
}

@end
