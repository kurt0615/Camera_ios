//
//  AlbumTableViewController.h
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionDelegate.h"

@protocol AlbumDelegate <NSObject>
-(void)didFinishWithPhotos:(NSMutableDictionary*)selectedPhotosAll;
@end

@interface AlbumTableViewController : UITableViewController <SelectionDelegate>
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, weak) id <AlbumDelegate> albumDelegate;
@property (nonatomic) NSInteger maximaCount;
@property (nonatomic, strong) NSMutableDictionary *selectedPhotosAll;
@end
