//
//  ViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/9/23.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationInfo;
@property (weak, nonatomic) IBOutlet UILabel *locationInfo2;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *overlay;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1){
            [self.locationManager requestWhenInUseAuthorization];
            //[self.locationManager requestAlwaysAuthorization];
        }else{
            [self.locationManager startUpdatingLocation];
        }
    }
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];//UIImagePickerControllerEditedImage
    self.image.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

@end
