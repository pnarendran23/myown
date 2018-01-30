//
//  PSPDFActionExecutor.h
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
#import "PSPDFControlDelegate.h"
#import "PSPDFExternalURLHandler.h"
#import "PSPDFWebViewController.h"
#import "PSPDFApplication.h"
#import "PSPDFFileManager.h"
#import "PSPDFApplicationPolicy.h"
#import <MessageUI/MessageUI.h>

@class PSPDFActionExecutor, PSPDFURLAction, PSPDFDocument, PSPDFAnnotation;
@protocol PSPDFAnnotationViewProtocol, PSPDFFormSubmissionDelegate;

@protocol PSPDFActionExecutorDelegate <PSPDFPageControls, PSPDFErrorHandler, PSPDFExternalURLHandler, PSPDFFormSubmissionDelegate>

- (UIView <PSPDFAnnotationViewProtocol> *)annotationViewForAnnotation:(PSPDFAnnotation *)annotation;

- (void)presentPreviewControllerForURL:(NSURL *)fileURL title:(NSString *)title options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)presentPDFViewControllerWithDocument:(PSPDFDocument *)document options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated configurationBlock:(void (^)(PSPDFViewController *pdfController))configurationBlock completion:(void (^)(void))completion;

@optional

// Some actions will create a document to present; this is a hook that allows customizing the object.
- (PSPDFDocument *)actionExecutor:(PSPDFActionExecutor *)actionExecuter documentForRelativePath:(NSString *)relativePath;

// If the executor finds an URL, you can decide the behavior. Default is `PSPDFLinkActionInlineBrowser` if not implemented.
- (PSPDFLinkAction)actionExecutor:(PSPDFActionExecutor *)actionExecuter linkActionForAction:(PSPDFURLAction *)URLAction;

@end

@class PSPDFAction, PSPDFDocument;

// Executes PDF actions.
// Actions can do a lot in PDF; from changing the page/document to opening the print sheet.
@interface PSPDFActionExecutor : NSObject

- (instancetype)initWithDocument:(PSPDFDocument *)document NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) PSPDFDocument *document;

@property (nonatomic, weak) id <PSPDFActionExecutorDelegate> delegate;

@property (nonatomic, weak, readonly) UIViewController <PSPDFPresentationActions> *presentationController;

- (BOOL)executePDFAction:(PSPDFAction *)action targetRect:(CGRect)targetRect page:(NSUInteger)page animated:(BOOL)animated actionContainer:(id)actionContainer;

// Feature hooks needed. Can be injected from the PSPDFKit shared instance.
@property (nonatomic, strong) id<PSPDFApplication> application;
@property (nonatomic, strong) id<PSPDFFileManager> fileManager;
@property (nonatomic, strong) id<PSPDFApplicationPolicy> policy;

@end
