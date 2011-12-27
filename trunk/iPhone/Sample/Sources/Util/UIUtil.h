

#import <UIKit/UIKit.h>


//
@class AppDelegate;
class UIUtil
{
#pragma mark Device methods
public:	
	// 
	NS_INLINE UIDevice *Device()
	{
		return [UIDevice currentDevice];
	}
	
	// 
	NS_INLINE NSString *DeviceID()
	{
		return Device().uniqueIdentifier;
	}
	
	// 
	NS_INLINE float SystemVersion()
	{
		return [[Device() systemVersion] floatValue];
	}
	
	//
	NS_INLINE BOOL IsPad()
	{
		return [Device() userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	}

	//
	NS_INLINE BOOL IsRetina()
	{
		return ScreenScale() == 2;
	}
	
	//
	NS_INLINE UIScreen *Screen()
	{
		return [UIScreen mainScreen];
	}

	//
	NS_INLINE CGFloat ScreenScale()
	{
		return Screen().scale;
	}

	//
	NS_INLINE CGRect AppFrame()
	{
		return Screen().applicationFrame;
	}
	
	//
	NS_INLINE CGSize ScreenSize()
	{
		CGRect frame = AppFrame();
		return CGSizeMake(frame.size.width, frame.size.height + frame.origin.y);
	}
	
	//
	NS_INLINE CGRect ScreenFrame()
	{
		CGRect frame = AppFrame();
		frame.size.height += frame.origin.y;
		frame.origin.y = 0;
		return frame;
	}
	
	
#pragma mark Application methods
public:
	// 
	NS_INLINE UIApplication *Application()
	{
		return [UIApplication sharedApplication];
	}
	
	//
	NS_INLINE AppDelegate *Delegate()
	{
		return (AppDelegate *)Application().delegate;
	}
	
	//
	NS_INLINE BOOL CanOpenURL(NSString *url)
	{
		return [Application() canOpenURL:[NSURL URLWithString:url]];
	}
	
	//
	NS_INLINE BOOL OpenURL(NSString *url)
	{
		return [Application() openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	}
	
	//
	NS_INLINE BOOL MakeCall(NSString *number, BOOL direct = NO)
	{
		NSString *url = [NSString stringWithFormat:@"tel:%@", [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSURL *URL = [NSURL URLWithString:url];
		
		// Try alternate call method (Result in a call with alert box, and back to apptioncation after hung)
		if (!direct && [Application() canOpenURL:URL])
		{
			static UIWebView *webView = nil;
			if (webView == nil)
			{
				webView = [[UIWebView alloc] initWithFrame:CGRectZero];
				webView.hidden = YES;
			}
			if (webView.superview == nil)	// To avoid key window reborn
			{
				[KeyWindow() addSubview:webView];
			}
			[webView loadRequest:[NSURLRequest requestWithURL:URL]];
			return YES;
		}

		BOOL ret = [Application() openURL:URL];
		if (ret == NO)
		{
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not make call on this device.", @"在此设备上无法拨打电话。")
																 message:nil
																delegate:nil
													   cancelButtonTitle:NSLocalizedString(@"Dismiss", @"关闭")
													   otherButtonTitles:nil] autorelease];
			[alertView show];
		}
		return ret;
	}
	
	//
	NS_INLINE UIWindow *KeyWindow()
	{
		return Application().keyWindow;
	}

	//
	NS_INLINE BOOL IsWindowLandscape()
	{
		CGSize size = KeyWindow().frame.size;
		return size.width > size.height;
	}
	
	//
	NS_INLINE void ShowStatusBar(BOOL show = YES, UIStatusBarAnimation animated = UIStatusBarAnimationFade)
	{
		[Application() setStatusBarHidden:!show withAnimation:animated];
	}

	//
	NS_INLINE void ShowNetworkIndicator(BOOL show = YES)
	{
		static NSUInteger _ref = 0;
		if (show)
		{
			if (_ref == 0) Application().networkActivityIndicatorVisible = YES;
			_ref++;
		}
		else
		{
			if (_ref != 0) _ref--;
			if (_ref == 0) Application().networkActivityIndicatorVisible = NO;
		}
	}

	//
	static UIImageView *ShowSplashView(UIView *fadeInView = nil);
	
#pragma mark Debug methods
public:	
	// Print log with indent
	static void PrintIndentString(NSUInteger indent, NSString *str);

	// Print controller and sub-controllers
	static void PrintController(UIViewController *controller, NSUInteger indent = 0);
	
	// Print view and subviews
	static void PrintView(UIView *view, NSUInteger indent = 0);
};