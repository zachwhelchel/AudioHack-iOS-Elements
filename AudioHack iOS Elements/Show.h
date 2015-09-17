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
@end

RLM_ARRAY_TYPE(Show)
