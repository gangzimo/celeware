

#import <UIKit/UIKit.h>
#import <mach/mach_host.h>
#import <dlfcn.h>


extern void TWEAK();
extern NSDictionary *ITEMS();



#define kFakIDPlist			@"/Library/MobileSubstrate/DynamicLibraries/FakID.plist"


//
#ifdef DEBUG
#define _Log(s, ...)	\
{	\
NSLog(s, ##__VA_ARGS__); 	\
NSString *str = [NSString stringWithFormat:s, ##__VA_ARGS__];	\
puts(str.UTF8String);	\
}
/*FILE *fp = fopen("/private/var/mobile/FakID.log", "a");	\
 if (fp)	\
 {	\
 fputs(str.UTF8String, fp);	\
 fputs("\n", fp);	\
 fclose(fp);	\
 }*/
#define _LogLine()		_Log(@"FakID:%s:%u", __FUNCTION__, __LINE__)
#define _LogObj(obj)	if (obj) _Log(@"FakID:%s:%u => %@ => %@", __FUNCTION__, __LINE__, NSStringFromClass([obj class]), obj)
#else
#define _Log(s, ...)	((void) 0)
#define _LogLine()		((void) 0)
#define _LogObj(obj)	((void) 0)
#endif

