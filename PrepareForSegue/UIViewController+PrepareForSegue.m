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
  [self as_exchangeMethodImplementationOfClass:self
                                oldSelector:@selector(prepareForSegue:sender:)
                                newSelector:@selector(as_prepareForSegue:sender:)];
  [self as_exchangeMethodImplementationOfClass:self
                                oldSelector:@selector(shouldPerformSegueWithIdentifier:sender:)
                                newSelector:@selector(as_shouldPerformSegueWithIdentifier:sender:)];
}

+ (void)as_exchangeMethodImplementationOfClass:(Class)class
                                        oldSelector:(SEL)oldSelector
                                        newSelector:(SEL)newSelector {
  Method oldMethod = class_getInstanceMethod(class, oldSelector);
  Method newMethod = class_getInstanceMethod(class, newSelector);

  method_exchangeImplementations(oldMethod, newMethod);
}

#pragma mark - Segue Methods

- (void)as_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSString *identifier = segue.identifier;
  NSString *selectorString = [NSString stringWithFormat:@"prepareFor%@:sender:", identifier];
  SEL selector = NSSelectorFromString(selectorString);
  if ( !(identifier.length > 0) || ![self respondsToSelector:selector]) {
#ifdef DEBUG
    if (identifier.length > 0) {
      NSLog(@"Warning: performing segue with identifier \"%@\" without custom preparing.", identifier);
    }
#endif
    [self as_prepareForSegue:segue sender:sender];
    return;
  }
  NSMethodSignature *signature = [self methodSignatureForSelector:selector];
  BOOL signatureIsValid = [self as_validateMethodSignature:signature
                                                returnType:@encode(void)
                                         firstArgumentType:@encode(id)
                                        secondArgumentType:@encode(id)];
  if (!signatureIsValid) {
    [self as_prepareForSegue:segue sender:sender];
    return;
  }

  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  invocation.target = self;
  invocation.selector = selector;
  [invocation setArgument:&segue atIndex:2];
  [invocation setArgument:&sender atIndex:3];
  [invocation invoke];
}

- (BOOL)as_shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  NSString *selectorString = [NSString stringWithFormat:@"shouldPerform%@WithSender:", identifier];
  SEL selector = NSSelectorFromString(selectorString);
  if ( !(identifier.length > 0) || ![self respondsToSelector:selector]) {
    return [self as_shouldPerformSegueWithIdentifier:identifier sender:sender];
  }
  NSMethodSignature *signature = [self methodSignatureForSelector:selector];
  BOOL signatureIsValid = [self as_validateMethodSignature:signature
                                                returnType:@encode(BOOL)
                                              argumentType:@encode(id)];
  if (!signatureIsValid) {
    return [self as_shouldPerformSegueWithIdentifier:identifier sender:sender];
  }

  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  invocation.target = self;
  invocation.selector = selector;
  [invocation setArgument:&sender atIndex:2];
  [invocation invoke];
  BOOL shouldPerform;
  [invocation getReturnValue:&shouldPerform];

  return shouldPerform;
}

#pragma mark - Validate Signature

- (BOOL)as_validateMethodSignature:(NSMethodSignature *)signature
                        returnType:(char *)returnType
                      argumentType:(char *)argumentType {
  char *testSignatureString = (char *)malloc(4 * sizeof(char));
  sprintf(testSignatureString, "%s%s%s%s", returnType, @encode(id), @encode(SEL), argumentType);
  NSMethodSignature *testSignature = [NSMethodSignature signatureWithObjCTypes:testSignatureString];
  free(testSignatureString);

  return [signature isEqual:testSignature];
}

- (BOOL)as_validateMethodSignature:(NSMethodSignature *)signature
                        returnType:(char *)returnType
                 firstArgumentType:(char *)firstArgumentType
                secondArgumentType:(char *)secondArgumentType {
  char *testSignatureString = (char *)malloc(5 * sizeof(char));
  sprintf(testSignatureString, "%s%s%s%s%s", returnType, @encode(id), @encode(SEL), firstArgumentType, secondArgumentType);
  NSMethodSignature *testSignature = [NSMethodSignature signatureWithObjCTypes:testSignatureString];
  free(testSignatureString);

  return [signature isEqual:testSignature];
}

@end
