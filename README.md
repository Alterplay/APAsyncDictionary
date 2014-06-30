<img src="https://dl.dropboxusercontent.com/u/2334198/APAsyncDictionary-git-teaser.png">

APAsyncDictionary is a wrapper on [NSMutableDictionary](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/Reference/Reference.html) that performs actions in own [dispatch queue](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html) and return results to caller's thread. And it could be very useful when application uses `dictionary` concurrently from different threads.

[![Build Status](https://travis-ci.org/Alterplay/APAsyncDictionary.png?branch=master)](https://travis-ci.org/Alterplay/APAsyncDictionary)

#### Features
* Thread safety
* Get object for key asynchronously
* Set object for key
* Set objects and keys from any `NSDictionary`
* Remove object for key
* Remove objects for `NSArray` of keys
* Remove all objects for all keys
* Get objects count asynchronously
* Get all keys asynchronously
* Get all objects asynchronously

#### Installation
Add `APAsyncDictionary` pod to Podfile

#### Using

```objective-c
// instantiation
APAsyncDictionary *dictionary = [[APAsyncDictionary alloc] init];
...
// get object for key
__block id someObject;
[dictionary objectForKey:@"key" callback:^(id <NSCopying> key, id object)
{
    someObject = object;
    // do something with object
}];
...
// get object for key synchronously
someObject = [dictionary objectForKeySynchronously:@"key"];
...
// set object
[dictionary setObject:object forKey:@"key"];
...
// set objects and keys from dictionary
[dictionary setObjectsAndKeysFromDictionary:@{@"key1" : object1, @"key2" : object2}];
...
// remove object for key
[dictionary removeObjectForKey:@"key"];
...
// remove objects for keys from array
[dictionary removeObjectsForKeys:@[@"key1", @"key2"]];
...
// remove all objects
[dictionary removeAllObjects];
...
// get objects count
[dictionary objectsCountCallback:^(NSUInteger count)
{
    // do something with count    
}];
...
// get objects count synchronously
NSUInteger count = [dictionary objectsCountSynchronously];
...
// all keys
[dictionary allKeysCallback:^(NSArray *keys)
{
    // do something with keys
}];
...
// all objects
[dictionary allObjectsCallback:^(NSArray *objects)
{
    // do something with objects
}];
```

#### History

**Version 0.0.6**
* Improved read access performance

**Version 0.0.5**
* Fixed Analyzer warning

**Version 0.0.4**
* Added method to get object for key synchronously
* Added method to get objects count synchronously

**Version 0.0.3**
* Public release

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/6766cbe79673060fa2c0ec4291519ad0 "githalytics.com")](http://githalytics.com/Alterplay/APAsyncDictionary)
======================
If you have improvements or concerns, feel free to post [an issue](https://github.com/Alterplay/APAsyncDictionary/issues) and write details.

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APAsyncDictionary) with other ideas and projects.
