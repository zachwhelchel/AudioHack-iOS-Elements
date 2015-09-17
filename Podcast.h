//
//  Podcast.h
//  
//
//  Created by Zach Whelchel on 9/17/15.
//
//

#import <Realm/Realm.h>

@interface Podcast : RLMObject
<# Add properties here to define the model #>
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Podcast>
RLM_ARRAY_TYPE(Podcast)
