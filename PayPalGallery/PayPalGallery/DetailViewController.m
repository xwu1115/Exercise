//
//  DetailView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isInfoHidden;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureForImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self displayImage];
    self.isInfoHidden = true;
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
    if (self.isInfoHidden == YES) {
        [self showInformation];
        self.isInfoHidden = NO;
    }else{
        [self hideInformation];
        self.isInfoHidden = YES;
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
@end
