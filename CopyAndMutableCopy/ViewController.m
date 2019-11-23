//
//  ViewController.m
//  CopyAndMutableCopy
//
//  Created by Helios on 2019/11/17.
//  Copyright © 2019 Helios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self StringCopyMethond];
//    [self mutStringCopyMethond];
//    [self NSArrayCopyMethond];
    [self NSMutableArrayCopyMethond];
}

#pragma mark - NSString - copy与mutablecopy的区别
- (void)StringCopyMethond{
    
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:@"mutString"];
    NSString *origin = [NSString stringWithString:mutStr];
    
    NSString *copyStr = [origin copy];
    NSMutableString *mutCyStr = [origin mutableCopy];
    
    //观察
    NSLog(@"原始地址:%p -%@",origin,origin);           //原始地址:    0x8c4305717c2099f2 -mutString
    NSLog(@"copyStr 地址:%p -%@",copyStr,copyStr);    //copyStr 地址:0x8c4305717c2099f2 -mutString
    NSLog(@"mutCyStr 地址:%p -%@",mutCyStr,mutCyStr); //mutCyStr 地址:0x6000033d3900 -mutString
    
    //做修改
    [mutStr appendString:@" AppendStrAAAA"];
    [mutCyStr appendString:@" MutAppendStrBBBB"];
    
    //观察
    NSLog(@"修改后 - 原始地址:%p -%@",origin,origin);          //修改后 - 原始地址:    0x8c4305717c2099f2 -mutString
    NSLog(@"修改后 - copyStr 地址:%p -%@",copyStr,copyStr);   //修改后 - copyStr 地址:0x8c4305717c2099f2 -mutString
    NSLog(@"修改后 - mutCyStr 地址:%p -%@",mutCyStr,mutCyStr);//修改后 - mutCyStr 地址:0x6000033d3900 -mutString MutAppendStrBBBB

//结论：对于NSString(不可变字符串),copy之后的其实就是本身(浅拷贝)，而mutableCopy会将整个对象拷贝一份（深拷贝）
}

#pragma mark - NSMutableString - copy与mutablecopy的区别
- (void)mutStringCopyMethond{
    
    NSMutableString *mutTestString = [NSMutableString stringWithString:@"mutTest"];
    
    NSMutableString *mutOriginStr = [[NSMutableString alloc] initWithString:mutTestString];
    NSString *copyString = [mutOriginStr copy];
    NSMutableString *mutString = [mutOriginStr mutableCopy];
    
    //观察
    NSLog(@"原始地址：%p  -  :%@",mutOriginStr,mutOriginStr); //原始地址：0x6000031453b0  -  :mutTest
    NSLog(@"copy地址：%p  -  :%@",copyString,copyString);    //copy地址：0xc01efd2c4acc75a4  -  :mutTest
    NSLog(@"mutCopy地址：%p  -  :%@",mutString,mutString);   //mutCopy地址：0x6000031454d0  -  :mutTest
    
    //做修改
    [mutTestString appendString:@"xxxx"];
    [mutOriginStr appendString:@"ooooo"];
    [mutString appendString: @"iiiiiii"];
    
    //观察
    NSLog(@"修改后 - 原始地址：%p  -  :%@",mutOriginStr,mutOriginStr);//修改后 - 原始地址：0x6000031453b0  -  :mutTestooooo
    NSLog(@"修改后 - copy地址：%p  -  :%@",copyString,copyString);   //修改后 - copy地址：0xc01efd2c4acc75a4  -  :mutTest
    NSLog(@"修改后 - mutCopy地址：%p  -  :%@",mutString,mutString);  //修改后 - mutCopy地址：0x6000031454d0  -  :mutTestiiiiiii

//结论：对于NSMutableString(可变字符串)，copy,mutableCopy 都会将整个对象重新拷贝(深拷贝)
    
    //问题：为什么修饰nsstring属性要使用copy？
    /*
     答：
     NSMutableString *mStr = [NSMutableString stringWithFormat:@"mutablestring----"];
     self.name = mStr;
     [mStr appendString:@"addstriing"];//name的修饰符为copy时，name的结果为mutablestring----
     NSLog(@"%@",mStr);                //name的修饰符为strong时，name的结果为mutablestring----addstriing
     NSLog(@"%@",self.name);
     
     copy的含义是指当重新赋值时"深拷贝新对象"再赋值给self.name
     相反当修饰符为strong时，因为strong的意思是指针指向原对象，并且引用计数+1，所以self.name和mStr指向同一个对象
     */
}

