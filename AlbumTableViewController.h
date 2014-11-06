//
//  AlbumTableViewController.h
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionDelegate.h"

@interface AlbumTableViewController : UITableViewController <SelectionDelegate>
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, weak) id <SelectionDelegate> selectionDelegate;
@property (nonatomic) NSInteger maximaCount;
@end
