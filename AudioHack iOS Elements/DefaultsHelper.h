//
//  DefaultsHelper.h
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsHelper : NSObject

+ (BOOL)isFirstLaunch;
+ (void)setFirstLaunch;

@end
