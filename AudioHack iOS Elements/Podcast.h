//
//  Podcast.h
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import <Realm/Realm.h>
#import "Show.h"

@interface Podcast : RLMObject
@property NSString *name;
@property NSString *refreshSource;
@property int refreshSourceSpecificId;
@property RLMArray<Show *><Show> *shows;
@end

RLM_ARRAY_TYPE(Podcast)
