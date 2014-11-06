//
//  PhotoTableViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "PhotoTableViewCell.h"

@interface PhotoTableViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation PhotoTableViewController

-(NSMutableArray*)photos
{
    if (!_photos) {
        self.photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}


-(void)setAssetGroup:(ALAssetsGroup *)assetGroup
{
    _assetGroup = assetGroup;
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:NO];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
    //[self.navigationItem setTitle:NSLocalizedString(@"Loading...", nil)];
    
    //[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
//        self.columns = 4;
//    }
    NSInteger numRows = ceil([self.photos count] / (float)self.columns);
    return numRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAssets:[self assetsForIndexPath:indexPath]];

    return cell;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.photos count] - index);
    return [self.photos subarrayWithRange:NSMakeRange(index, length)];
}

- (void)preparePhotos
{
    [self.photos removeAllObjects];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return;
        }
        [self.photos addObject:result];
        
    }];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}



@end
