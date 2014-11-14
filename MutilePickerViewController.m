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
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *addPhoto;
@end

@implementation MutilePickerViewController

- (IBAction)addPhotoAction:(id)sender {
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
        albumTableViewController.maximaCount = self.maximaCount;
        [self.navigationController pushViewController: albumTableViewController animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maximaCount = 4;
    self.imageContainer.delegate = self;
    self.imageContainer.dataSource = self;
    
    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x, self.imageContainer.frame.origin.y, 0, 75)];
    [self.addPhoto setFrame:CGRectMake(self.imageContainer.frame.size.width, self.imageContainer.frame.origin.y,
                                       self.addPhoto.frame.size.width, self.addPhoto.frame.size.height)];
}

-(void)didFinishWithPhotos:(NSMutableDictionary *)selectedPhotosAll
{
    for (NSString *key in selectedPhotosAll) {
        NSMutableArray *val = [selectedPhotosAll objectForKey:key];
        for (PhotoVo *photoVo in val) {
            UIImage *thumbnailImage = [UIImage imageWithCGImage:photoVo.photo.thumbnail];
            [self.dataSource addObject:thumbnailImage];
        }
    }
    
    [self.imageContainer setFrame:CGRectMake(self.imageContainer.frame.origin.x,self.imageContainer.frame.origin.y, self.dataSource.count*75, 75)];
    [self.addPhoto setFrame:CGRectMake(self.imageContainer.frame.size.width, self.imageContainer.frame.origin.y,
                                       self.addPhoto.frame.size.width, self.addPhoto.frame.size.height)];
    
    [self.addPhoto setHidden:(self.dataSource.count >= self.maximaCount)];
    
    [self.imageContainer reloadData];
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
                                                     [self.dataSource addObject:[UIImage imageWithCGImage:asset.thumbnail]];
                                                     [self didFinishWithPhotos:nil];
                                                 }
                                                failureBlock:nil];
                                  
                              }];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma Ref:www.nickkuh.com/iphone/how-to-create-square-thumbnails-using-iphone-sdk-cg-quartz-2d/2010/03/
- (UIImage *)thumbWithSideOfLength:(float)length :(UIImage*)mainImage {
    UIImage *thumbnail;
    //couldn’t find a previously created thumb image so create one first…
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    
    BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
    float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
    
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextClipToRect( currentContext, clippedRect);
    
    CGFloat scaleFactor = length/sideFull;
    
    if (widthGreaterThanHeight) {
        //a landscape image – make context shift the original image to the left when drawn into the context
        CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) / 2) * scaleFactor, 0);
    }
    else {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) / 2) * scaleFactor);
    }
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
    [mainImageView.layer renderInContext:currentContext];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(thumbnail);
    
    return [UIImage imageWithData:imageData];
}

#pragma CollectionViewDelegate impl
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MutilePickerCollectionViewCell * mutilePickerCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [mutilePickerCollectionViewCell setAssets:[self.dataSource objectAtIndex:indexPath.row]];
    
    //__weak ViewController *weakViewController = self;
    __weak MutilePickerCollectionViewCell *weakMutilePickerCollectionViewCell = mutilePickerCollectionViewCell;
    
    mutilePickerCollectionViewCell.act = ^{
        
    };
    
    return mutilePickerCollectionViewCell;
}

-(void)viewDidLayoutSubviews
{
    self.imageContainer.contentInset = UIEdgeInsetsMake(2.5f, 4.f, 0, 4.f);
}

//Getter
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


@end
