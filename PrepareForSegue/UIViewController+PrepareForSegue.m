//
//  UIViewController+PrepareForSegue.m
//  PrepareForSegue
//
//  Created by Anton Sergeev on 12.12.2017.
//  Copyright © 2017 Anton Sergeev. All rights reserved.
//

#import "UIViewController+PrepareForSegue.h"
#import <objc/runtime.h>

@implementation UIViewController (PrepareForSegue)

+ (void)load {
  Class class = [self class];

  SEL originalSelector = @selector(prepareForSegue:sender:);
  SEL swizzledSelector = @selector(as_prepareForSegue:sender:);

  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

  method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)as_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSString *identifier = segue.identifier;
  NSString *selectorString = [NSString stringWithFormat:@"prepareFor%@:sender:", identifier];
  SEL selector = NSSelectorFromString(selectorString);
  if (identifier.length > 0 && [self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector withObject:segue withObject:sender];
#pragma clang diagnostic pop
  } else {
#ifdef DEBUG
    if (identifier.length > 0) {
      NSLog(@"Warning: performing segue with identifier \"%@\" without custom preparing.", identifier);
    }
#endif
    [self as_prepareForSegue:segue sender:sender];
  }
}

@end
