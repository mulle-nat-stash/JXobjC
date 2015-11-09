#import "Block.h"
#import "KVOStore.h"
#import "OCString.h"
#import "Pair.h"

@implementation KPObserver

- initWithKeyPath:kp selector:(SEL)sel observer:targ userInfo:arg
{
    [self init];
    keyPath           = kp;
    keyPathComponents = [keyPath componentsSeparatedByString:@"."];
    selector          = sel;
    observer          = targ;
    userInfo          = arg;
    return self;
}

- initWithKeyPath:kp block:blk observer:targ userInfo:arg
{
    [self init];
    keyPath           = kp;
    keyPathComponents = [keyPath componentsSeparatedByString:@"."];
    observer          = targ;
    block             = blk;
    userInfo          = arg;
    return self;
}

+ newWithKeyPath:kp selector:(SEL)sel observer:targ userInfo:arg
{
    return [[self alloc] initWithKeyPath:kp
                                selector:sel
                                observer:targ
                                userInfo:arg];
}

+ newWithKeyPath:kp block:blk observer:targ userInfo:arg
{
    return
        [[self alloc] initWithKeyPath:kp block:blk observer:targ userInfo:arg];
}

- ARC_dealloc
{
    observer          = nil;
    userInfo          = nil;
    block             = nil;
    keyPath           = nil;
    keyPathComponents = nil;
    return [super ARC_dealloc];
}

- (uintptr_t)hash
{
    return selector
               ? ((uintptr_t)selector) %
                     [Pair combineHash:[observer hash] withHash:[keyPath hash]]
               : [block hash] % [Pair combineHash:([observer hash] ?: 0x1234)
                                         withHash:[keyPath hash]];
}

- (BOOL)isEqual:anObject
{
    if (![anObject isKindOf:KPObserver])
        return NO;
    else if (([anObject matchesSelector:selector
                               observer:observer
                               userInfo:userInfo] ||
              [anObject matchesBlock:block userInfo:userInfo]) &&
             [keyPath isEqual:[anObject keyPath]])
        return YES;
    else
        return NO;
}

- (BOOL)matchesSelector:(SEL)sel observer:targ userInfo:arg
{
    if (!targ || !sel)
        return NO;
    else if (observer == targ && selector == sel && userInfo == arg)
        return YES;
    else
        return NO;
}

- (BOOL)matchesTarget:targ
{
    if (!targ)
        return NO;
    else if (observer == targ)
        return YES;
    else
        return NO;
}

- (BOOL)matchesBlock:blk userInfo:arg
{
    if (!blk)
        return NO;
    else if (block == blk && userInfo == arg)
        return YES;
    else
        return NO;
}

- (BOOL)matchesBlock:blk
{
    if (!blk)
        return NO;
    else if (block == blk)
        return YES;
    else
        return NO;
}

- (BOOL)matchesKeyPath:kp { return [keyPath isEqual:kp]; }

- (BOOL)matchesObserver:obs { return !obs ? NO : obs == observer ? YES : NO; }

- (BOOL)matchesRoot:aRoot { return !root ? NO : root == aRoot ? YES : NO; }

- setRoot:aRoot
{
    root = aRoot;
    return self;
}
- root { return root; }

- (String *)keyPath { return keyPath; }

- (OrdCltn *)keyPathComponents { return keyPathComponents; }

- (void)fireForOldValue:oldValue newValue:newValue
{
    Dictionary * changeDic = (Dictionary *)[Dictionary new];

    [changeDic atKey:@"keyPath" put:keyPath];
    [changeDic atKey:@"newValue" put:newValue];
    if (includeOldValue)
        [changeDic atKey:@"oldValue" put:oldValue];

    if (selector)
    {
        [
            {
                [observer perform:selector with:(id)changeDic];
            } ifError:
              { :msg :rcv | printf("Exception in KVO callback method.\n");
              }];
    }
    else
    {
        [block value:changeDic
             ifError:
             { :msg :rcv | printf("Exception in KVO callback block.\n");
             }];
    }

#ifndef OBJC_REFCNT
    if (includeOldValue)
        [[changeDic removeKey:@"oldValue"] free];
    [changeDic free];
#endif
}

@end

@implementation KPObserverRef
{
    /* This specifies the index within the components of a keypath that
     * this entry represents.
     * For example, if an instance is referenced for the Y.Z pair of the
    * X.Y.Z keypath, then this number is 1. */
    unsigned int pathIndex;
}

+ (KPObserverRef *)kpoRefWithKPO:(volatile id)kpo
                       pathIndex:(unsigned int)anIndex
{
    KPObserverRef * new =
        (KPObserverRef *)[[super alloc] initWithReference:kpo];
    new->pathIndex = anIndex;
    return new;
}

- (unsigned int)pathIndex { return pathIndex; }

- (uintptr_t)hash
{
    return [Pair combineHash:[reference hash] withHash:(uintptr_t)pathIndex];
}

- (BOOL)isEqual:anObject
{
    printf ("Comparing...\n");
    if (self == anObject)
        return YES;
    else if (![anObject isKindOf:KPObserverRef])
        return NO;
    return ([anObject pathIndex] == pathIndex) && [super isEqual:anObject];
}

@end