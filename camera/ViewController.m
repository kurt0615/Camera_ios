//
//  ViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/9/23.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "ScaleableIVToolbar.h"
#import "AlertView.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationInfo;
@property (weak, nonatomic) IBOutlet UILabel *locationInfo2;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UICollectionView *imageContainer;
@property (strong, nonatomic) NSMutableArray *dataSource;
//@property (strong, nonatomic) UIImageView *scaleableImageView;
//@property (strong, nonatomic) UIScrollView *scaleableImageViewScrollView;
//@property (strong, nonatomic) UIView *scaleableContainer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
//@property (strong, nonatomic) ScaleableIVToolbar *toolbar;
@property (strong, nonatomic) AlertView *alertView;
@property (strong, nonatomic) NSMutableDictionary *tempPhotoInfo;
@property (strong, nonatomic) UIView *scaleableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scaleableImageViewScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *scaleableImageView;
@property (weak, nonatomic) IBOutlet UIToolbar *scaleableImageViewToolBar;
@property (strong, nonatomic) id confirmBarButtonItemAct;
@property (strong, nonatomic) id deleteBarButtonItemAct;
@property (strong, nonatomic) id takephotoBarButtonItemAct;
@property (strong, nonatomic) UIButton *addPhotoBtn;
@end

@implementation ViewController

//overlayout use
- (IBAction)take:(id)sender {
    [self.picker takePicture];
}

