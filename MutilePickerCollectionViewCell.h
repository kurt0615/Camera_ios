//
//  MutilePickerCollectionViewCell.h
//  camera
//
//  Created by Kurt Yang on 2014/11/12.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoVo.h"

@interface MutilePickerCollectionViewCell : UICollectionViewCell
@property id act;
- (void)setAssets:(UIImage *)photo;
@end
