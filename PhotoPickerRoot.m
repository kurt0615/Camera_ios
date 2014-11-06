//
//  PhotoPickerRoot.m
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoPickerRoot.h"
#import "AlbumTableViewController.h"
@interface PhotoPickerRoot ()

@end

@implementation PhotoPickerRoot

- (id)initImagePicker
{
    AlbumTableViewController *albumPicker = [[AlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self = [super initWithRootViewController:albumPicker];
    return self;
}

-(id)init
{
    self = [self initImagePicker];
    return self;
}

- (void)cancelImagePicker
{
    NSLog(@"abc");
}

@end
