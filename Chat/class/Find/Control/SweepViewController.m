//
//  SweepViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/8/5.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "SweepViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SweepViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDevice *_device;
    NSTimer *timer;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_preview;
    UIImageView *_line;
    UIImageView *imageView;
    
    UIImageView *overImgView;
    
    int num;
    BOOL upOrdown;
}
@end

@implementation SweepViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_session && ![_session isRunning]) {
        [_session startRunning];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - KScreenWidth * 0.8)/2, 100, 0.8 * self.view.frame.size.width, 0.8 * self.view.frame.size.width)];
    imageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.1*KScreenWidth, CGRectGetMaxY(imageView.frame) + 8, 0.8*KScreenWidth, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"将二维码/条码放入框内，即可自动识别";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    [self setOverView];
    
    [self setupCamera];
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        // Output
        _output = [[AVCaptureMetadataOutput alloc]init];
        _output.rectOfInterest=CGRectMake(100/(KScreenHeight - 64), 0.1, 0.8*(KScreenWidth/KScreenHeight), 0.8);
        
        
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:_input])
        {
            [_session addInput:_input];
        }
        
        if ([_session canAddOutput:_output])
        {
            [_session addOutput:_output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            [self.view.layer insertSublayer:_preview atIndex:0];
            // Start
            [_session startRunning];
        });
    });
}

//处理扫描的结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [timer invalidate];
    NSLog(@"%@",stringValue);
    
    [self showHint:stringValue];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (2 * num == CGRectGetHeight(imageView.frame) - 20) {
            upOrdown = YES;
        }
    }
    else {
        num = 0;
        upOrdown = NO;
//        num ++;
//        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 110+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
//        if (num == 0) {
//            upOrdown = NO;
//        }
    }
    
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame) + 8;
    CGFloat y = CGRectGetMinY(imageView.frame) + 8;
    CGFloat w = CGRectGetWidth(imageView.frame) - 16;
    CGFloat h = CGRectGetHeight(imageView.frame) - 16;
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
