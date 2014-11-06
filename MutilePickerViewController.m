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
    self.maximaCount = 4;
}

//- (IBAction)GoToPhoto:(id)sender {
//    PhotoPickerRoot *photoPickerRoot = [[PhotoPickerRoot alloc] init];
//
//    [self presentViewController:photoPickerRoot animated:YES completion:nil];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Display Album List"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *uiNavigationController = segue.destinationViewController;
            if ([[uiNavigationController visibleViewController] isKindOfClass:[AlbumTableViewController class]]) {
                AlbumTableViewController *albumTableViewController = (AlbumTableViewController*)[uiNavigationController visibleViewController];
                albumTableViewController.selectionDelegate = self;
                albumTableViewController.title = @"選擇相簿";
                albumTableViewController.maximaCount = self.maximaCount;
            }
        }
    }
}
-(void)didSelected:(NSMutableArray *)photos
{
    NSLog(@"@Photo Counts : %ld",photos.count);
    
    self.maximaCount = self.maximaCount - photos.count;
    
    CGRect workingFrame = CGRectMake(100, 100, 768, 700);;
    for (PhotoVo *v in photos) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:v.photo.thumbnail]];
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.frame = workingFrame;
        [self.scrollView addSubview:imageview];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
    }
    
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(2200, 1090)];

}

@end
