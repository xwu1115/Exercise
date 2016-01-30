//
//  PPLDetailInformationView.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/30/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewDelegate

- (void)handleExitButtonPressed;

@end

@interface PPLDetailInformationView : UIView

@property (nonatomic) BOOL isInfoHidden;
@property (nonatomic, weak) id<DetailViewDelegate>delegate;

@end
