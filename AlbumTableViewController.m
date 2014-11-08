//
//  AlbumTableViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "PhotoTableViewController.h"
#import "PhotoCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AlbumTableViewCell.h"

@interface AlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSIndexPath *pickIndexPath;
@end

@implementation AlbumTableViewController

-(NSMutableArray*)assetGroups
{
    if (!_assetGroups) {
        _assetGroups = [[NSMutableArray alloc] init];
    }
    return _assetGroups;
}

-(ALAssetsLibrary*)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

-(NSMutableDictionary*)selectedPhotosAll
{
    if (!_selectedPhotosAll) {
        _selectedPhotosAll = [[NSMutableDictionary alloc] init];
        
        //        for (ALAssetsGroup *group in self.assetGroups) {
        //            [_selectedPhotosAll setObject:[[NSMutableArray alloc]init] forKey:[group valueForProperty:ALAssetsGroupPropertyName]];
        //        }
    }
    return _selectedPhotosAll;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelImagePicker)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                           if (group == nil) {
                               return;
                           }
                           
                           //init selected list
                           NSString *groupPropertyID = (NSString *)[group valueForProperty:ALAssetsGroupPropertyPersistentID];
                           [self.selectedPhotosAll setObject:[[NSMutableArray alloc]init] forKey:groupPropertyID];
                           
                           //set camera roll first
                           if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                               [self.assetGroups insertObject:group atIndex:0];
                           }
                           else {
                               [self.assetGroups addObject:group];
                           }
                           
                           // Reload albums
                           [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                           
                       } failureBlock:^(NSError *error) {
                           if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                               NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
                               [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                               
                           } else {
                               NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                               [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
                           }
                           
                           [self.navigationItem setTitle:nil];
                       }];
                   });
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assetGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CGRect frame = cell.selectedCount.frame;
    frame.origin.x = self.view.bounds.size.width - cell.selectedCount.bounds.size.width - 60;
    cell.selectedCount.frame = frame;
    
    //add Constraint
    //    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    //    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:cell.selectedCount
    //                                                               attribute:NSLayoutAttributeTrailing
    //                                                               relatedBy:NSLayoutRelationEqual
    //                                                                  toItem:cell.contentView
    //                                                               attribute:NSLayoutAttributeTrailingMargin
    //                                                              multiplier:0.0
    //                                                                constant:50.0];
    //    [cell.contentView addConstraint:centerY];
    //
    //    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:cell.selectedCount
    //                                                               attribute:NSLayoutAttributeTop
    //                                                               relatedBy:NSLayoutRelationEqual
    //                                                                  toItem:cell.contentView
    //                                                               attribute:NSLayoutAttributeTopMargin
    //                                                              multiplier:0.0
    //                                                                constant:29];
    //    [cell.contentView addConstraint:centerX];
    //
    
    
    
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
    image = [self resize:image to:CGSizeMake(78, 78)];
    [cell.imageView setImage:image];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
    
}

- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

-(void)cancelImagePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Display Photo List"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if (indexPath) {
                if ([segue.destinationViewController isKindOfClass:[PhotoCollectionViewController class]]) {
                    self.pickIndexPath = indexPath;
                    PhotoCollectionViewController *photoCollectionViewController = segue.destinationViewController;
                    photoCollectionViewController.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
                    [photoCollectionViewController.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    photoCollectionViewController.title = [photoCollectionViewController.assetGroup valueForProperty:ALAssetsGroupPropertyName];
                    photoCollectionViewController.selectionDelegate = self;
                    photoCollectionViewController.selectedPhotos = [self.selectedPhotosAll valueForKey:[photoCollectionViewController.assetGroup valueForProperty:ALAssetsGroupPropertyPersistentID]];
                }
            }
        }
    }
}

#pragma SelectionDelegate impl.
-(void)didSelected:(NSMutableArray *)photos
{
    if ([self.selectionDelegate respondsToSelector:@selector(didSelected:)]) {
        [self.selectionDelegate didSelected:photos];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)AddToSelectedPhotosAll:(PhotoVo *)photos WithIndex:(NSString*)index
{
    NSMutableArray *indexSelectedPhotos = [self.selectedPhotosAll valueForKey:index];
    if (indexSelectedPhotos) {
        [indexSelectedPhotos addObject:photos];
        return YES;
    }
    return NO;
}

-(BOOL)shouldSelect:(PhotoVo *)photos WithCounts:(NSInteger)count
{
    BOOL returnVal = NO;
    if (self.pickIndexPath) {
        NSInteger counts = 0;
        for (NSString *key in self.selectedPhotosAll) {
            NSMutableArray *val = [self.selectedPhotosAll objectForKey:key];
            counts = counts + val.count;
        }
        
        if (counts < self.maximaCount) {
            NSString *index = [[self.assetGroups objectAtIndex:self.pickIndexPath.row] valueForProperty:ALAssetsGroupPropertyPersistentID];
            returnVal = [self AddToSelectedPhotosAll:photos WithIndex:index];
            
            AlbumTableViewCell *cell = (AlbumTableViewCell*)[self.tableView cellForRowAtIndexPath:self.pickIndexPath];
            cell.selectedCount.text = [[NSString alloc]initWithFormat:@"%ld",[[self.selectedPhotosAll objectForKey:index]count]];
            
            return returnVal;
        }else{
            NSString *title = [NSString stringWithFormat:NSLocalizedString(@"最多選擇%ld張", nil), self.maximaCount];
            NSString *message = nil;
            [[[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:NSLocalizedString(@"好", nil), nil] show];
        }
    }
    return returnVal;
}

-(BOOL)DeleteToSelectedPhotosAll:(PhotoVo *)photos WithIndex:(NSString*)index
{
    NSMutableArray *indexSelectedPhotos = [self.selectedPhotosAll valueForKey:index];
    if (indexSelectedPhotos) {
        [indexSelectedPhotos removeObject:photos];
        return YES;
    }
    return NO;
}

-(BOOL)shouldDeSelect:(PhotoVo *)photos WithCounts:(NSInteger)count
{
    if (self.pickIndexPath) {
        AlbumTableViewCell *cell = (AlbumTableViewCell*)[self.tableView cellForRowAtIndexPath:self.pickIndexPath];
        cell.selectedCount.text = [[NSString alloc]initWithFormat:@"%ld",count -1];
        
        return [self DeleteToSelectedPhotosAll:photos WithIndex:[[self.assetGroups objectAtIndex:self.pickIndexPath.row] valueForProperty:ALAssetsGroupPropertyPersistentID]];
    }
    return NO;
}

@end
