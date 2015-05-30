//
//  ViewController.m
//  TestNSOperation
//
//  Created by huixinming on 5/28/15.
//  Copyright (c) 2015 huixinming. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController
{
    //NSOperationQueue *operationQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"main Thread is %p",[NSThread mainThread]);
    //[self testOperationWithQueue];
    //[self testOperationNotQueue];
    //[self testCancelOperation];
    //[self testOperationWithDependency];
    //[self testBackgroundOperation];
    [self testOperationLeaveLifeCycle];
    NSLog(@"leave operationQueue lifecycle");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testOperationWithQueue
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"blockOperation1:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"blockOperation2:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"blockOperation3:current Thread is %p",[NSThread currentThread]);
    }];
    [operationQueue addOperation:blockOperation1];
    [operationQueue addOperation:blockOperation2];
    [operationQueue addOperation:blockOperation3];
}

- (void)testOperationNotQueue
{
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation1:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation2:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation3:current Thread is %p",[NSThread currentThread]);
    }];
    [blockOperation1 start];
    [blockOperation2 start];
    [blockOperation3 start];
}

- (void)testCancelOperation
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start blockOperation1!");
        [NSThread sleepForTimeInterval:10];
        if(blockOperation1.isCancelled)
        {
            NSLog(@"blockOperation2 cancelled!");
            return;
        }
        NSLog(@"blockOperation1:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation2:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOperation3:current Thread is %p",[NSThread currentThread]);
    }];
    operationQueue.maxConcurrentOperationCount = 1;
    [operationQueue addOperation:blockOperation1];
    [operationQueue addOperation:blockOperation2];
    [operationQueue addOperation:blockOperation3];
    [NSThread sleepForTimeInterval:2];
    NSLog(@"cancel blockOperation1");
    [blockOperation1 cancel];
    NSLog(@"cancel blockOperation2");
    [blockOperation2 cancel];
    NSLog(@"cancel blockOperation3");
    [blockOperation3 cancel];
}

- (void)testOperationWithDependency
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"start blockOperation1");
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"start blockOperation2");
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"start blockOperation3");;
    }];
    [blockOperation1 addDependency:blockOperation2];
    [blockOperation2 addDependency:blockOperation3];
    [operationQueue addOperation:blockOperation1];
    [operationQueue addOperation:blockOperation2];
    [operationQueue addOperation:blockOperation3];
}
- (void)testBackgroundOperation
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:11*60];
        NSLog(@"blockOperation1:current Thread is %p",[NSThread currentThread]);
    }];
    [operationQueue addOperation:blockOperation1];
}

- (void)testOperationLeaveLifeCycle
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"blockOperation1:current Thread is %p",[NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:20];
        NSLog(@"blockOperation2:current Thread is %p",[NSThread currentThread]);
    }];
    [operationQueue addOperation:blockOperation1];
    [operationQueue addOperation:blockOperation2];
}


@end
