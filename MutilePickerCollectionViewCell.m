//
//  MutilePickerCollectionViewCell.m
//  camera
//
//  Created by Kurt Yang on 2014/11/12.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "MutilePickerCollectionViewCell.h"
@interface MutilePickerCollectionViewCell ()
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImageView *photoView;
@end
@implementation MutilePickerCollectionViewCell

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self.act invoke];
    }
}

- (void)setAssets:(PhotoVo *)photoVo;
{
    _photo = photoVo.thumbnail;
    
    if (self.photoView) {
        [self.photoView removeFromSuperview];
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(75, 75));
    [self.photo drawInRect:CGRectMake(0, 0, 75, 75)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.photoView = [[UIImageView alloc] initWithImage:resizeImage];
    [self.photoView setContentMode:UIViewContentModeScaleAspectFit];
    CGRect frame = self.photoView.frame;
    frame.size = self.frame.size;
    [self.photoView setFrame:frame];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self addSubview:self.photoView];
}
@end
