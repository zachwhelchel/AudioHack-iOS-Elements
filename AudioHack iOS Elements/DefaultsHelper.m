//
//  DefaultsHelper.m
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import "DefaultsHelper.h"

#define kFirstLaunch @"kFirstLaunch"

@implementation DefaultsHelper

+ (BOOL)isFirstLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunch];
}

+ (void)setFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