#pragma mark - NSArray - copy与mutablecopy的区别
- (void)NSArrayCopyMethond{
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"obj1",@"obj2",@"obj3",nil];
//    NSArray *originArr = [NSArray arrayWithObject:array]; //集合对象
    NSArray *originArr = [NSArray arrayWithArray:array];    //非集合对象
    NSArray *copyArr = [originArr copy];
    NSMutableArray *mutableArr = [originArr mutableCopy];
    
    NSLog(@"原始数组:%p - %@",originArr,originArr);
    NSLog(@"原始数组的第一个元素:%p - %@",originArr[0],originArr[0]);
    
    NSLog(@"copy数组:%p - %@",copyArr,copyArr);
    NSLog(@"copy数组的第一个元素:%p - %@",copyArr[0],copyArr[0]);
    
    NSLog(@"mutableCopy数组:%p - %@",mutableArr,mutableArr);
    NSLog(@"mutableCopy数组的第一个元素:%p - %@",mutableArr[0],mutableArr[0]);
    
    [array addObject:@"newObj"];
    [mutableArr addObject:@"newObjs"];
    
    NSLog(@"修改后 - 原始数组:%p - %@",originArr,originArr);
    NSLog(@"修改后 - copy数组:%p - %@",copyArr,copyArr);
    NSLog(@"修改后 - mutableCopy数组:%p - %@",mutableArr,mutableArr);
//结论：
//NSArray中，集合对象,与 非集合对象 一毛一样：
// copy 是 指针拷贝，元素对象也是指针拷贝，MutableCopy 是 深拷贝，元素对象是指针拷贝
}

#pragma mark - NSMutableArray - copy与mutablecopy的区别
- (void)NSMutableArrayCopyMethond{
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"obj1",@"obj2",@"obj3",nil];
//    NSMutableArray *originArr = [NSMutableArray arrayWithArray:array]; //非集合对象
    NSMutableArray *originArr = [NSMutableArray arrayWithObject:array]; //集合对象
    NSArray *copyArr = [originArr copy];
    NSMutableArray *mutableArr = [originArr mutableCopy];
    
    NSLog(@"原始数组:%p - %@",originArr,originArr);
    NSLog(@"原始数组的第一个元素:%p - %@",originArr[0],originArr[0]);
    
    NSLog(@"copy数组:%p - %@",copyArr,copyArr);
    NSLog(@"copy数组的第一个元素:%p - %@",copyArr[0],copyArr[0]);
    
    NSLog(@"mutableCopy数组:%p - %@",mutableArr,mutableArr);
    NSLog(@"mutableCopy数组的第一个元素:%p - %@",mutableArr[0],mutableArr[0]);
    
    [array addObject:@"newObj"];
    [mutableArr addObject:@"newObjs"];
    
    NSLog(@"修改后 - 原始数组:%p - %@",originArr,originArr);
    NSLog(@"修改后 - copy数组:%p - %@",copyArr,copyArr);
    NSLog(@"修改后 - mutableCopy数组:%p - %@",mutableArr,mutableArr);
    
//结论：
//NSMutableArray中
//集合对象   : copy 是 深拷贝，元素对象是浅拷贝；MutableCopy 是 深拷贝，元素对象是浅拷贝
//非集合对象 : copy 是 深拷贝，元素对象是浅拷贝；MutableCopy 是 深拷贝，元素对象是浅拷贝
}

#pragma mark - Block 与 Copy

/*

 block的三种类型。

 1._NSConcreteGlobalBlock,全局的静态block，不会访问外部的变量。就是说如果你的block没有调用其他 的外部变量，
 那你的block类型就是这种。例如：你仅仅在你的block里面写一个NSLog("hello world");

 2._NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。这个block就是你声明的时候不用c opy修饰，
 并且你的block访问了外部变量。

 3._NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。好了，这个就是今天的主角 ，
 用copy修饰的block。 我们知道，函数的声明周期是随着函数调用的结束就终止了。我们的block是写在函数中的。

  

 如果是全局静态block的话，他直到程序结束的时候，才会被被释放。
 但是我们实际操作中基本上不会使用到不访问外部变量的block。

 【但是在测试三种区别的时候，因为没有很好的理解这种block，（用没有copy修饰和没有访问外部变量的block）试了好多次，
 以为是放在静态区里面的block没有随函数结束被释放。这是个小坑】

 如果是保存在栈中的block，他会随着函数调用结束被销毁。
 从而导致我们在执行一个包含block的函数之后，就无法再访问这个block。
 因为（函数结束，函数栈就销毁了，存在函数里面的block也就没有了），我们再使用block时，就会产生空指针异常。

 如果是堆中的block，也就是copy修饰的block。他的生命 周期就是随着对象的销毁而结束的。
 只要对象不销毁，我们就可以调用的到在堆中的block。 这就是为什么我们要用copy来修饰block。
 */

@end
