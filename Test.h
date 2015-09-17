//
//  Test.h
//  
//
//  Created by Zach Whelchel on 9/17/15.
//
//

#import <Realm/Realm.h>

@interface Test : RLMObject
<# Add properties here to define the model #>
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Test>
RLM_ARRAY_TYPE(Test)
