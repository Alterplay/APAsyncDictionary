//
//  NSThread+Block.m
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import "NSThread+Block.h"

@implementation NSThread (Block)

- (void)performBlockOnThread:(void(^)())block
{
    [self performSelector:@selector(performBlock:) onThread:self withObject:block waitUntilDone:NO];
}

- (void)performBlock:(void(^)())block
{
    block ? block() : nil;
}

@end
