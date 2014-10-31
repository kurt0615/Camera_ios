//
//  DownloadViewController.m
//  camera
//
//  Created by Kurt Yang on 2014/10/30.
//  Copyright (c) 2014年 Kurt Yang. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController () <NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbview;
@property (weak, nonatomic) IBOutlet UILabel *slab;
@property (weak, nonatomic) IBOutlet UILabel *elab;

@property (weak, nonatomic) IBOutlet UILabel *slab2;
@property (weak, nonatomic) IBOutlet UILabel *elab2;
@property (weak, nonatomic) IBOutlet UILabel *slab3;
@property (weak, nonatomic) IBOutlet UILabel *elab3;
@property (weak, nonatomic) IBOutlet UILabel *slab4;
@property (weak, nonatomic) IBOutlet UILabel *elab4;

@property (strong, nonatomic) UIImage *imag;
@property (strong, nonatomic) UIImageView *imagview;
@property (strong, nonatomic) NSMutableData *nsdata;
@end

@implementation DownloadViewController


-(UIImageView*)imagview{
    if (!_imagview) {
        _imagview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        _imagview.image = self.imag;
        [self.view addSubview:_imagview];
    }
    return _imagview;
}

-(UIImage*)imag{
    if (!_imag) {
        _imag = [[UIImage alloc]initWithData:self.nsdata];
    }
    return _imag;
}

-(NSMutableData*)nsdata{
    if (!_nsdata) {
        _nsdata = [[NSMutableData alloc]init];
    }
    return _nsdata;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tbview.delegate = self;
    self.tbview.dataSource = self;

   [self doRequest];
    
//    [self doRequest2];
    
  //  [self doRequest3];
    
    //[self doRequest4];
}



//NSURLSessionDownloadTask delegate
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    NSLog(@"id:%@",session.configuration.identifier);
    if ([session.configuration.identifier isEqualToString:@"myBackgroundSessionIdentifier"]) {
        self.slab.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesWritten];
        self.elab.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesExpectedToWrite];
    }
    
    if ([session.configuration.identifier isEqualToString:@"myBackgroundSessionIdentifier2"]) {
        self.slab2.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesWritten];
        self.elab2.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesExpectedToWrite];
    }
    
    if ([session.configuration.identifier isEqualToString:@"myBackgroundSessionIdentifier3"]) {
        self.slab3.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesWritten];
        self.elab3.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesExpectedToWrite];
    }
    
    if ([session.configuration.identifier isEqualToString:@"myBackgroundSessionIdentifier4"]) {
        self.slab4.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesWritten];
        self.elab4.text = [[NSString alloc]initWithFormat:@"%lld",totalBytesExpectedToWrite];
    }
   
    
//    NSLog(@"Session %@ download task %@ wrote an additional %lld bytes (total %lld bytes) out of an expected %lld bytes.\n",
//          session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n",
          session, downloadTask, fileOffset, expectedTotalBytes);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    UIImage *im = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
    self.imagview.image = im;
    NSLog(@"Finish");
}




// test Request
-(void)doRequest
{
    NSURL *url = [[NSURL alloc]initWithString:@"https://farm6.staticflickr.com/5602/15444843687_b4e06efa7d_o_d.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfiguration: @"myBackgroundSessionIdentifier"];
//    NSURLSessionConfiguration *ephemeralConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *task =[session downloadTaskWithRequest:request];

    
    [task resume];
}

-(void)doRequest2
{
    NSURL *url = [[NSURL alloc]initWithString:@"https://farm8.staticflickr.com/7491/15046967124_6baedae5d9_o.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfiguration: @"myBackgroundSessionIdentifier2"];
    //NSURLSessionConfiguration *ephemeralConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *task =[session downloadTaskWithRequest:request];

    
    [task resume];
}


-(void)doRequest3
{
    NSURL *url = [[NSURL alloc]initWithString:@"https://farm9.staticflickr.com/8638/15667726435_ee0131593f_o.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfiguration: @"myBackgroundSessionIdentifier3"];
    //NSURLSessionConfiguration *ephemeralConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *task =[session downloadTaskWithRequest:request];
    
    [task resume];
}

-(void)doRequest4
{
    NSURL *url = [[NSURL alloc]initWithString:@"https://farm8.staticflickr.com/7531/15667690955_3841e1e820_o.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfiguration: @"myBackgroundSessionIdentifier4"];
    //NSURLSessionConfiguration *ephemeralConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *task =[session downloadTaskWithRequest:request];
    
    
    //    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
    //                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
    //                                                        NSLog(@"doRequest Done");
    //                                                    }];
    //
    
    [task resume];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    label.text = @"abc";
    label.textColor = [UIColor blackColor];
    
    [cell.contentView addSubview:label];
    return cell;
}

@end
