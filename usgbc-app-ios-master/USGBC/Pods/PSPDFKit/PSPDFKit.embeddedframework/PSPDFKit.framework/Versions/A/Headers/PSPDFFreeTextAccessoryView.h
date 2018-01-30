//
//  PSPDFFreeTextAccessoryView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFToolbar.h"
#import "PSPDFFontPickerViewController.h"
#import "PSPDFFontSizePickerController.h"
#import "PSPDFAnnotationStyleViewController.h"

@class PSPDFFreeTextAnnotation;
@class PSPDFFreeTextAccessoryView;
@class PSPDFToolbarButton;
@class PSPDFToolbarSelectableButton;
@class PSPDFToolbarSeparatorButton;
@protocol PSPDFPresentationContext;

@protocol PSPDFFreeTextAccessoryViewDelegate <NSObject>

@optional

// Called when the done button is pressed.
// You should resign first responder status at this point.
- (void)doneButtonPressedOnFreeTextAccessoryView:(PSPDFFreeTextAccessoryView *)inputView;

// Called when the clear text button is pressed.
// Use this to clear the text field and update the annotation.
- (void)clearButtonPressedOnFreeTextAccessoryView:(PSPDFFreeTextAccessoryView *)inputView;

// Show the text inspector (relevant only if the inspector button is used - only on iPhone by default).
- (PSPDFAnnotationStyleViewController *)freeTextAccessoryViewDidRequestInspector:(PSPDFFreeTextAccessoryView *)inputView;

// Allow or reject a property change. Assumes always YES if left unimplemented.
- (BOOL)freeTextAccessoryView:(PSPDFFreeTextAccessoryView *)styleController shouldChangeProperty:(NSString *)propertyName;

// Called whenever a style property of `PSPDFFreeTextAccessoryView` changes.
// Use this to also update the annotation bounding box and view frames as needed.
- (void)freeTextAccessoryView:(PSPDFFreeTextAccessoryView *)styleController didChangeProperty:(NSString *)propertyName;

@end

// Notification when someone presses "Clear".
extern NSString *const PSPDFFreeTextAccessoryViewDidPressClearButtonNotification;

/// Free Text accessory toolbar for faster styling.
@interface PSPDFFreeTextAccessoryView : PSPDFToolbar <PSPDFFontPickerViewControllerDelegate, PSPDFFontSizePickerControllerDelegate, PSPDFAnnotationStyleViewControllerDelegate>

/// Designated initializer.
/// @see annotation, presentationContext and delegate
- (instancetype)initAnnotation:(PSPDFFreeTextAnnotation *)annotation delegate:(id<PSPDFFreeTextAccessoryViewDelegate>)delegate presentationContext:(id <PSPDFPresentationContext>)presentationContext NS_DESIGNATED_INITIALIZER;

/// The input accessory delegate.
@property (nonatomic, weak) id<PSPDFFreeTextAccessoryViewDelegate> delegate;

/// Used to present popover pickers for certain button types.
@property (nonatomic, weak) id <PSPDFPresentationContext> presentationContext;

/// The annotation that is being edited.
@property (nonatomic, strong) PSPDFFreeTextAnnotation *annotation;

/// @name Styling

/// Whether a thing border should be added just above the accessory view. Defaults to YES.
@property (nonatomic, assign, getter=isBorderVisible) BOOL borderVisible;

/// The color for the default separators and border.
@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

@end

@interface PSPDFFreeTextAccessoryView (SubclassingHooks)

// By default the accessory view buttons differ based on the available toolbar width.
// Use this to customize the button order or fixate a certain set of buttons.
// @note The defaut arrays include `PSPDFToolbarSeparatorButton` and `PSPDFToolbarSpacerButton` objects.
- (NSArray *)buttonsForWidth:(CGFloat)width;

// Default toolbar buttons
@property (nonatomic, strong, readonly) PSPDFToolbarButton *fontNameButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *fontSizeButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *increaseFontSizeButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *decreaseFontSizeButton;
@property (nonatomic, strong, readonly) PSPDFToolbarSelectableButton *leftAlignButton;
@property (nonatomic, strong, readonly) PSPDFToolbarSelectableButton *centerAlignButton;
@property (nonatomic, strong, readonly) PSPDFToolbarSelectableButton *rightAlignButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *colorButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *clearButton;
@property (nonatomic, strong, readonly) PSPDFToolbarButton *doneButton;

@end
