//
//  FirebaseHelper.h
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 7/16/15.
//  Copyright (c) 2015 Napkn Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FirebaseHelper : NSObject

+ (Firebase *)baseFirebaseReference;
+ (Firebase *)userFirebaseReference;
+ (BOOL)userIsLoggedIn;
+ (void)logUserOut;
+ (NSString *)userUID;
+ (BOOL)stringIsValidEmail:(NSString *)string;

@end
