//
//  CameraViewController.h
//  camera
//
//  Created by Kurt Yang on 2014/11/13.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIImagePickerController <UINavigationControllerDelegate>
-(instancetype)initWithSetup:(id)delegate;
@end
