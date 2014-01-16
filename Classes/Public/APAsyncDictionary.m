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
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation APAsyncDictionary

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dictionary = [[NSMutableDictionary alloc] init];
        NSString *name = [NSString stringWithFormat:@"com.alterplay.APAsyncDictionary.%d", self.hash];
        queue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }
    return self;
}

#pragma mark - set objects

- (void)setObject:(id)object forKey:(id <NSCopying>)key
{
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary setObject:object forKey:key];
    }];
}

- (void)setObjectsAndKeysFromDictionary:(NSDictionary *)aDictionary
{
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary addEntriesFromDictionary:aDictionary];
    }];
}

#pragma mark - get object

- (void)objectForKey:(id <NSCopying>)key callback:(void (^)(id <NSCopying> key, id object))callback
{
    __weak NSThread *currentThread = NSThread.currentThread;
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        id object = [dictionary objectForKey:key];
        [currentThread performBlockOnThread:^
        {
            callback ? callback(key, object) : nil;
        }];
    }];
}

#pragma mark - remove objects

- (void)removeObjectForKey:(id <NSCopying>)key
{
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeObjectForKey:key];
    }];
}

- (void)removeObjectsForKeys:(NSArray *)keys
{
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeObjectsForKeys:keys];
    }];
}

- (void)removeAllObjects
{
    [self runDictionaryOperationBlock:^(NSMutableDictionary *dictionary)
    {
        [dictionary removeAllObjects];
    }];
}

#pragma mark - private

- (void)runDictionaryOperationBlock:(void(^)(NSMutableDictionary *dictionary))operationBlock
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(queue, ^
    {
        operationBlock && weakSelf.dictionary ? operationBlock(weakSelf.dictionary) : nil;
    });
}

@end
