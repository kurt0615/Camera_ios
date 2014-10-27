//
//  ScaleableIVToolbar.m
//  camera
//
//  Created by Kurt Yang on 2014/10/27.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "ScaleableIVToolbar.h"

@interface ScaleableIVToolbar ()
@property (strong, nonatomic) UIBarButtonItem *confirmBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *deleteBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *takephotoBarButtonItem;
@end

@implementation ScaleableIVToolbar

-(void)setup
{
    NSArray *barItems = [NSArray arrayWithObjects:
                         self.takephotoBarButtonItem,
                         self.deleteBarButtonItem,
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
                         self.confirmBarButtonItem,
                         nil];
    self.items = barItems;
}

-(void)awakeFromNib
{
    [self setup];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)confirmBarButtonItemAction
{
    [self.confirmBarButtonItemAct invoke];
}

-(UIBarButtonItem *)confirmBarButtonItem{
    if (!_confirmBarButtonItem) {
        _confirmBarButtonItem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"確定"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(confirmBarButtonItemAction)];
    }
    return _confirmBarButtonItem;
}

-(void)deleteBarButtonItemAction
{
    [self.deleteBarButtonItemAct invoke];
}

-(UIBarButtonItem *)deleteBarButtonItem{
    if (!_deleteBarButtonItem) {
        _deleteBarButtonItem = [[UIBarButtonItem alloc]
                                initWithTitle:@"刪除"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(deleteBarButtonItemAction)];
    }
    return _deleteBarButtonItem;
}

-(void)takephotoBarButtonItemAction
{
    [self.takephotoBarButtonItemAct invoke];
}

-(UIBarButtonItem *)takephotoBarButtonItem{
    if (!_takephotoBarButtonItem) {
        _takephotoBarButtonItem = [[UIBarButtonItem alloc]
                                   initWithTitle:@"重拍"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(takephotoBarButtonItemAction)];
    }
    return _takephotoBarButtonItem;
}
@end
