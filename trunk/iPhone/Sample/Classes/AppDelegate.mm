
#import "AppDelegate.h"


//
@implementation AppDelegate
@synthesize window=_window;
@synthesize controller=_controller;

#pragma mark Generic methods

// Destructor
- (void)dealloc
{
	[_controller release];
	[_window release];
	[super dealloc];
}

//
#ifdef _MobClick
- (NSString *)appKey
{
	return NSUtil::BundleInfo(@"MobClickKey");
}
#endif


#pragma mark Monitoring Application State Changes

// The application has launched and may have additional launch options to handle.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef _MobClick
	[MobClick setDelegate:self];
	[MobClick appLaunched];
#endif
	
	// Create window
	CGRect frame = UIUtil::ScreenFrame();
	frame.origin.y = 0;
	_window = [[UIWindow alloc] initWithFrame:frame];

	// Create controller
	UIViewController *controller = [[UIViewController alloc] init];
	_controller = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];

	// Show main view
	[_window addSubview:_controller.view];
	[_window makeKeyAndVisible];

	UIUtil::ShowStatusBar(YES);
	UIUtil::ShowSplashView(controller.view);
	
	return YES;
}

// The application is about to terminate.
- (void)applicationWillTerminate:(UIApplication *)application
{
#ifdef _MobClick
	[MobClick appTerminated];
#endif
}

// Tells the delegate that the application is about to become inactive.
- (void)applicationWillResignActive:(UIApplication *)application
{
#ifdef _MobClick
	[MobClick appTerminated];
#endif
}

// The application has become active.
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//}

// Tells the delegate that the application is about to enter the foreground.
- (void)applicationWillEnterForeground:(UIApplication *)application
{
#ifdef _MobClick
	[MobClick setDelegate:self];
	[MobClick appLaunched];
#endif
}

// Tells the delegate that the application is now in the background.
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//}


#pragma mark Managing Status Bar Changes

//The interface orientation of the status bar is about to change.
//- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
//{
//}

// The interface orientation of the status bar has changed.
//- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
//{
//}

// The frame of the status bar is about to change.
//- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
//{
//}

// The frame of the status bar has changed.
//- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
//{
//}


#pragma mark Responding to System Notifications

// There is a significant change in the time.
//- (void)applicationSignificantTimeChange:(UIApplication *)application
//{
//}

// The application receives a memory warning from the system.
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
//{
//}

// Open a resource identified by URL.
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//	return NO;
//}

@end
