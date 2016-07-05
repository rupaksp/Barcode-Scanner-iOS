//
//  BarcodeScannerViewController.m
//  Barcode-Scanner-iOS
//
//  Created by Rupak Parikh on 07/05/2016.
//  Copyright (c) 2016 Rupak Parikh. All rights reserved.
//

#import "BarcodeScannerController.h"
#import "BarcodeScannerViewController.h"

@interface BarcodeScannerViewController ()
@property (weak, nonatomic) IBOutlet UITextView* textView;

@end

@implementation BarcodeScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)scanBarcodeBtnTaped:(id)sender
{
    BarcodeScannerController* barCodeScanController = [[BarcodeScannerController alloc] initWithDelegate:self];
    [self presentViewController:barCodeScanController animated:YES completion:^{

    }];
}
#pragma mark - Barcode Controller Delegate Mathod
- (void)scanViewController:(BarcodeScannerController*)scannerController didSuccessfullyScan:(NSDictionary*)detectedValue
{
    NSLog(@"Detected Data :  %@", detectedValue);
    [self.textView setText:[detectedValue descriptionInStringsFileFormat]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
