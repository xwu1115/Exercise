//
//  ViewController.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPLPhotoManager.h"

@interface MasterViewController : UIViewController

@property (nonatomic, strong) NSString *galleryIdentifier;
@property (nonatomic, strong) PPLPhotoManager *manager;

@end

