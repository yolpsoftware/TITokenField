//
//  TokenFieldExampleAppDelegate.m
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import "TokenFieldExampleAppDelegate.h"
#import "TokenTableMainViewController.h"
#import "TITokenTableViewController.h"
#import "TokenTableExampleViewController.h"

@implementation TokenFieldExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    TokenTableMainViewController * viewController = [[TokenTableMainViewController alloc] initWithType:YES andPrompt:@"Hello:"];
	viewController.tokenDataSource = viewController;
    viewController.delegate = viewController;

	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [window setRootViewController:navigationController];

	
    [window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UINavigationController* nav = (UINavigationController*)window.rootViewController;
    TokenTableMainViewController* exampleViewController = (TokenTableMainViewController*)[nav.viewControllers objectAtIndex:0];
    NSArray* tokens = [exampleViewController getTokens];
}

@end