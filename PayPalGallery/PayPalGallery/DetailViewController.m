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

static NSString *timeFormat = @"MMM d yyyy HH:mm";

@interface DetailViewController()<DetailViewDelegate>

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
    self.detailView.delegate = self;
    self.detailView.alpha = 0;
    [self.view addSubview:self.detailView];
    [self displayImage];
}

- (void)displayImage
{
    CGFloat height = self.imageView.frame.size.height;
    CGFloat width = self.imageView.frame.size.width;
    
    [self.manager displaySelectedItemWithSize:CGSizeMake(width, height) completion:^(UIImage *result, NSDictionary *info) {
        self.imageView.image = result;
    }];
    
    [self.manager locationNameUpdatedWithSelectedPhotoAndCompletion:^(NSString *result) {
        [self.detailView.locationLabel setText:result];
    }];
    
    [self.manager creationTimeFromSelectedPhotoAndFormat:timeFormat completion:^(NSString *result) {
        [self.detailView.timeLabel setText:result];
    }];
}

- (void)updateViewConstraints
{
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(120));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
 
    [super updateViewConstraints];
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
        [self setInformationDetailViewAlpha:1];
    }else{
        [self setInformationDetailViewAlpha:0];
    }
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

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    //TODO: use photo gallery way to implment it soon.
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

#pragma mark PPLDetailInformationViewDelegate Methods

- (void)handleExitButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
