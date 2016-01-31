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
    self.isInfoHidden = YES;
    self.exitButton = [[UIButton alloc] init];
    //self.exitButton.backgroundColor = [UIColor redColor];
    [self.exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitButton];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.locationLabel setText: @""];
    [self setupLabel:self.locationLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setText: @""];
    [self setupLabel:self.timeLabel];
}

- (void)setupLabel:(UILabel *)label
{
    [label setTextColor:[UIColor whiteColor]];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

- (void)updateConstraints
{
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(10);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(250));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(200));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.locationLabel.mas_bottom).offset(5);
    }];
    
    [super updateConstraints];
}

- (void)handleButtonPress:(id)sender
{
    [self.delegate handleExitButtonPressed];
}

@end