//overlayout use
- (IBAction)cancel:(id)sender {
    self.tempPhotoInfo = nil;
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)hideScaleableViewToolbar:(id)sender {
        [UIView animateWithDuration:0.2 animations:^{
            if (self.scaleableImageViewToolBar.frame.origin.y == self.view.frame.size.height) {
                [self.scaleableImageViewToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
            }else{
                [self.scaleableImageViewToolBar setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
            }
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    self.imageContainer.delegate = self;
    self.imageContainer.dataSource = self;
    
    
    //for test
    
    //75004758-4828-41D9-A4CE-8834F0A14228
    //    UIImageView *img = [[UIImageView alloc]init];
    //
    //    [img setFrame:CGRectMake(0,0,80.f,80.f)];
    //    img.image = [self loadImageWithFileName:@"75004758-4828-41D9-A4CE-8834F0A14228"];
    //
    //    NSDictionary *imgInfo = @{
    //                              @"fileName":@"75004758-4828-41D9-A4CE-8834F0A14228",
    //                              @"image":img
    //                              };
    //
    //    [self.dataSource addObject:imgInfo];
    
    
    
//    UIImageView *img = [[UIImageView alloc]init];
//    
//    [img setFrame:CGRectMake(0,0,80.f,80.f)];
//    img.image = [self loadImageWithFileName:@"4D735E26-3E15-40F2-93B4-86FF8714B5FA"];
//    
//    NSDictionary *imgInfo = @{
//                              @"fileName":@"4D735E26-3E15-40F2-93B4-86FF8714B5FA",
//                              @"image":img
//                              };
//    
//    [self.dataSource addObject:imgInfo];
//    
//    
//    UIImageView *img2 = [[UIImageView alloc]init];
//    
//    [img2 setFrame:CGRectMake(0,0,80.f,80.f)];
//    img2.image = [self loadImageWithFileName:@"6B687E1B-0781-443B-9F4C-F86E271C804C"];
//    
//    NSDictionary *imgInfo2 = @{
//                               @"fileName":@"6B687E1B-0781-443B-9F4C-F86E271C804C",
//                               @"image":img2
//                               };
//    
//    
//    [self.dataSource addObject:imgInfo2];
//    
//    
//    UIImageView *img3 = [[UIImageView alloc]init];
//    
//    [img3 setFrame:CGRectMake(0,0,80.f,80.f)];
//    img3.image = [self loadImageWithFileName:@"741F4702-38D7-485B-8C56-F33214E335C5"];
//    
//    NSDictionary *imgInfo3 = @{
//                               @"fileName":@"741F4702-38D7-485B-8C56-F33214E335C5",
//                               @"image":img3
//                               };
//    
//    
//    [self.dataSource addObject:imgInfo3];
    //    [self.dataSource addObject:imgInfo3];
    //    [self.dataSource addObject:imgInfo3];
    //    [self.dataSource addObject:imgInfo3];
    //    [self.dataSource addObject:imgInfo3];
    //    [self.dataSource addObject:imgInfo3];
    
    
//    UIImageView *img4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add"]];
//    
//    [img4 setFrame:CGRectMake(0,0,80.f,80.f)];
//    
//    NSDictionary *imgInfo4 = @{
//                               @"fileName":@"cover",
//                               @"image":img4
//                               };
//    
//    
//    [self.dataSource addObject:imgInfo4];

    
    //[self.imageContainer reloadData];
    
    
    
    //for test end
}

-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    return _locationManager;
}

-(UIImagePickerController*)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}

- (IBAction)takePhoto:(id)sender {
    
    self.picker.delegate = self;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    
    //overlayout use
    //    self.picker.showsCameraControls = NO;
    //    self.picker.navigationBarHidden = YES;
    //    self.picker.toolbarHidden = YES;
    //
    //    [[NSBundle mainBundle] loadNibNamed:@"OverView" owner:self options:nil];
    //    self.overlay.frame = self.picker.cameraOverlayView.frame;
    //
    //    self.picker.cameraOverlayView = self.overlay;
    //    self.overlay = nil;
    //overlayout use end
    
    
    [self presentViewController:self.picker animated:YES completion:NULL];
}


- (IBAction)selectPthoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 ){
            [self.locationManager requestWhenInUseAuthorization];
            //[self.locationManager requestAlwaysAuthorization];
        }else{
            [self.locationManager startUpdatingLocation];
        }
    }
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    UIImageView *img = [[UIImageView alloc]init];
    [img setFrame:CGRectMake(0,0,80.f,80.f)];
    img.image = chosenImage;
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef stringUUID = CFUUIDCreateString(NULL, theUUID);
    NSString *fileName = (__bridge_transfer NSString *)stringUUID;
    CFRelease(theUUID);
    [self savaImage:chosenImage Withfilename:[NSString stringWithFormat:@"%@",fileName]];
    
    NSDictionary *imgInfo = @{
                              @"fileName":fileName,
                              @"image":img
                              };
    
    if (self.tempPhotoInfo) {
        NSInteger replaceIndex = [self.dataSource indexOfObject:self.tempPhotoInfo];
        [self.dataSource removeObject:self.tempPhotoInfo];
        [self.dataSource insertObject:imgInfo atIndex:replaceIndex];
        [self confirmBarItemAct];
        self.tempPhotoInfo = nil;
    }else{
        [self.dataSource addObject:imgInfo];
    }
    [self.imageContainer reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.tempPhotoInfo = nil;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) takepicture:(id) sender{
    [self.picker takePicture];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = locations[0];
    
    if (currentLocation != nil) {
        self.locationInfo.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        self.locationInfo2.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    self.locationManager = nil;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
    }
}


