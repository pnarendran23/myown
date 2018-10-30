//
//  PSPDFKit.h
//  PSPDFKit
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Availability.h>
#import <AVFoundation/AVFoundation.h>
#import "PSPDFUmbrellaHeader.h"
#import "PSPDFLicenseManager.h"
#import "PSPDFApplicationPolicy.h"
#import "PSPDFFileManager.h"
#import "PSPDFMacros.h"

/// X-Callback URL, see http://x-callback-url.com
/// @note This is used for the Chrome activity in `PSPDFWebViewController`.
extern NSString *const PSPDFXCallbackURLStringKey;

/// The identifier for the multimedia class, evulated in `PSPDFMultimediaAnnotationView`.
extern NSString *const PSPDFMultimediaIdentifierKey;

/// Set to `@ YES` to disable the use of `WKWebView` when available.
extern NSString *const PSPDFWebKitLegacyModeKey;


@protocol PSPDFSettings <NSObject>

// Allow generic array access.
- (id)objectForKeyedSubscript:(id)key;

// Shortcut that returns booleans.
- (BOOL)boolForKey:(NSString *)key;

@end


/// Configuration object for various framework-global settings.
/// @note The PSPDFKit singleton is a global, thread-safe key/value store.
/// Use `setValue:forKey:` and `valueForKey:` or the subscripted variants to set/get properties.
@interface PSPDFKit : NSObject <PSPDFSettings>

/// The shared PSPDFKit configuration instance.
/// @note This is the default instance used in document and pdf controller instances.
+ (instancetype)sharedInstance;

/// Activate PSPDFKit with your license key from https://customers.pspdfkit.com
+ (void)setLicenseKey:(NSString *)licenseKey;

/// Returns the PSPDFKit version string.
@property (nonatomic, copy, readonly) NSString *version;

/// Returns the PSPDFKit version date.
@property (nonatomic, copy, readonly) NSDate *compiledAt;

/// Allows to test against specific features. Can test multiple features at once via the bitmask.
+ (BOOL)isFeatureEnabled:(PSPDFFeatureMask)feature;

/// Allow direct dictionary-like access. The `key` must be of type `NSString`.
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// Controls various security-related aspects and allows to enable/disable features based on the security settings.
@property (nonatomic, strong, readonly) id<PSPDFApplicationPolicy> policy;

/// The common file manager object.
@property (nonatomic, strong, readonly) id<PSPDFFileManager> fileManager;

/// The shared memory/file cache.
@property (nonatomic, strong, readonly) PSPDFCache *cache;

/// The PDF render coordinator.
@property (nonatomic, strong, readonly) id<PSPDFRenderManager> renderManager;

/// The annotation style manager.
@property (nonatomic, strong, readonly) id<PSPDFAnnotationStyleManager> styleManager;

/// The global speech synthesizer object.
@property (nonatomic, strong, readonly) PSPDFSpeechController *speechSynthesizer;

/// The stylus manager. Lazily loaded.
@property (nonatomic, strong, readonly) PSPDFStylusManager *stylusManager;

/// The default library. You can override this property to use a custom `PSPDFLibrary` as the default
/// library. It is recommended that you do this early in your application launch. Defaults to an
/// unencrypted library by default or to `nil` if the FTS feature is not enabled in the license.
@property (atomic, strong) PSPDFLibrary *library;

/// An encryption provider for databases. Defaults to `nil`. You must set this property
/// before using any database encryption features. See `PSPDFDatabaseEncryptionProvider` for more
/// information on how to implement this.
@property (atomic, strong) id<PSPDFDatabaseEncryptionProvider> databaseEncryptionProvider;

// Various PSPDFKit objects require dependencies. Use this helper to automatically connect them.
// Will only set known objects that are not already set.
- (NSUInteger)injectDependentProperties:(id)object;

@end
