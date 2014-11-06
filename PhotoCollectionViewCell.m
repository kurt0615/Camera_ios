//
//  PhotoCollectionViewCell.m
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
@interface PhotoCollectionViewCell ()
@property (nonatomic, strong) PhotoVo *photoVo;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIImageView *overlayView;
@end

@implementation PhotoCollectionViewCell
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    self.photoVo.selected = !self.photoVo.selected;
    self.overlayView.hidden = !self.photoVo.selected;
}

- (void)setAssets:(PhotoVo *)photoVo
{
    _photoVo = photoVo;

    if (self.photoView) {
        [self.photoView removeFromSuperview];
    }
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
    }
    
    
    self.photoView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:self.photoVo.photo.thumbnail]];
    [self.photoView setContentMode:UIViewContentModeScaleAspectFit];
    CGRect frame = self.photoView.frame;
    frame.size = self.frame.size;
    [self.photoView setFrame:frame];
    
    self.overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckIcon.png"]];
    frame = self.overlayView.frame;
    frame.origin.x = self.frame.size.width - 30;
    frame.origin.y = self.frame.size.height - 30;
    frame.size = CGSizeMake(20, 20);
    [self.overlayView setFrame:frame];
    self.overlayView.hidden = !self.photoVo.selected;
}

-(void)layoutSubviews
{
    [self addSubview:self.photoView];
    [self addSubview:self.overlayView];
}
@end
