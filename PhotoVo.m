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
        _photoALAsset = photo;
        _selected = select;
        _thumbnail = [[UIImage alloc]initWithCGImage:photo.thumbnail];
        _photoUrl = photo.defaultRepresentation.url;
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
