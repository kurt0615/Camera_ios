//
//  PhotoVo.h
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoVo;

@protocol PhotoVoDelegate <NSObject>
-(BOOL)photoSelected:(Boolean)selected WithPhoto:(PhotoVo*)photoVo;
@end

@interface PhotoVo : NSObject
@property (nonatomic, strong) ALAsset *photoALAsset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSURL *photoUrl;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, weak) id<PhotoVoDelegate> photoVoDelegate;
-(instancetype)initWithPhoto:(ALAsset *)photo Selected:(BOOL)select;
@end
