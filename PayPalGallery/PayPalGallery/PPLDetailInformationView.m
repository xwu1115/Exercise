//
//  PPLDetailInformationView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLDetailInformationView.h"
#import "Masonry.h"
#import "PPLHelper.h"

static NSString * const locationImgIdentifer = @"map";
static NSString * const timeImgIdentifer = @"time";

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
    self.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:22.0/255.0  blue:22.0/255.0 alpha:0.5];
    self.isInfoHidden = YES;
    self.exitButton = [[UIButton alloc] init];
    //self.exitButton.backgroundColor = [UIColor redColor];
    [self.exitButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitButton];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.locationLabel setText: @""];
    [self setupLabel:self.locationLabel size:20.0f];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.timeLabel setText: @""];
    [self setupLabel:self.timeLabel size:12.0f];
    
    self.locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:locationImgIdentifer]];
    self.locationIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.locationIcon];
    
    self.timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:timeImgIdentifer]];
    self.timeIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.timeIcon];
}

- (void)setupLabel:(UILabel *)label size:(CGFloat)size
{
    [label setTextColor:[UIColor whiteColor]];
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[PPLHelper pplLightFontWithSize:size]];

    [self addSubview:label];
}

- (void)updateConstraints
{
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(10);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(250));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(125));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.locationLabel.mas_bottom).offset(15);
    }];
    
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(15));
        make.width.equalTo(@(15));
        make.right.equalTo(self.locationLabel.mas_left).offset(-10);
        make.top.equalTo(self.locationLabel.mas_top).offset(5);
    }];
    
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(15));
        make.width.equalTo(@(15));
        make.right.equalTo(self.timeLabel.mas_left).offset(5);
        make.top.equalTo(self.timeLabel.mas_top);
    }];
    
    [super updateConstraints];
}

- (void)handleButtonPress:(id)sender
{
    [self.delegate handleExitButtonPressed];
}

@end
