//
//  PSPDFExternalURLHandler.h
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

@protocol PSPDFExternalURLHandler <NSObject>

// Handles URL, shows alert dialog if this would open an external app.
// Returns NO if this is an internal URL (http[s]://, file://)
- (BOOL)handleExternalURL:(NSURL *)URL completionBlock:(void (^)(BOOL switchedApplication))completionBlock;

@end
