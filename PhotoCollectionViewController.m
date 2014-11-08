//
//  PhotoCollectionViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/11/5.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation PhotoCollectionViewController

-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

-(void)setAssetGroup:(ALAssetsGroup *)assetGroup
{
    _assetGroup = assetGroup;
}

-(NSMutableArray*)selectedPhotos
{
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    [self.collectionView setAllowsSelection:NO];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    [self.navigationItem setRightBarButtonItem:doneButtonItem];
}

-(void)doneAction:(id)sender
{
    if ([self.selectionDelegate respondsToSelector:@selector(didSelected:)]) {
        [self.selectionDelegate didSelected:self.selectedPhotos];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setAssets:[self.photos objectAtIndex:indexPath.row]];
    return cell;
}


- (void)preparePhotos
{
    [self.photos removeAllObjects];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result == nil) {
            return;
        }
        
        BOOL selected = NO;
        
        if (self.selectedPhotos) {
            for (PhotoVo *obj in self.selectedPhotos) {
                if ([[[[obj.photo defaultRepresentation]url] absoluteString]
                     isEqualToString:[[[result defaultRepresentation]url] absoluteString]]) {
                    selected = YES;
                    [self.selectedPhotos removeObject:obj];
                    break;
                }
            }
        }
        
        PhotoVo *photoVo  = [[PhotoVo alloc] initWithPhoto:result Selected:selected];
        photoVo.PhotoVoDelegate = self;
        
        //add selected photo to selection list
        if (selected) {
            [self.selectedPhotos addObject:photoVo];
        }
        [self.photos addObject:photoVo];
    }];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self setTitleCount];
        [self.collectionView reloadData];
    });
}

#pragma photVoDelegate impl.
-(BOOL)photoSelected:(Boolean)selected WithPhoto:(PhotoVo *)photoVo
{
    if (selected) {
        if ([self.selectionDelegate respondsToSelector:@selector(shouldSelect:WithCounts:)]) {
            if ([self.selectionDelegate shouldSelect:photoVo WithCounts:self.selectedPhotos.count]) {
            }else{
                return NO;
            }
        }
    }else{
        if ([self.selectionDelegate respondsToSelector:@selector(shouldDeSelect:WithCounts:)]) {
            if ([self.selectionDelegate shouldDeSelect:photoVo WithCounts:self.selectedPhotos.count]) {
            }
        }else {
            return NO;
        }
    }
    
    [self setTitleCount];

    
    return YES;
}

-(void)setTitleCount
{
    if (self.selectedPhotos.count == 0) {
        self.title = [[NSString alloc]initWithFormat:@"%@", [self.assetGroup valueForProperty:ALAssetsGroupPropertyName]];
    }else{
        self.title = [[NSString alloc]initWithFormat:@"%@ (已選擇%ld)", [self.assetGroup valueForProperty:ALAssetsGroupPropertyName],self.selectedPhotos.count];
    }
}


@end
