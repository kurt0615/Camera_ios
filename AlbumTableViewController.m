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

@interface AlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
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


-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelImagePicker)];
    [self.navigationItem setRightBarButtonItem:cancelButton];
    
    // Load Albums into assetGroups
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                           if (group == nil) {
                               return;
                           }
                           
                           // added fix for camera albums order
                           NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                           NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                           
                           if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
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
//    if ([segue.identifier isEqualToString:@"Display Photo List"]) {
//        if ([sender isKindOfClass:[UITableViewCell class]]) {
//            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//            if (indexPath) {
//                if ([segue.destinationViewController isKindOfClass:[PhotoTableViewController class]]) {
//                    PhotoTableViewController *ptvc = segue.destinationViewController;
//                    ptvc.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//                    [ptvc.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
//                    ptvc.columns = 4;
//                }
//            }
//            
//        }
//    }
    
    if ([segue.identifier isEqualToString:@"Display Photo List"]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            if (indexPath) {
                if ([segue.destinationViewController isKindOfClass:[PhotoCollectionViewController class]]) {
                    PhotoCollectionViewController *photoCollectionViewController = segue.destinationViewController;
                    photoCollectionViewController.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
                    [photoCollectionViewController.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    photoCollectionViewController.title = [photoCollectionViewController.assetGroup valueForProperty:ALAssetsGroupPropertyName];
                    photoCollectionViewController.selectionDelegate = self;
                    photoCollectionViewController.maximaCount = self.maximaCount;
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

-(BOOL)shouldSelect:(PhotoVo *)photos WithCounts:(NSUInteger)count
{
    if (count < self.maximaCount) {
        NSLog(@"-(BOOL)shouldSelect:(PhotoVo *)photos WithCounts:(NSUInteger)count YES");
        return YES;
    }else{
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"最多選擇%ld張", nil), self.maximaCount];
        NSString *message = nil;//[NSString stringWithFormat:NSLocalizedString(@"最多選擇%ld張", nil), self.maximaCount];
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"好", nil), nil] show];
        NSLog(@"-(BOOL)shouldSelect:(PhotoVo *)photos WithCounts:(NSUInteger)count NO");
        return NO;
    }
}

@end
