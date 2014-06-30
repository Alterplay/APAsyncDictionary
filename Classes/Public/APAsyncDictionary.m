//
//  APAsyncDictionary.m
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "APAsyncDictionary.h"
#import "NSThread+Block.h"

@interface APAsyncDictionary ()
{
    dispatch_queue_t _queue;
}

@property (nonatomic, readonly) NSMutableDictionary *dictionary;
@end

@implementation APAsyncDictionary

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
        NSString *name = [NSString stringWithFormat:@"com.alterplay.APAsyncDictionary.%ld",
                          (unsigned long)self.hash];
        _queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding],
                                       DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - set objects

- (void)setObject:(id)object forKey:(id <NSCopying>)key
{
    [self runDictionaryAsynchronousWriteBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary setObject:object forKey:key];
    }];
}

- (void)setObjectsAndKeysFromDictionary:(NSDictionary *)aDictionary
{
    [self runDictionaryAsynchronousWriteBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary addEntriesFromDictionary:aDictionary];
    }];
}

#pragma mark - get object

- (void)objectForKey:(id <NSCopying>)key callback:(void (^)(id <NSCopying> key, id object))callback
{
    __weak NSThread *weakThread = NSThread.currentThread;
    [self runDictionaryAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        id object = [dictionary objectForKey:key];
        [NSThread performOnThread:weakThread block:^
        {
            callback ? callback(key, object) : nil;
        }];
    }];
}

- (id)objectForKeySynchronously:(id <NSCopying>)key
{
    __block id object;
    [self runDictionarySynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        object = [dictionary objectForKey:key];
    }];
    return object;
}

#pragma mark - remove objects

- (void)removeObjectForKey:(id <NSCopying>)key
{
    [self runDictionaryAsynchronousWriteBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeObjectForKey:key];
    }];
}

- (void)removeObjectsForKeys:(NSArray *)keys
{
    [self runDictionaryAsynchronousWriteBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeObjectsForKeys:keys];
    }];
}

- (void)removeAllObjects
{
    [self runDictionaryAsynchronousWriteBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeAllObjects];
    }];
}

#pragma mark - count

- (void)objectsCountCallback:(void (^)(NSUInteger count))callback
{
    __weak NSThread *weakThread = NSThread.currentThread;
    [self runDictionaryAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        NSUInteger count = dictionary.count;
        [NSThread performOnThread:weakThread block:^
        {
            callback ? callback(count) : nil;
        }];
    }];
}

- (NSUInteger)objectsCountSynchronously
{
    __block NSUInteger count = 0;
    [self runDictionarySynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        count = dictionary.count;
    }];
    return count;
}


#pragma mark - all keys/objects

- (void)allKeysCallback:(void (^)(NSArray *keys))callback
{
    __weak NSThread *weakThread = NSThread.currentThread;
    [self runDictionaryAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        NSArray *array = [dictionary allKeys];
        [NSThread performOnThread:weakThread block:^
        {
            callback ? callback(array) : nil;
        }];
    }];
}

- (void)allObjectsCallback:(void (^)(NSArray *objects))callback
{
    __weak NSThread *weakThread = NSThread.currentThread;
    [self runDictionaryAsynchronousReadBlock:^(NSMutableDictionary *dictionary)
    {
        NSArray *array = [dictionary allValues];
        [NSThread performOnThread:weakThread block:^
        {
            callback ? callback(array) : nil;
        }];
    }];
}

#pragma mark - private

- (void)runDictionaryAsynchronousReadBlock:(void(^)(NSMutableDictionary *dictionary))operationBlock
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(_queue, ^
    {
        operationBlock && weakSelf.dictionary ? operationBlock(weakSelf.dictionary) : nil;
    });
}

- (void)runDictionaryAsynchronousWriteBlock:(void(^)(NSMutableDictionary *dictionary))operationBlock
{
    __weak __typeof(self) weakSelf = self;
    dispatch_barrier_async(_queue, ^
    {
        operationBlock && weakSelf.dictionary ? operationBlock(weakSelf.dictionary) : nil;
    });
}

- (void)runDictionarySynchronousReadBlock:(void(^)(NSMutableDictionary *dictionary))operationBlock
{
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(_queue, ^
    {
        operationBlock && weakSelf.dictionary ? operationBlock(weakSelf.dictionary) : nil;
    });
}

@end