// CollectionView Event
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if(collectionViewCell && self.dataSource.count > indexPath.row){
        NSDictionary *imgInfo = self.dataSource[indexPath.row];
        
        [collectionViewCell.contentView addSubview:[imgInfo valueForKey:@"image"]];
        
        __weak ViewController *weakViewController = self;
        __weak CollectionViewCell *weakCollectionViewCell = collectionViewCell;
      
        collectionViewCell.act = ^{
           
        /*
         *  Method.1
         *  Add View Programmatically
         */
            
            //            [self.scaleableImageView setUserInteractionEnabled:YES];
            //            [self.scaleableImageView setContentMode:UIViewContentModeScaleAspectFit];
            //            self.scaleableImageView.image = ((UIImageView*)[imgInfo valueForKey:@"image"]).image;
            //            [self.scaleableImageView setFrame:weakCollectionViewCell.frame];
            //
            //            [self.scaleableImageViewScrollView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            //            [self.scaleableImageViewScrollView setBackgroundColor:[UIColor clearColor]];
            //            self.scaleableImageViewScrollView.delegate = self;
            //            self.scaleableImageViewScrollView.contentSize = self.view.frame.size;
            //            self.scaleableImageViewScrollView.minimumZoomScale = .5f;
            //            self.scaleableImageViewScrollView.maximumZoomScale = 3.0f;
            //            //self.scaleableImageViewScrollView.bouncesZoom = NO;
            //            //self.scaleableImageViewScrollView.bounces = NO;
            //            [self.scaleableImageViewScrollView addSubview:self.scaleableImageView];
            //
            //
            //            self.toolbar.confirmBarButtonItemAct = ^{
            //                [weakViewController confirmBarItemAct];
            //            };
            //
            //            self.toolbar.deleteBarButtonItemAct = ^{
            //                [weakViewController deleteWithFileName:[imgInfo valueForKey:@"fileName"]];
            //            };
            //
            //            self.toolbar.takephotoBarButtonItemAct = ^{
            //                [weakViewController reTakePhotoWithFileName:[imgInfo valueForKey:@"fileName"]];
            //            };
            //
            //
            //            [self.scaleableContainer setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            //            [self.scaleableContainer setBackgroundColor:[UIColor clearColor]];
            //            [self.scaleableContainer addSubview:self.scaleableImageViewScrollView];
            //            [self.tapRecognizer addTarget:self action:@selector(hideScaleableImageViewToolbar)];
            //            [self.scaleableContainer addGestureRecognizer:self.tapRecognizer];
            //            [self.view addSubview:self.scaleableContainer];
            //
            //            [UIView animateWithDuration:0.4
            //                             animations:^{
            //                                 [self.scaleableImageView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            //                             }
            //                             completion:^(BOOL finished) {
            //                                 [self.scaleableContainer addSubview:self.toolbar];
            //                                 [self.scaleableContainer bringSubviewToFront:self.toolbar];
            //                                 [self.scaleableContainer setBackgroundColor:[UIColor blackColor]];
            //                             }];
           
           
        /* 
         *  Method.2
         *  Add View from Xib
         */
            
            weakViewController.scaleableView = (UIView*)[[[NSBundle mainBundle] loadNibNamed:@"ScaleableView" owner:self options:nil] objectAtIndex:0];
            [weakViewController.scaleableView setBackgroundColor:[UIColor clearColor]];
            [self.scaleableImageView setContentMode:UIViewContentModeScaleAspectFit];
            self.scaleableImageView.image = ((UIImageView*)[imgInfo valueForKey:@"image"]).image;
            [self.scaleableImageView setFrame:weakCollectionViewCell.frame];

            [self.scaleableImageViewScrollView setBackgroundColor:[UIColor clearColor]];
            [self.scaleableImageViewScrollView setFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
            self.scaleableImageViewScrollView.delegate = self;
            self.scaleableImageViewScrollView.contentSize = self.view.frame.size;
            self.scaleableImageViewScrollView.minimumZoomScale = .5f;
            self.scaleableImageViewScrollView.maximumZoomScale = 3.0f;
            [self.scaleableImageViewToolBar setFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
            
            [weakViewController.scaleableView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.view addSubview:weakViewController.scaleableView];
            
            
            weakViewController.confirmBarButtonItemAct = ^{
               [weakViewController confirmBarItemAct];
            };
            
            weakViewController.deleteBarButtonItemAct = ^{
               [weakViewController deleteWithFileName:[imgInfo valueForKey:@"fileName"]];
            };
            
            weakViewController.takephotoBarButtonItemAct = ^{
                [weakViewController reTakePhotoWithFileName:[imgInfo valueForKey:@"fileName"]];
            };
            
            
            [UIView animateWithDuration:0.4
                             animations:^{
                                 [weakViewController.scaleableImageView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 [weakViewController.scaleableView setBackgroundColor:[UIColor blackColor]];
                                 [weakViewController.scaleableImageViewToolBar setHidden:false];
                             }];
            
        };
    }else{
        //for add icon
        [self.addPhotoBtn removeFromSuperview];
        [collectionViewCell.contentView addSubview:self.addPhotoBtn];
    }
    return collectionViewCell;
}

-(void)abc
{
    NSLog(@"aaa");
}

//Image Util
-(void)savaImage:(UIImage*)image Withfilename:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData* pngData = UIImageJPEGRepresentation(image, 1.0);
    [pngData writeToFile:filePath atomically:YES];
}

-(UIImage *)loadImageWithFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *img = [UIImage imageWithData:pngData];
    return img;
}


