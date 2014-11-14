//
//  SelectionDelegate.h
//  camera
//
//  Created by Kurt Yang on 2014/11/6.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

@class PhotoVo;
@protocol SelectionDelegate <NSObject>
-(BOOL)shouldSelect:(PhotoVo*)photos WithCounts:(NSInteger)count;
-(BOOL)shouldDeSelect:(PhotoVo*)photos WithCounts:(NSInteger)count;
-(void)didSelected;
@end
