//
//  NSThread+Block.h
//  APAsyncDictionary
//
//  Created by Alexey Belkevich on 1/15/14.
//  Copyright (c) 2014 alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Block)

+ (void)performOnThread:(NSThread *)thread block:(void (^)())block;

@end
