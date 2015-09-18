//
//  Show.h
//  AudioHack iOS Elements
//
//  Created by Zach Whelchel on 9/17/15.
//  Copyright © 2015 Zach Whelchel. All rights reserved.
//

#import <Realm/Realm.h>

@interface Show : RLMObject
@property NSString *name;
@property NSString *showDescription;
@property int duration;
@property NSString *mp3URL;
@property NSString *originalAirDate;
@property NSString *informationURL;
@property NSString *photoURL;
@end

RLM_ARRAY_TYPE(Show)
