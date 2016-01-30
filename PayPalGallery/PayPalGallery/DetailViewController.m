//
//  DetailView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "DetailViewController.h"
#import "PPLDetailInformationView.h"

#import "Masonry.h"

@interface DetailViewController()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) PPLDetailInformationView *detailView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureForImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.detailView = [[PPLDetailInformationView alloc] init];
    [self.view addSubview:self.detailView];
    [self autoLayouts];
    [self displayImage];
}

- (void)displayImage
{
    CGFloat height = self.imageView.frame.size.height;
    CGFloat width = self.imageView.frame.size.width;
    
    [self.manager displaySelectedItemWithSize:CGSizeMake(width, height) completion:^(UIImage *result, NSDictionary *info) {
        self.imageView.image = result;
    }];
}

- (void)setupGestureForImageView
{
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleSwipe:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeLeftRecognizer];

    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleSwipe:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeRightRecognizer];

}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.detailView.isInfoHidden == YES) {
        [self showInformation];
        self.detailView.isInfoHidden = NO;
    }else{
        [self hideInformation];
        self.detailView.isInfoHidden = YES;
    }
}

- (void)showInformation
{
    
}

- (void)hideInformation
{
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self.manager navigateSelectedItemToNext];
    }
    else
    {
        [self.manager navigateSelectedItemToPrevious];
    }
    [self displayImage];
}

- (void)autoLayouts
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(200));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end
