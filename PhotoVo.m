//
//  PhotoVo.m
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoVo.h"

@interface PhotoVo ()
@end

@implementation PhotoVo
-(instancetype)initWithPhoto:(ALAsset *)photo Selected:(BOOL)select;
{
    self = [super init];
    if (self) {
        _photo = photo;
        _selected = select;
    }
    return self;
}


-(void)setSelected:(BOOL)selected
{
    if ([self.photoVoDelegate respondsToSelector:@selector(photoSelected:WithPhoto:)]) {
        if ([self.photoVoDelegate photoSelected:selected WithPhoto:self]) {
            _selected = selected;
        }
    }
}

@end