//BarButton Action
- (void)confirmBarItemAct {
//    [self.scaleableContainer removeFromSuperview];
//    self.scaleableImageView = nil;
//    self.toolbar = nil;
//    self.scaleableImageViewScrollView = nil;
//    self.scaleableContainer = nil;
    
    [self.scaleableView removeFromSuperview];
}

- (void)deleteWithFileName:(NSString*)fileName
{
    self.alertView = [[AlertView alloc]initWithTitle:nil message:@"確定刪除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    self.alertView.context = fileName;
    [self.alertView show];
}

-(void)reTakePhotoWithFileName:(NSString*)fileName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName == %@", fileName];
    NSArray *filteredArray = [self.dataSource filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        self.tempPhotoInfo = [filteredArray[0] mutableCopy];
        [self takePhoto:nil];
    }
}

- (IBAction)confirmBarItemAct:(id)sender {
    [self.confirmBarButtonItemAct invoke];
}


- (IBAction)delete:(id)sender WithFileName:(NSString*)fileName{
    [self.deleteBarButtonItemAct invoke];
}

- (IBAction)reTakePhoto:(id)sender  WithFileName:(NSString*)fileName{
    [self.takephotoBarButtonItemAct invoke];
}


//ScrollView Event

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleableImageView;
}


-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;

    CGRect contentsFrame = self.scaleableImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.scaleableImageView.frame = contentsFrame;
}


//UIAlertView Event
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([alertView isKindOfClass:[AlertView class]]) {
            AlertView *av = (AlertView*)alertView;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName == %@", av.context];
            NSArray *filteredArray = [self.dataSource filteredArrayUsingPredicate:predicate];
            [self.dataSource  removeObjectsInArray:filteredArray];
            [self.imageContainer reloadData];
            [self confirmBarItemAct];
        }
    }
}

//Getter
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(UIButton*)addPhotoBtn
{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [[UIButton alloc]init];
        [_addPhotoBtn setFrame:CGRectMake(0,0,80.f,80.f)];
        [_addPhotoBtn setTitle:@"新增" forState:UIControlStateNormal];
        [_addPhotoBtn setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _addPhotoBtn.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor];
        _addPhotoBtn.layer.borderWidth = 1;
        _addPhotoBtn.layer.cornerRadius = 5;
        [_addPhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}
//-(ScaleableImageView*)scaleableImageView
//{
//    if (!_scaleableImageView) {
//        _scaleableImageView = [[ScaleableImageView alloc] init];
//    }
//    return _scaleableImageView;
//}
//
//-(UIScrollView*)scaleableImageViewScrollView
//{
//    if (!_scaleableImageViewScrollView) {
//        _scaleableImageViewScrollView = [[UIScrollView alloc]init];
//    }
//    return _scaleableImageViewScrollView;
//}
//
//-(UIView*)scaleableContainer
//{
//    if (!_scaleableContainer) {
//        _scaleableContainer = [[UIView alloc]init];
//    }
//    return _scaleableContainer;
//}
//
//-(UITapGestureRecognizer*)tapRecognizer
//{
//    if (!_tapRecognizer) {
//        _tapRecognizer = [[UITapGestureRecognizer alloc]init];
//    }
//    return _tapRecognizer;
//}
//
//-(ScaleableIVToolbar*)toolbar
//{
//    if (!_toolbar) {
//        _toolbar = [[ScaleableIVToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
//    }
//    return _toolbar;
//}
@end
