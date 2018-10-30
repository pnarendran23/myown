//
//  PSPDFFontSizePickerController.h
//  PSPDFKit
//
//  Copyright (c) 2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"
#import "PSPDFOverridable.h"

@class PSPDFFontSizePickerController;

/// Delegate for `PSPDFFontSizePickerController`, calls back when a font size is selected.
@protocol PSPDFFontSizePickerControllerDelegate <PSPDFOverridable>

/// Called whenever a font size selection is made.
- (void)fontSizePickerController:(PSPDFFontSizePickerController *)controller didSelectFontSize:(CGFloat)fontSize;

@end

/// Font size picker. Allows quick font size changes.
@interface PSPDFFontSizePickerController : PSPDFBaseTableViewController

/// An array of integer `NSNumber` values for the desired font sizes.
/// Provides a list of common font sizes by default.
@property (nonatomic, copy) NSArray *fontSizes;

/// The font size picker delegate - notifies when a font size is selected.
@property (nonatomic, weak) id<PSPDFFontSizePickerControllerDelegate> delegate;

@end
