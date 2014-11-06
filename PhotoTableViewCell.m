//
//  PhotoTableViewCell.m
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoTableViewCell ()
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;
@end

@implementation PhotoTableViewCell

- (void)setAssets:(NSArray *)assets
{
    _assets = assets;
}

-(void)layoutSubviews
{
    CGRect frame = CGRectMake(5, 4, 80, 80);
    
    for (int i = 0; i < self.assets.count; ++i) {
        ALAsset *aLAsset = [self.assets objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:aLAsset.thumbnail]];
        [imageView setFrame:frame];
        [self addSubview:imageView];
        frame.origin.x = frame.origin.x + frame.size.width + 5;
    }
}

@end
