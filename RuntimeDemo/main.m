//
//  main.m
//  RuntimeDemo
//
//  Created by Edward on 16/7/20.
//  Copyright © 2016年 Yonyouup ChaoKe Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else 
#import <objc/runtime.h>
#import <objc/message.h>
#endif

void sayFunction(id self, SEL _cmd, id value) {
  NSLog(@"%@岁的%@说: %@", object_getIvar(self, class_getInstanceVariable([self class], "_age")), [self valueForKey:@"name"], value);
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      // insert code here...
    
    Class People = objc_allocateClassPair([NSObject class], "Person", 0);
    
    class_addIvar(People, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
    class_addIvar(People, "_age", sizeof(int), sizeof(int), @encode(int));
    
    SEL s = sel_registerName("say:");
    class_addMethod(People, s, (IMP)sayFunction, "v@:@");
    
    objc_registerClassPair(People);
    
    id peopleInstance = [[People alloc] init];
    [peopleInstance setValue:@"小泽玛利亚" forKey:@"name"];
    
    Ivar ageIvar = class_getInstanceVariable(People, "_age");
    object_setIvar(peopleInstance, ageIvar, @18);
    
    ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"大家好");
    
    peopleInstance = nil;
    objc_disposeClassPair(People);
  }
    return 0;
}

