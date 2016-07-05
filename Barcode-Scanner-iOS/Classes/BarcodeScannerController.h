//
//  BarcodeScanController.h
//  BarcodeScanningExample
//
//  Created by Rupak Parikh on 04/07/16.
//  Copyright © 2016 Avira Operations GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarcodeScannerControllerDelegate;

@interface BarcodeScannerController : UIViewController
@property (nonatomic, weak) id<BarcodeScannerControllerDelegate> delegate;
- (id)initWithDelegate:(id)delegate;
@end

@protocol BarcodeScannerControllerDelegate <NSObject>

@optional
- (void) scanViewController:(BarcodeScannerController *)scannerController didSuccessfullyScan:(NSString *) aScannedValue;
@end
