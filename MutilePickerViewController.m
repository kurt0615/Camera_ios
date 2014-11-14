//
//  MutilePickerViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/11/4.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "MutilePickerViewController.h"
#import "AlbumTableViewController.h"
#import "PhotoPickerRoot.h"
#import "PhotoVo.h"
#import "MutilePickerCollectionViewCell.h"
#import "CameraViewController.h"

@interface MutilePickerViewController ()
@property (nonatomic) NSInteger maximaCount;
@property (weak, nonatomic) IBOutlet UICollectionView *imageContainer;
@property (strong, nonatomic) UIButton *addPhotoBtn;
@property (strong, nonatomic) NSMutableArray *thumbnailDataSource;
@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@property (strong, nonatomic) NSURL *reTakePhoto;
@end

@implementation MutilePickerViewController


#define MAXIMA_SELECTED_COUNT 4

- (IBAction)addPhotoAction:(id)sender {
    self.reTakePhoto = nil;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"照相"];
    }

    [actionSheet addButtonWithTitle:@"選擇相片"];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"照相"]) {
        CameraViewController *camara = [[CameraViewController alloc]initWithSetup:self];
        [self presentViewController:camara animated:YES completion:NULL];

        
    }else if([title isEqualToString:@"選擇相片"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AlbumTableViewController *albumTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"Album"];
        albumTableViewController.albumDelegate = self;
        albumTableViewController.title = @"選擇相簿";
        if (self.reTakePhoto) {
            self.maximaCount = 1;
        }else{
            [self resetMaximaCount];
        }
        albumTableViewController.maximaCount = self.maximaCount;
        [self.navigationController pushViewController: albumTableViewController animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maximaCount = MAXIMA_SELECTED_COUNT;
    self.imageContainer.delegate = self;
    self.imageContainer.dataSource = self;
    
    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x, self.imageContainer.frame.origin.y, 0, 75)];
    [self.addPhoto setFrame:CGRectMake(self.imageContainer.frame.size.width, self.imageContainer.frame.origin.y,
                                       self.addPhoto.frame.size.width, self.addPhoto.frame.size.height)];
}

#pragma AlbumDelegate impl
-(void)didFinishWithPhotos:(NSMutableDictionary *)selectedPhotosAll
{
    for (NSString *key in selectedPhotosAll) {
        NSMutableArray *val = [selectedPhotosAll objectForKey:key];
        for (PhotoVo *photoVo in val) {
             if (self.reTakePhoto) {
                  [self replacePhotoWith:photoVo];
             }else{
                 [self.thumbnailDataSource addObject:photoVo];
             }
        }
    }
    
    [self resetMaximaCount];
    [self resizeImageContainer];
    [self.imageContainer reloadData];
}

-(void)didFinishWithPhoto:(ALAsset *)photo
{
    PhotoVo *photoVo = [[PhotoVo alloc] initWithPhoto:photo Selected:YES];
    
    if (self.reTakePhoto) {
        [self replacePhotoWith:photoVo];
    }else{
        [self.thumbnailDataSource addObject:photoVo];
        [self resetMaximaCount];
        [self resizeImageContainer];
    }
    [self.imageContainer reloadData];
}

-(void)resizeImageContainer
{
    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x,self.imageContainer.frame.origin.y, self.thumbnailDataSource.count*75, 75)];
    [self.addPhoto setFrame:CGRectMake(self.imageContainer.frame.size.width, self.imageContainer.frame.origin.y,
                                       self.addPhoto.frame.size.width, self.addPhoto.frame.size.height)];
    [self.addPhoto setHidden:(self.thumbnailDataSource.count >= MAXIMA_SELECTED_COUNT)];
}

-(void)replacePhotoWith:(PhotoVo*)newPhoto
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoUrl == %@", self.reTakePhoto];
    NSArray *filteredArray = [self.thumbnailDataSource filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        [self.thumbnailDataSource replaceObjectAtIndex:[self.thumbnailDataSource indexOfObject:filteredArray[0]] withObject:newPhoto];
    }
    self.maximaCount = 4;
}

-(void)resetMaximaCount
{
    self.maximaCount = MAXIMA_SELECTED_COUNT - self.thumbnailDataSource.count;
}

-(UIImage*)getComparessPhotoWithScale:(float)scale WithPhoto:(PhotoVo*)photo
{
    return [UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageWithCGImage:[[photo.photoALAsset defaultRepresentation] fullResolutionImage]],scale)];
}

#pragma UIImagePickerControllerDelegate impl
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info valueForKeyPath:UIImagePickerControllerOriginalImage];
    
    if(chosenImage){
        //save to PhotoAlbum
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[chosenImage CGImage]
                                  orientation:(ALAssetOrientation)[chosenImage imageOrientation]
                              completionBlock:^(NSURL *assetURL, NSError *error){
                                  ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc]init];
                                  [assetslibrary assetForURL:assetURL
                                                 resultBlock:^(ALAsset *asset){
                                                     [self didFinishWithPhoto:asset];
                                                 }
                                                failureBlock:nil];
                                  
                              }];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    self.reTakePhoto = nil;
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}

#pragma CollectionViewDelegate impl
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.thumbnailDataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MutilePickerCollectionViewCell * mutilePickerCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [mutilePickerCollectionViewCell setAssets:[self.thumbnailDataSource objectAtIndex:indexPath.row]];
    
    mutilePickerCollectionViewCell.act = ^{
        //self.reTakePhoto = [[(PhotoVo*)[self.thumbnailDataSource objectAtIndex:indexPath.row] photoUrl]absoluteString];
        self.reTakePhoto = [(PhotoVo*)[self.thumbnailDataSource objectAtIndex:indexPath.row] photoUrl];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [actionSheet addButtonWithTitle:@"照相"];
        }
        
        [actionSheet addButtonWithTitle:@"選擇相片"];
        [actionSheet showInView:self.view];
    };
    
    return mutilePickerCollectionViewCell;
}

-(void)viewDidLayoutSubviews
{
    self.imageContainer.contentInset = UIEdgeInsetsMake(2.5f, 4.f, 0, 4.f);
}

//Getter
-(NSMutableArray *)thumbnailDataSource{
    if (!_thumbnailDataSource) {
        _thumbnailDataSource = [[NSMutableArray alloc]init];
    }
    return _thumbnailDataSource;
}







@end
