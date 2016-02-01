//
//  DetailView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "DetailViewController.h"
#import "PPLDetailInformationView.h"
#import "PPLDetailImageView.h"

#import "Masonry.h"

static NSString * const timeFormat = @"MMM d yyyy HH:mm";

@interface DetailViewController()<DetailViewDelegate, PPLDetailImageViewDelegate>

@property (nonatomic, strong)  PPLDetailImageView *imageView;
@property (nonatomic, strong) PPLDetailInformationView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView = [[PPLDetailImageView alloc] initWith:self.selectedAsset photo:self.selectedItem manager:self.manager];
    self.imageView.delegate = self;
    [self.view addSubview:self.imageView];
    
    self.detailView = [[PPLDetailInformationView alloc] init];
    self.detailView.delegate = self;
    self.detailView.alpha = 0;
    [self.view addSubview:self.detailView];
    
    NSInteger currentIndex = [self.selectedAsset indexOfObject:self.selectedItem];
    [self updateLocationAndTimeLabelsWithIndex:currentIndex];
}

- (void)viewDidLayoutSubviews
{
    if(self.imageView.scrollView == nil){
        [self.imageView setup];
    }
}

- (void)updateViewConstraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];

    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(120));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
 
    [super updateViewConstraints];
}

- (void)setInformationDetailViewAlpha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.3 animations:^{
        self.detailView.alpha = alpha;
    } completion:^(BOOL finished) {
        if(alpha == 1){
            self.detailView.isInfoHidden = NO;
        }else{
            self.detailView.isInfoHidden = YES;
        }
    }];
}

#pragma mark PPLDetailInformationViewDelegate Methods

- (void)handleExitButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PPLDetailImageViewDelegate Methods

- (void)handleImageViewTapped
{
    if (self.detailView.isInfoHidden == YES) {
        [self setInformationDetailViewAlpha:1];
    }else{
        [self setInformationDetailViewAlpha:0];
    }
}

- (void)handleImageViewChanged:(NSInteger)index
{
    [self updateLocationAndTimeLabelsWithIndex:index];
}

- (void)updateLocationAndTimeLabelsWithIndex:(NSInteger)index
{
    [self.manager locationNameUpdatedWithPhoto:[self.selectedAsset objectAtIndex:index] completion:^(NSString *result) {
        [self.detailView.locationLabel setText:result];
    }];
    
    [self.manager creationTimeFromPhoto:[self.selectedAsset objectAtIndex:index] format:timeFormat completion:^(NSString *result) {
        [self.detailView.timeLabel setText:result];
    }];
}

@end
