//
//  PSPDFNetworkActivityIndicatorManager.h
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

// Posted whenever any network activity in PSPDFKit starts.
extern NSString *const PSPDFNetworkActivityDidStartNotification;

// Posted whenever any network activity in PSPDFKit finishes (that is, either completes or fails).
extern NSString *const PSPDFNetworkActivityDidFinishNotification;

// The network indicator manager will track the number of currently open network request.
@protocol PSPDFNetworkActivityIndicatorManager <NSObject>

// A Boolean value indicating whether the manager is enabled.
// This flag defines if the `networkActivityIndicatorVisible` in the shared application is updated.
// @note Requests are always tracked, regardless of this setting.
// Defaults to YES.
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

// Indicates if the network activity indicator is currently visible.
@property (readonly, nonatomic, assign) BOOL isNetworkActivityIndicatorVisible;

// Increments the number of active network requests.
- (void)incrementActivityCount;

// Decrements the number of active network requests.
- (void)decrementActivityCount;

@end

// Thread safe implementation of the network activity indicator protocol.
@interface PSPDFDefaultNetworkActivityIndicatorManager : NSObject <PSPDFNetworkActivityIndicatorManager>
@end
