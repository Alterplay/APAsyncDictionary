//
//  APAsyncDictionary.h
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAsyncDictionary : NSObject

// set objects
- (void)setObject:(id)object forKey:(id <NSCopying>)key;
- (void)setObjectsAndKeysFromDictionary:(NSDictionary *)dictionary;
// get object
- (void)objectForKey:(id <NSCopying>)key callback:(void(^)(id <NSCopying> key, id object))callback;
- (id)objectForKeySynchronously:(id <NSCopying>)key;
// remove objects
- (void)removeObjectForKey:(id <NSCopying>)key;
- (void)removeObjectsForKeys:(NSArray *)keys;
- (void)removeAllObjects;
// count
- (void)objectsCountCallback:(void(^)(NSUInteger count))callback;
- (NSUInteger)objectsCountSynchronously;
// all keys/objects
- (void)allKeysCallback:(void(^)(NSArray *keys))callback;
- (void)allObjectsCallback:(void(^)(NSArray *objects))callback;

@end
