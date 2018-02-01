//
//  PSPDFControlDelegate.h
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
#import "PSPDFConfiguration.h"
#import "PSPDFPresentationActions.h"
#import "PSPDFErrorHandler.h"

@class PSPDFAction, PSPDFDocument, PSPDFDocumentActionExecutor;

@protocol PSPDFPageControls <NSObject>

- (void)setDocument:(PSPDFDocument *)document;

- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

// Execute actions
- (BOOL)executePDFAction:(PSPDFAction *)action targetRect:(CGRect)targetRect page:(NSUInteger)page animated:(BOOL)animated actionContainer:(id)actionContainer;
- (void)searchForString:(NSString *)searchText options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated;

- (PSPDFDocumentActionExecutor *)documentActionExecutor;

- (UIViewController *)presentDocumentInfoViewControllerWithOptions:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)reloadData;

@end

@protocol PSPDFHUDControls <NSObject>

- (BOOL)hideControlsAnimated:(BOOL)animated;
- (BOOL)hideControlsForUserScrollActionAnimated:(BOOL)animated;
- (BOOL)hideControlsAndPageElementsAnimated:(BOOL)animated;
- (BOOL)toggleControlsAnimated:(BOOL)animated;
- (BOOL)shouldShowControls;
- (BOOL)showControlsAnimated:(BOOL)animated;
- (void)showMenuIfSelectedAnimated:(BOOL)animated allowPopovers:(BOOL)allowPopovers;

@end

@protocol PSPDFControlDelegate <PSPDFPresentationActions, PSPDFPageControls, PSPDFHUDControls>
@end
