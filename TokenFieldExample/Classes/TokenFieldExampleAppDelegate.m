//
//  TokenFieldExampleAppDelegate.m
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import "TIContact.h"
#import "TokenFieldExampleAppDelegate.h"
#import "TokenTableMainViewController.h"
#import "TITokenTableViewController.h"
#import "TokenTableExampleViewController.h"

@implementation TokenFieldExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    TokenTableMainViewController * viewController = [[TokenTableMainViewController alloc] initWithType:YES andPrompt:@"Hello:"];
	//viewController.tokenDataSource = viewController;
    //viewController.delegate = viewController;

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [window setRootViewController:navigationController];

    [window makeKeyAndVisible];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UINavigationController* nav = (UINavigationController*)window.rootViewController;
        TokenTableMainViewController* exampleViewController = (TokenTableMainViewController*)[nav.viewControllers objectAtIndex:0];
        NSArray* array = [NSArray arrayWithObject:[TIContact contactWithName:@"Hansli Horber" email:@"076 588 52 14" label:@"iPhone"]];
        [exampleViewController initialize:array];
    });

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UINavigationController* nav = (UINavigationController*)window.rootViewController;
    TokenTableMainViewController* exampleViewController = (TokenTableMainViewController*)[nav.viewControllers objectAtIndex:0];
    NSArray* tokens = [exampleViewController getTokens];
    TIToken* tk = [tokens objectAtIndex:0];
}

@end