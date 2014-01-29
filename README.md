APAsyncDictionary
============

#### About
APAsyncDictionary is a wrapper on [NSMutableDictionary](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/Reference/Reference.html) that performs actions in own [serial queue](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html) and return results to caller's thread. And it could be very useful when application uses `dictionary` concurrently from different threads.

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
// objects count
[dictionary objectsCountCallback:^(NSUInteger count)
{
    // do somethig with count    
}];
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

#### Contacts

[Check out](https://github.com/Alterplay) all Alterplay's GitHub projects.
[Email us](mailto:hello@alterplay.com?subject=From%20GitHub%20APPhotolibrary) with other ideas and projects.
