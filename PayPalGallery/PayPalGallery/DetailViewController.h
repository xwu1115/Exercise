//
//  DetailView.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLPhotoManager.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) PPLPhotoManager *manager;
@property (nonatomic, strong) NSArray *selectedAsset;
@property (nonatomic, strong) PPLObject *selectedItem;
@end
