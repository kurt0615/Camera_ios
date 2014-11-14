//
//  CameraViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/11/13.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

-(instancetype)initWithSetup:(id)delegate
{
    self = [super init];
    self.delegate = delegate;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    return self;
}

@end
