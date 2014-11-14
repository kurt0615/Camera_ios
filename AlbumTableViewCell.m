//
//  AlbumTableViewCell.m
//  camera
//
//  Created by Kurt Yang on 2014/11/7.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.selectedCount.frame;
    frame.origin.x = self.contentView.frame.size.width - 45;
    [self.selectedCount setFrame:frame];
}
@end
