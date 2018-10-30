//
//  PSPDFSavedAnnotationsViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationGridViewController.h"
#import "PSPDFStyleable.h"

/// Protocol for the annotation store implementation.
@protocol PSPDFAnnotationSetStore <NSObject>

/// The annotation set to read/write.
@property (nonatomic, copy) NSArray *annotationSets;

@end

// A default store that saves annotations into the keychain.
@interface PSPDFKeychainAnnotationSetsStore : NSObject <PSPDFAnnotationSetStore> @end


/// Shows an editable grid of saved annotation sets.
@interface PSPDFSavedAnnotationsViewController : PSPDFAnnotationGridViewController <PSPDFAnnotationGridViewControllerDataSource, PSPDFStyleable>

/// The default `PSPDFKeychainAnnotationSetsStore`, used if no custom store is set.
+ (id <PSPDFAnnotationSetStore>)sharedAnntationStore;

/// Designated initializer.
- (instancetype)initWithDelegate:(id<PSPDFAnnotationGridViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// The store object that gets called when annotations are changed. Set to use the controller.
@property (nonatomic, strong) id<PSPDFAnnotationSetStore> annotationStore;

@end

@interface PSPDFSavedAnnotationsViewController (SubclassingHooks)

// Updates the toolbar.
- (void)updateToolbarAnimated:(BOOL)animated;

@end
