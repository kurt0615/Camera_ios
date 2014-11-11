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

@interface MutilePickerViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSInteger maximaCount;
@end

@implementation MutilePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maximaCount = 5;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Display Album List"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *uiNavigationController = segue.destinationViewController;
            if ([[uiNavigationController visibleViewController] isKindOfClass:[AlbumTableViewController class]]) {
                AlbumTableViewController *albumTableViewController = (AlbumTableViewController*)[uiNavigationController visibleViewController];
                albumTableViewController.albumDelegate = self;
                albumTableViewController.title = @"選擇相簿";
                albumTableViewController.maximaCount = self.maximaCount;
            }
        }
    }
}


-(void)didFinishWithPhotos:(NSMutableDictionary *)selectedPhotosAll
{
    CGRect workingFrame = self.view.frame;

    
    NSInteger counts = 0;
    for (NSString *key in selectedPhotosAll) {
        NSMutableArray *val = [selectedPhotosAll objectForKey:key];
        counts = counts + val.count;
        
        for (PhotoVo *v in val) {
            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:v.photo.thumbnail]];
            [imageview setContentMode:UIViewContentModeScaleAspectFit];
            imageview.frame = workingFrame;
            [self.scrollView addSubview:imageview];
            workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        }
    }
    NSLog(@"@Photo Counts : %ld",counts);
    
    
    
    
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:self.view.frame.size];
}

@end
