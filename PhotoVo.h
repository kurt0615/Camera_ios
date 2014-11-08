//
//  PhotoVo.h
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoVo;

@protocol PhotoVoDelegate <NSObject>
-(BOOL)photoSelected:(Boolean)selected WithPhoto:(PhotoVo*)photoVo;
@end

@interface PhotoVo : NSObject
@property (nonatomic, strong) ALAsset *photo;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<PhotoVoDelegate> photoVoDelegate;
-(instancetype)initWithPhoto:(ALAsset *)photo Selected:(BOOL)select;
@end
