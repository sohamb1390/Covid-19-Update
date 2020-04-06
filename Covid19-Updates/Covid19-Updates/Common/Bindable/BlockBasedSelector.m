//
//  BlockBasedSelector.m
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

#import "BlockBasedSelector.h"
#import <objc/runtime.h>

@implementation BlockBasedSelector
@end

void class_addMethodWithBlock(Class class, SEL newSelector, OBJCBlock block) {
    IMP newImplementation = imp_implementationWithBlock(block);
    Method method = class_getInstanceMethod(class, newSelector);
    class_addMethod(class, newSelector, newImplementation,  method_getTypeEncoding(method));
}
