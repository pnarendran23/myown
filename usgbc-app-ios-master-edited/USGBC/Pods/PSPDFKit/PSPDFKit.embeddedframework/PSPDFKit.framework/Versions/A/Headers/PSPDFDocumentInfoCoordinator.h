//
//  PSPDFDocumentInfoCoordinator.h
//  PSPDFKit
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSPDFDocument;
@protocol PSPDFPresentationActions;

typedef NS_ENUM(NSUInteger, PSPDFOutlineBarButtonItemOption) {
    /// The outline (Table of Contents) controller.
    PSPDFOutlineBarButtonItemOptionOutline,

    /// Bookmark list controller.
    PSPDFOutlineBarButtonItemOptionBookmarks,

    /// Annotation list controller. Requires `PSPDFFeatureMaskAnnotationEditing`.
    PSPDFOutlineBarButtonItemOptionAnnotations,

    /// Embedded Files. Requires `PSPDFFeatureMaskAnnotationEditing`.
    PSPDFOutlineBarButtonItemOptionEmbeddedFiles
};


@interface PSPDFDocumentInfoCoordinator : NSObject

@property (nonatomic, strong) PSPDFDocument *document;

// Prenset view controller on `targetController`.
- (id)presentToViewController:(UIViewController <PSPDFPresentationActions> *)targetController options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

// Checks if there's data to present.
- (BOOL)isAvailable;

/// Choose the controller type.
/// Defaults to `PSPDFOutlineBarButtonItemOptionOutline, PSPDFOutlineBarButtonItemOptionAnnotations, PSPDFOutlineBarButtonItemOptionBookmarks, PSPDFOutlineBarButtonItemOptionEmbeddedFiles`.
/// @note Change this before the controller is being displayed.
@property (nonatomic, copy) NSOrderedSet *availableControllerOptions;

/// Called after a controller has been created. Set a block to allow custom modifications.
/// This sets the delegate of the controllers by default. If you set a cystom block, ensure to call the previous implementation.
@property (nonatomic, copy) void (^didCreateControllerBlock)(UIViewController *controller, PSPDFOutlineBarButtonItemOption option);

@end

@interface PSPDFDocumentInfoCoordinator (SubclassingHooks)

// Subclass both to allow adding/customizing controllers.
- (NSString *)titleForOption:(PSPDFOutlineBarButtonItemOption)option;

// Subclass to allow early controller customization.
- (UIViewController *)controllerForOption:(PSPDFOutlineBarButtonItemOption)option;

// Is used internally to filter unavailable options.
- (BOOL)isOptionAvailable:(PSPDFOutlineBarButtonItemOption)option;

@end
