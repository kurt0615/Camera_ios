//
//  PhotoCollectionViewController.h
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoVo.h"
#import "SelectionDelegate.h"

@interface PhotoCollectionViewController : UICollectionViewController <PhotoVoDelegate>
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, weak) id <SelectionDelegate> selectionDelegate;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@end
