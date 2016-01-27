//
//  PPLImageCollection.m
//  PayPalGallery
//
//  Created by Shawn Wu on 1/25/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

#import "PPLPhotoCollection.h"

@implementation PPLPhotoCollection

- (void)addMedia:(id)item
{
    if(self.mediaData == nil){
        self.mediaData = [NSMutableArray array];
    }
    
    [self.mediaData addObject:[self parseMeidaData:item]];
}

- (PPLObject *)parseMeidaData:(id)item
{
    PPLObject *parsedItem;
    if ([item isKindOfClass:[PHAsset class]]) {
        
    }
    else {
        parsedItem = item;
    }
    return parsedItem;
}

@end
