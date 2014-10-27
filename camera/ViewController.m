//
//  ViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/9/23.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "ScaleableImageView.h"

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
@property (strong, nonatomic) ScaleableImageView *scaleableImageView;
@property (strong, nonatomic) UIBarButtonItem *confirmBarButtonItem;
@property (strong, nonatomic) UIScrollView *scaleableImageViewScrollView;
@property (strong, nonatomic) UIView *scaleableContainer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UIToolbar *toolbar;
@end

@implementation ViewController

//overlayout use
- (IBAction)take:(id)sender {
    [self.picker takePicture];
}

//overlayout use
- (IBAction)cancel:(id)sender {
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cancelScaleableImageView {
    [self.scaleableContainer removeFromSuperview];
    self.scaleableImageView = nil;
    self.toolbar = nil;
    self.scaleableImageViewScrollView = nil;
    self.scaleableContainer = nil;
}

- (void)hideScaleableImageViewToolbar {
    [UIView animateWithDuration:0.2 animations:^{
        if (self.toolbar.frame.origin.y == self.view.frame.size.height) {
            [self.toolbar setFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
        }else{
            [self.toolbar setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
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

    
    
    UIImageView *img = [[UIImageView alloc]init];

    [img setFrame:CGRectMake(0,0,80.f,80.f)];
    img.image = [self loadImageWithFileName:@"4D735E26-3E15-40F2-93B4-86FF8714B5FA"];

    NSDictionary *imgInfo = @{
                              @"fileName":@"4D735E26-3E15-40F2-93B4-86FF8714B5FA",
                              @"image":img
                              };
    
        [self.dataSource addObject:imgInfo];

    
    UIImageView *img2 = [[UIImageView alloc]init];
    
    [img2 setFrame:CGRectMake(0,0,80.f,80.f)];
    img2.image = [self loadImageWithFileName:@"6B687E1B-0781-443B-9F4C-F86E271C804C"];
    
    NSDictionary *imgInfo2 = @{
                              @"fileName":@"6B687E1B-0781-443B-9F4C-F86E271C804C",
                              @"image":img2
                              };
    
    
    [self.dataSource addObject:imgInfo2];
    
    
    UIImageView *img3 = [[UIImageView alloc]init];
    
    [img3 setFrame:CGRectMake(0,0,80.f,80.f)];
    img3.image = [self loadImageWithFileName:@"741F4702-38D7-485B-8C56-F33214E335C5"];
    
    NSDictionary *imgInfo3 = @{
                               @"fileName":@"741F4702-38D7-485B-8C56-F33214E335C5",
                               @"image":img3
                               };
    
    
    [self.dataSource addObject:imgInfo3];
//    [self.dataSource addObject:imgInfo3];
//    [self.dataSource addObject:imgInfo3];
//    [self.dataSource addObject:imgInfo3];
//    [self.dataSource addObject:imgInfo3];
//    [self.dataSource addObject:imgInfo3];

    
    [self.imageContainer reloadData];

    
    
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
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];//UIImagePickerControllerEditedImage
    
//    UIGraphicsBeginImageContext(destinationSize);
//    [chosenImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
//    self.image.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
   
    
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
    
    
    [self.dataSource addObject:imgInfo];

    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.imageContainer reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if(collectionViewCell){
        
        NSDictionary *imgInfo = self.dataSource[indexPath.row];
        
        [collectionViewCell.contentView addSubview:[imgInfo valueForKey:@"image"]];
        
        __weak CollectionViewCell *weakCollectionViewCell = collectionViewCell;
        collectionViewCell.act = ^{
            
            [self.scaleableImageView setUserInteractionEnabled:YES];
            [self.scaleableImageView setContentMode:UIViewContentModeScaleAspectFit];
            self.scaleableImageView.image = ((UIImageView*)[imgInfo valueForKey:@"image"]).image;
            [self.scaleableImageView  setFrame:weakCollectionViewCell.frame];
            
            [self.scaleableImageViewScrollView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.scaleableImageViewScrollView setBackgroundColor:[UIColor clearColor]];
            self.scaleableImageViewScrollView.delegate = self;
            self.scaleableImageViewScrollView.contentSize = self.view.frame.size;
            self.scaleableImageViewScrollView.minimumZoomScale = .5f;
            self.scaleableImageViewScrollView.maximumZoomScale = 3.0f;
            //self.scaleableImageViewScrollView.bouncesZoom = NO;
            //self.scaleableImageViewScrollView.bounces = NO;
            [self.scaleableImageViewScrollView addSubview:self.scaleableImageView];

            UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            NSArray *items = [NSArray arrayWithObjects:flexiableItem, self.confirmBarButtonItem, nil];
            self.toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
            self.toolbar.items = items;
            
            [self.scaleableContainer setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
            [self.scaleableContainer setBackgroundColor:[UIColor clearColor]];
            [self.scaleableContainer addSubview:self.scaleableImageViewScrollView];
            [self.tapRecognizer addTarget:self action:@selector(hideScaleableImageViewToolbar)];
            [self.scaleableContainer addGestureRecognizer:self.tapRecognizer];
            [self.view addSubview:self.scaleableContainer];
            
            [UIView animateWithDuration:0.4
                             animations:^{
                                 [self.scaleableImageView setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 [self.scaleableContainer addSubview:self.toolbar];
                                 [self.scaleableContainer bringSubviewToFront:self.toolbar];
                                 [self.scaleableContainer setBackgroundColor:[UIColor blackColor]];
                             }];
        };
    }
    return collectionViewCell;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleableImageView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

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

-(UIBarButtonItem *)confirmBarButtonItem{
    if (!_confirmBarButtonItem) {
        _confirmBarButtonItem = [[UIBarButtonItem alloc]
                              initWithTitle:@"確定"
                              style:UIBarButtonItemStylePlain
                              target:self
                                 action:@selector(cancelScaleableImageView)];
    }
    return _confirmBarButtonItem;
}

-(ScaleableImageView*)scaleableImageView
{
    if (!_scaleableImageView) {
         _scaleableImageView = [[ScaleableImageView alloc] init];
    }
    return _scaleableImageView;
}

-(UIScrollView*)scaleableImageViewScrollView
{
    if (!_scaleableImageViewScrollView) {
        _scaleableImageViewScrollView = [[UIScrollView alloc]init];
    }
    return _scaleableImageViewScrollView;
}

-(UIView*)scaleableContainer
{
    if (!_scaleableContainer) {
        _scaleableContainer = [[UIView alloc]init];
    }
    return _scaleableContainer;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.scaleableImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

-(UITapGestureRecognizer*)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc]init];
    }
    return _tapRecognizer;
}

-(UIToolbar*)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc]init];
    }
    return _toolbar;
}
@end
