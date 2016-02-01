//
//  PPLAlbum.h
//  PayPalGallery
//
//  Created by Shawn Wu on 1/31/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLObject.h"

@interface PPLAlbum : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSDate *lastTimeUpdated;
@property (nonatomic, strong) PPLObject *albumPhoto;

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count photo:(PPLObject *)photo;

@end
