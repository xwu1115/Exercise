//
//  PPLAlbumTableViewCell.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLAlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *count;
@property (nonatomic, weak) IBOutlet UIImageView *icon;

@end
