//
//  QRViewController.m
//  Blizky
//
//  Created by Dacodes on 28/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
    UIImageView *qrCodeFrameView;
}

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QR";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    // Initialize the captureSession object.
    captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    // Set delegate and use the default dispatch queue to execute the call back
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:videoPreviewLayer];
    
    // Start video capture.
    [captureSession startRunning];
    
    
    // Initialize QR Code Frame to highlight the QR code
    qrCodeFrameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRLogo"]];
    qrCodeFrameView.alpha = 0.7;
    qrCodeFrameView.hidden = YES;
    
    [self.view addSubview:qrCodeFrameView];
    [self.view bringSubviewToFront:qrCodeFrameView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection: (AVCaptureConnection *)connection
{
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects == nil || metadataObjects.count == 0) {
        qrCodeFrameView.frame = CGRectZero;
        qrCodeFrameView.hidden = YES;
        return;
    }
    // Get the metadata object.
    AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
    if ([metadataObj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
        // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
        AVMetadataMachineReadableCodeObject *barCodeObject = (AVMetadataMachineReadableCodeObject *)[videoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadataObj];
        qrCodeFrameView.frame = barCodeObject.bounds;
        qrCodeFrameView.hidden = NO;
        [self performSelector:@selector(timerFired:) withObject:metadataObj.stringValue afterDelay:1.0];
//        if (metadataObj.stringValue) {
//            //Override for implementation of delegate
//            if (!yaSeLlamoElDelegate) {
//                [self performSelector:@selector(timerFired:) withObject:metadataObj.stringValue afterDelay:1.0];
//                yaSeLlamoElDelegate = YES;
//            }
//        }
    }
}

-(void) timerFired:(NSString *)information {
    NSLog(@"%@",information);
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    
//    alert.showAnimationType = SlideInToCenter;
//    alert.hideAnimationType = SlideOutFromCenter;
//    
//    alert.backgroundType = Transparent;
//    alert.customViewColor=[UIColor redColor];
//    alert.labelTitle.font=[UIFont fontWithName:@"Dosis-Bold" size:18.0];
//    
//    [alert showWaiting:self title:@"Esperando..."
//              subTitle:@""
//      closeButtonTitle:nil duration:100.0f];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    
//    int i=0;
//    for (int j=0; j<[self.idProducts count]; j++) {
//        if ([self.idProducts[j] intValue] == 8) {
//            i=i+([self.numberOfProducts[j] intValue]*4);
//        }else if([self.idProducts[j] intValue] == 9){
//            i=i+([self.numberOfProducts[j] intValue]*2);
//        }else if([self.idProducts[j] intValue] == 10){
//            i=i+([self.numberOfProducts[j] intValue]*2);
//        }else if([self.idProducts[j] intValue] == 11){
//            i=i+([self.numberOfProducts[j] intValue]*4);
//        }else if([self.idProducts[j] intValue] == 12){
//            i=i+([self.numberOfProducts[j] intValue]*4);
//        }else if([self.idProducts[j] intValue] == 13){
//            i=i+([self.numberOfProducts[j] intValue]*4);
//        }else if([self.idProducts[j] intValue] == 14){
//            i=i+([self.numberOfProducts[j] intValue]*2);
//        }else if([self.idProducts[j] intValue] == 15){
//            i=i+([self.numberOfProducts[j] intValue]*4);
//        }else{
//            i=i+[self.numberOfProducts[j] intValue];
//        }
//    }
//    
//    NSDictionary*parameters=@{@"id":information,
//                              @"products":self.idProducts,
//                              @"number":self.numberOfProducts,
//                              @"total":[NSString stringWithFormat:@"%i",i],
//                              @"shop":@"1"};
//    //NSLog(@"parameter: %@",parameters);
//    
//    [manager POST:@"http://dacodes.com/kukis/api/checkout.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary*temp=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        [alert hideView];
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        
//        alert.circleIconImageView.image=[UIImage imageNamed:@"Pin"];
//        alert.labelTitle.font=[UIFont fontWithName:@"Dosis-Bold" size:18.0];
//        alert.viewText.font=[UIFont fontWithName:@"Oswald-Regular" size:16.0];
//        alert.customViewColor=[UIColor redColor];
//        [alert addButton:@"Agregar" actionBlock:^(void) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"ResetData" object:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//        [alert showEdit:self title:@"Kukis" subTitle:[NSString stringWithFormat:@"Se añadieron exitosamente %i puntos",i] closeButtonTitle:nil duration:0.0f];
//        NSLog(@"JSON: %@", temp);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error, id responseObject) {
//        //NSLog(@"Error: %@", [error description]);
//        [alert hideView];
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        alert.labelTitle.font=[UIFont fontWithName:@"Dosis-Bold" size:18.0];
//        alert.viewText.font=[UIFont fontWithName:@"Oswald-Regular" size:16.0];
//        alert.shouldDismissOnTapOutside=YES;
//        [alert showError:self title:@"Error"
//                subTitle:@"No se pudo registrar la compra"
//        closeButtonTitle:@"Aceptar" duration:0.0f];
//    }];
    //[self.delegate manipulateQRInformation:information];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
