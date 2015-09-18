//
//  PodcastManager.m
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import "PodcastManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFOAuth2Manager.h"
#import "AFHTTPRequestSerializer+OAuth2.h"

@implementation PodcastManager

+ (RLMResults *)podcasts
{
    return [Podcast allObjects];
}

+ (void)addInitialPodcasts
{
    // Add This American Life
    Podcast *thisAmericanLifePodcast = [PodcastManager addPodcast:[NSDictionary dictionaryWithObjectsAndKeys:@"This American Life", @"name", @"tal", @"refreshSource", nil] inputSource:@"manual"];
    [PodcastManager refreshShowListForPodcast:thisAmericanLifePodcast];
    
    // Add other initial podcasts if there are any.
}

+ (Podcast *)addPodcast:(NSDictionary *)podcastDictionary inputSource:(NSString *)inputSource
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    Podcast *newPodcast = [[Podcast alloc] init];

    if ([inputSource isEqualToString:@"manual"]) {
        
        // We've added this podcast manually. Likely from the App Delegate.
        
        newPodcast.name = [podcastDictionary valueForKey:@"name"];
        newPodcast.refreshSource = [podcastDictionary valueForKey:@"refreshSource"];
        newPodcast.refreshSourceSpecificId = 0;
        
    }
    else if ([inputSource isEqualToString:@"audiosearch"]) {
        
        // This podcast comes from audiosear.ch so we'll parse it in accordingly.

        newPodcast.name = [podcastDictionary valueForKey:@"title"];
        newPodcast.refreshSource = inputSource;
        newPodcast.refreshSourceSpecificId = [[podcastDictionary valueForKey:@"id"] intValue];

    }
    
    // For now we'll be uniquing podcasts based on their name since ids will be different from different APIs.

    RLMResults *podcastsWithSameName = [Podcast objectsWhere:[NSString stringWithFormat:@"name = '%@'", newPodcast.name]];
    
    for (Podcast *podcast in podcastsWithSameName) {
        
        // We've found an object that already exists with this name. So delete it. This is because a new version might have new info.

        NSLog(@"Deleting a podcast and its shows:%@", podcast.name);
        
        [realm beginWriteTransaction];
        for (Show *show in podcast.shows) {
            [realm deleteObject:show];
        }
        [realm deleteObject:podcast];
        [realm commitWriteTransaction];
    }
    
    if (newPodcast.name) {
        
        // If we have a name then one of the about setup sections was called. And we've made sure to take out any duplicates. So lets add this one in!
        
        NSLog(@"Adding a podcast:%@", newPodcast.name);

        [realm transactionWithBlock:^{
            [realm addObject:newPodcast];
        }];
        
        return newPodcast;
    }
    
    return nil;
}

+ (Show *)addShow:(NSDictionary *)showDictionary forPodcast:(Podcast *)podcast refreshSource:(NSString *)refreshSource
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    Show *newShow = [[Show alloc] init];
    
    if ([refreshSource isEqualToString:@"tal"]) {
        
        // This show comes from This American Life so we'll parse it in accordingly.
        
        newShow.name = [showDictionary valueForKey:@"title"];
        newShow.showDescription = [showDictionary valueForKey:@"description"];
        newShow.duration = [[showDictionary valueForKey:@"duration"] intValue];
        newShow.mp3URL = [showDictionary valueForKey:@"mp3"];
        newShow.originalAirDate = [showDictionary valueForKey:@"original_air_date"];
        newShow.informationURL = [showDictionary valueForKey:@"url"];
        newShow.photoURL = [showDictionary valueForKey:@"photo"];
        
    }
    else if ([refreshSource isEqualToString:@"audiosearch"]) {
        
        // This show comes from audiosear.ch so we'll parse it in accordingly.
        
        // Not all of these are the same... so this import code works with some and crashes others. 😓
        // Or possibly it was adding multiples in a row that did it. Need to test still...

        newShow.name = [showDictionary valueForKey:@"title"];
        newShow.showDescription = [showDictionary valueForKey:@"description"];
        newShow.duration = [[showDictionary valueForKey:@"duration"] intValue]; // This isn't working? Perhaps the above duration is broken also?
        newShow.mp3URL = [[[[showDictionary valueForKey:@"audio_files"] valueForKey:@"url"] firstObject] firstObject];
        newShow.originalAirDate = [showDictionary valueForKey:@"date_added"];
        newShow.informationURL = [showDictionary valueForKey:@"digital_location"];
        newShow.photoURL = [[[[showDictionary valueForKey:@"image_files"] valueForKey:@"url"] firstObject] valueForKey:@"full"];

    }
    
    for (Show *show in podcast.shows) {
        
        if ([show.name isEqualToString:newShow.name]) {
            
            // This podcast has a show with the same name. Let's delete it to make sure there are no duplicates. The new one might have new info too! So lets keep the new one.
            
            NSLog(@"Deleting a show:%@ for podcast:%@", show.name, podcast.name);
            
            [realm beginWriteTransaction];
            [realm deleteObject:show];
            [realm commitWriteTransaction];
        }
    }
    
    if (newShow.name) {
        
        // If we have a name then one of the about setup sections was called. And we've made sure to take out any duplicates. So lets add this one in!
        
        NSLog(@"Adding a show:%@ for podcast:%@", newShow.name, podcast.name);
        
        [realm transactionWithBlock:^{
            [podcast.shows addObject:newShow];
            [realm addObject:newShow];
        }];
        
        return newShow;
    }
    
    return nil;
}

+ (void)refreshShowListForPodcast:(Podcast *)podcast
{
    if ([podcast.refreshSource isEqualToString:@"tal"]) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:@"http://hackathon.thisamericanlife.org/api/episodes" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (NSDictionary *show in [responseObject valueForKey:@"data"]) {
                [PodcastManager addShow:show forPodcast:podcast refreshSource:podcast.refreshSource];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    else if ([podcast.refreshSource isEqualToString:@"audiosearch"]) {
        
        NSURL *baseURL = [NSURL URLWithString:@"https://www.audiosear.ch/api/shows/361"];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kAudioSearchIdentifier];
        [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        
        [manager GET:[NSString stringWithFormat:@"/api/shows/%i", podcast.refreshSourceSpecificId]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 // We'll get back a list of ids with this.
                 
                 for (NSNumber *number in [responseObject valueForKey:@"episode_ids"]) {

                     [manager GET:[NSString stringWithFormat:@"/api/episodes/%i", [number intValue]]
                       parameters:nil
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              
                              [PodcastManager addShow:responseObject forPodcast:podcast refreshSource:podcast.refreshSource];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Failure: %@", error);
                          }];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Failure: %@", error);
             }];
        
    }
}

@end
