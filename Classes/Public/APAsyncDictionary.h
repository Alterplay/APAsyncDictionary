//
//  APAsyncDictionary.h
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAsyncDictionary : NSObject
{
    dispatch_queue_t queue;
}

// set objects
- (void)setObject:(id)object forKey:(id <NSCopying>)key;
- (void)setObjectsAndKeysFromDictionary:(NSDictionary *)dictionary;
// get object
- (void)objectForKey:(id <NSCopying>)key callback:(void(^)(id <NSCopying> key, id object))callback;
// remove objects
- (void)removeObjectForKey:(id <NSCopying>)key;
- (void)removeObjectsForKeys:(NSArray *)keys;
- (void)removeAllObjects;

@end
