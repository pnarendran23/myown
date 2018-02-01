//
//  AWSIdentityManager.h
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
#import <Foundation/Foundation.h>
#import "AWSSignInProvider.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const AWSIdentityManagerDidSignInNotification;
FOUNDATION_EXPORT NSString *const AWSIdentityManagerDidSignOutNotification;

@interface AWSIdentityManager : NSObject<AWSIdentityProviderManager>

/**
 * Indicates whether the user is signed-in or not.
 * @return true if user is signed-in
 */
@property (nonatomic, readonly, getter=isLoggedIn) BOOL loggedIn;

/**
 * URL for the user's image, if user is signed-in with a third party identity provider,
 * like Facebook or Google.
 * @return url of image file, if user is signed-in
 */
@property (nonatomic, readonly, nullable) NSURL * imageURL;

/**
 * User name acquired from third party identity provider, such as Facebook or Google.
 * @return user name, if user is signed-in
 */
@property (nonatomic, readonly, nullable) NSString * userName;

/**
 * Amazon Cognito User Identity ID. This uniquely identifies the user, regardless of
 * whether or not the user is signed-in, if User Sign-in is enabled in the project.
 * @return unique user identifier
 */
@property (nonatomic, readonly, nullable) NSString *identityId;

/**
 * Amazon Cognito Credentials Provider. This is the credential provider used by the Identity Manager.
 *
 * @return the cognito credentials provider
 */
@property (nonatomic, readonly, strong) AWSCognitoCredentialsProvider *credentialsProvider;

/**
 Returns the Identity Manager singleton instance configured using the information provided in `Info.plist` file.
 
 *Swift*
 
 let identityManager = AWSIdentityManager.defaultIdentityManager()
 
 *Objective-C*
 
 AWSIdentityManager *identityManager = [AWSIdentityManager defaultIdentityManager];
 */
+ (instancetype)defaultIdentityManager NS_SWIFT_NAME(defaultIdentityManager());

/**
 * Signs the user out of whatever third party identity provider they used to sign in.
 * @param completionHandler used to callback application with async operation results
 */
- (void)logoutWithCompletionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;

/**
 * Signs the user in with an identity provider. Note that even if User Sign-in is not
 * enabled in the project, the user is still signed-in with the Guest type provider.
 * @param signInProviderType provider type
 * @param completionHandler used to callback application with async operation results
 */
- (void)loginWithSignInProvider:(id<AWSSignInProvider>)signInProvider
              completionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;


/**
 * Attempts to resume session with the previous sign-in provider.
 * @param completionHandler used to callback application with async operation results
 */
- (void)resumeSessionWithCompletionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler;

/**
 * Passes parameters used to launch the application to the current identity provider. For some
 * third party providers, this completes the User Sign-in call flow, which used a browser to
 * get information from the user, directly. The current sign-in provider will be set to nil if
 * the sign-in provider is not registered using `registerAWSSignInProvider:forKey` method  of 
 * `AWSSignInProviderFactory` class.
 * @param application application
 * @param launchOptions options used to launch the application
 * @return true if this call handled the operation
 */
- (BOOL)interceptApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;

/**
 * Passes parameters used to launch the application to the current identity provider. For some
 * third party providers, this completes the User Sign-in call flow, which used a browser to
 * get information from the user, directly.
 * @param application application
 * @param url url used to open the application
 * @param sourceApplication source application
 * @param annotation annotation
 * @return true if this call handled the operation
 */
- (BOOL)interceptApplication:(UIApplication *)application
                     openURL:(NSURL *)url
           sourceApplication:(nullable NSString *)sourceApplication
                  annotation:(id)annotation;

@end

NS_ASSUME_NONNULL_END
