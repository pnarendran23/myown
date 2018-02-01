//
//  PSPDFActivityViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@class PSPDFActivityViewController;

@protocol PSPDFActivityViewControllerDelegate <NSObject>

- (BOOL)activityViewController:(PSPDFActivityViewController *)activityViewController shouldPerformActivity:(UIActivity *)activity;

@end

/// Initialize with `PSPDFDocument` object as `activityItems` or directly with title/URL/NSData.
@interface PSPDFActivityViewController : UIActivityViewController

/// Custom activity delegate that allows to control if an activity should be performed.
@property (nonatomic, weak) id <PSPDFActivityViewControllerDelegate> delegate;

@end
