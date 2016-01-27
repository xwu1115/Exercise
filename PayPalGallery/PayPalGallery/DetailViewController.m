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
@end
@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.manager);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self displayImage];
}

- (void)displayImage
{
    [self.manager displaySelectedItemWithSize:CGSizeMake(300, 500) completion:^(UIImage *result, NSDictionary *info) {
        self.imageView.image = result;
    }];
}

@end
