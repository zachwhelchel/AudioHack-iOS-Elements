//
//  PodcastManager.h
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Podcast.h"
#import "Show.h"

#define kAudioSearchIdentifier @"audiosear.ch"

@interface PodcastManager : NSObject

+ (RLMResults *)podcasts;

+ (void)addInitialPodcasts;
+ (Podcast *)addPodcast:(NSDictionary *)podcastDictionary inputSource:(NSString *)inputSource;
+ (Show *)addShow:(NSDictionary *)showDictionary forPodcast:(Podcast *)podcast refreshSource:(NSString *)refreshSource;

+ (void)refreshShowListForPodcast:(Podcast *)podcast;

@end
