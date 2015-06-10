//
//  HTDelegateProxy.m
//  HotelTonight
//
//  Created by Jacob Jennings on 10/21/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//
/*
 Copyright (c) 2012 Hotel Tonight
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "HTDelegateProxy.h"

@implementation HTDelegateProxy

@synthesize delegates = _delegates;

- (id)initWithDelegates:(NSArray *)delegates
{
    [self setDelegates:delegates];
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature;
    for (id nonRetainedValue in _delegates)
    {
//        id delegate = [nonRetainedValue nonretainedObjectValue];
        signature = [[nonRetainedValue class] instanceMethodSignatureForSelector:selector];
        if (signature)
        {
            break;
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *returnType = [NSString stringWithCString:invocation.methodSignature.methodReturnType encoding:NSUTF8StringEncoding];
    BOOL voidReturnType = [returnType isEqualToString:@"v"];
    
    for (id nonRetainedValue in _delegates)
    {
//        id delegate = [nonRetainedValue nonretainedObjectValue];
        if ([nonRetainedValue respondsToSelector:invocation.selector])
        {
            [invocation invokeWithTarget:nonRetainedValue];
            if (!voidReturnType)
            {
                return;
            }
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    for (id nonRetainedValue in _delegates)
    {
//        id delegate = [nonRetainedValue nonretainedObjectValue];
        if ([nonRetainedValue respondsToSelector:aSelector])
        {
            if ([nonRetainedValue isKindOfClass:[UITextField class]]
                && [[UITextField class] instancesRespondToSelector:aSelector])
            {
                continue;
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - Properties

- (void)setDelegates:(NSArray *)delegates
{
    _delegates = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    
    for (id delegate in delegates)
    {
        [_delegates addPointer:(void *)delegate];
    }
}

@end
