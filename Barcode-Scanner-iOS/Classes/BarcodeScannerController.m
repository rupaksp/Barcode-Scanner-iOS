//
//  BarcodeScanController.m
//  BarcodeScanningExample
//
//  Created by Rupak Parikh on 04/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import "BarcodeScannerController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeScannerController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    //AVCapture
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_deviceInput;
    AVCaptureMetadataOutput *_metadataOutput;
    AVCaptureVideoPreviewLayer *_videoPrevLayer;
    
    //UI Related
    UIView *_barcodeHighlightView;
}
@property (nonatomic, assign) BOOL shouldSendReadBarcodeToDelegate;

@end

@implementation BarcodeScannerController


- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.shouldSendReadBarcodeToDelegate=YES;
        [self setupUserInterface];
    }
    return self;
}
-(void)setupUserInterface{
    
    _barcodeHighlightView = [[UIView alloc] init];
    _barcodeHighlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _barcodeHighlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _barcodeHighlightView.layer.borderWidth = 6;
    [self.view addSubview:_barcodeHighlightView];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_deviceInput) {
        [_session addInput:_deviceInput];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_metadataOutput];
    
    _metadataOutput.metadataObjectTypes = [_metadataOutput availableMetadataObjectTypes];
    
    _videoPrevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoPrevLayer.frame = self.view.bounds;
    _videoPrevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_videoPrevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_barcodeHighlightView];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_videoPrevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            [self performSelector:@selector(detectionFinishWithValue:) withObject:detectionString afterDelay:1.0];
            break;
        }
    }
    
    _barcodeHighlightView.frame = highlightViewRect;

}
-(void)detectionFinishWithValue:(NSString*)scannedValue{
    
    if (!self.shouldSendReadBarcodeToDelegate)
    {
        //this means we have already captured at least one event, then we don't want   to call the delegate again
        return;
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        if([self.delegate respondsToSelector:@selector(scanViewController:didSuccessfullyScan:)]) {
            [self.delegate scanViewController:self didSuccessfullyScan:scannedValue];
        }
        self.shouldSendReadBarcodeToDelegate = NO;
    }
}

@end
