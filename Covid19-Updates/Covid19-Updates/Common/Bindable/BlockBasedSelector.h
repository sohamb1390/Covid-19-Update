//
//  BlockBasedSelector.h
//  Covid19-Updates
//
//  Created by Soham Bhattacharjee on 12/11/19.
//  Copyright © 2019 Soham Bhattacharjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockBasedSelector : NSObject

@end

typedef void (^OBJCBlock)(id selector);

void class_addMethodWithBlock(Class class, SEL newSelector, OBJCBlock block);
