//
//  CollectionViewCell.m
//  camera
//
//  Created by Kurt Yang on 2014/10/21.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self.act invoke];
    }
}
@end
