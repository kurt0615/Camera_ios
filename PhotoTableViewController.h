//
//  PhotoTableViewController.h
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoTableViewController : UITableViewController
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, assign) int columns;
@end
