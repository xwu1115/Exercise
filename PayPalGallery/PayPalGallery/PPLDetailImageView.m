//
//  PPLDetailImageView.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLDetailImageView.h"
#import "Masonry.h"

const int NUMBER_OF_IMAGE = 10;

@interface PPLDetailImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic) NSInteger previousPage;
@property (nonatomic) NSInteger currentItemIndex;

@property (nonatomic, weak) PPLPhotoManager *manager;
@property (nonatomic, weak) NSArray *selectedAssets;
@property (nonatomic, weak) PPLObject *selectedPhoto;

@end

@implementation PPLDetailImageView

- (instancetype)initWith:(NSArray *)selectedAssets photo:(PPLObject *)selectedPhoto manager:(PPLPhotoManager *)manager
{
    self = [super init];
    if (self) {
        [super awakeFromNib];
        _selectedAssets = selectedAssets;
        _selectedPhoto = selectedPhoto;
        _manager = manager;
    }
    return self;
}

- (void)setup
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.scrollView = [[UIScrollView alloc] init];
    //self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.contentSize = CGSizeMake(width * NUMBER_OF_IMAGE, height);
    [self addSubview:self.scrollView];
    
    self.scrollView.pagingEnabled = YES;
    [self updateConstraints];
    
    self.imageViewArray = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < NUMBER_OF_IMAGE; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [self.imageViewArray addObject:view];
        [self.scrollView addSubview:view];
    }
    
    [self loadVisibleImages];
    [self setupGestureForImageView];
    
    self.scrollView.delegate = self;
}

- (void)setupGestureForImageView
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.delegate handleImageViewTapped];
}

- (void)loadVisibleImages
{
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.currentItemIndex = [self.selectedAssets indexOfObject:self.selectedPhoto];
    NSUInteger index = self.currentItemIndex;
    if(index == -1) return;
    
    for(int i = 0; i < NUMBER_OF_IMAGE && index < [self.selectedAssets count]; i++){
        PPLObject *obj = [self.selectedAssets objectAtIndex:index++];
        [self.manager displayPhoto:obj size:size completion:^(UIImage *result, NSDictionary *info) {
            UIImageView *view = [self.imageViewArray objectAtIndex:i];
            view.image = result;
        }];
    }
}

- (void)updateConstraints
{
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(self.mas_top);
    }];
    
    [super updateConstraints];
}

/* add another series of functions to deal with large amount of images case*/

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= [self.selectedAssets count]) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIImageView *pageView = [self.imageViewArray objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.imageViewArray replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= [self.selectedAssets count]) {
        return;
    }
    
    UIView *pageView = [self.imageViewArray objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] init];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        
        [self.manager displayPhoto:[self.selectedAssets objectAtIndex:0] size:frame.size completion:^(UIImage *result, NSDictionary *info) {
            newPageView.image = result;
        }];

        [self.imageViewArray replaceObjectAtIndex:page withObject:newPageView];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(self.previousPage == page) return;
    
    [self.delegate handleImageViewChanged:self.currentItemIndex++];
    self.previousPage = page;
}

@end
