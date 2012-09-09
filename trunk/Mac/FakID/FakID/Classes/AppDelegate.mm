

#import "AppDelegate.h"
#import "FakID.h"

@implementation AppDelegate
@synthesize window;

//
- (void)load
{
	//
	SBLDFile sb(kSpringBoardFile);
	sb_imeiField.stringValue = sb.Read(0x2830);
	sb_imei2Field.stringValue = sb.Read(0x27C1, 18, NSUTF8StringEncoding);
	
	//
	SBLDFile ld(klockdowndFile);
	ld_modelField.stringValue = ld.Read(0x0D60);
	ld_snField.stringValue = ld.Read(0x0D00);
	ld_imeiField.stringValue = ld.Read(0x0D10);
	ld_regionField.stringValue = ld.Read(0x0D68);
	ld_wifiField.stringValue = ld.Read(0x0D70);
	ld_btField.stringValue = ld.Read(0x0D90);
	ld_udidField.stringValue = ld.Read(0x0D30);

	//
	SBLDFile pr(kPreferencesFile);
	pr_modelField.stringValue = pr.Read(0x1700);
	pr_snField.stringValue = pr.Read(0x1710);
	pr_imei2Field.stringValue = pr.Read(0x1720);
	pr_modemField.stringValue = pr.Read(0x1735);
	pr_wifiField.stringValue = pr.Read(0x1740);
	pr_btField.stringValue = pr.Read(0x1758);
	pr_tcField.stringValue = pr.Read(0x176C);
	pr_acField.stringValue = pr.Read(0x1776);
	pr_carrierField.stringValue = pr.Read(0x46938, 18, NSUTF16LittleEndianStringEncoding);

	//PREFFile pref;
	//carrierField.stringValue = pref.Get(@"CARRIER_VERSION");
}

//
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

//
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	if (!FakID::Check())
	{
		exit(1);
	}
	[self load];
}

//
- (IBAction)sync:(id)sender
{
	if (pr_snField.stringValue.length)
	{
		ld_snField.stringValue = pr_snField.stringValue;
	}
	else
	{
		pr_snField.stringValue = ld_snField.stringValue;
	}
	
	if (pr_wifiField.stringValue.length)
	{
		ld_wifiField.stringValue = pr_wifiField.stringValue;
	}
	else
	{
		pr_wifiField.stringValue = ld_wifiField.stringValue;
	}
	
	if (pr_btField.stringValue.length)
	{
		ld_btField.stringValue = pr_btField.stringValue;
	}
	else
	{
		pr_btField.stringValue = ld_btField.stringValue;
	}
	
	
	if ((ld_modelField.stringValue.length >= 5) && ld_regionField.stringValue.length)
	{
		pr_modelField.stringValue = [[ld_modelField.stringValue stringByAppendingString:ld_regionField.stringValue] stringByDeletingLastPathComponent];
	}
	else if (pr_modelField.stringValue.length > 5)
	{
		ld_modelField.stringValue = [pr_modelField.stringValue substringToIndex:5];
		if (ld_regionField.stringValue.length == 0)
		{
			ld_regionField.stringValue = [pr_modelField.stringValue substringFromIndex:5];
		}
	}
	
	if (pr_imei2Field.stringValue.length)
	{
		sb_imei2Field.stringValue = pr_imei2Field.stringValue;
		sb_imeiField.stringValue = ld_imeiField.stringValue = [pr_imei2Field.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
	}
	else if (ld_imeiField.stringValue.length)
	{
		sb_imeiField.stringValue = ld_imeiField.stringValue;
		pr_imei2Field.stringValue = sb_imei2Field.stringValue = [NSString stringWithFormat:@"%@ %@ %@ %@",
																 [ld_imeiField.stringValue substringToIndex:2],
																 [ld_imeiField.stringValue substringWithRange:NSMakeRange(2, 6)],
																 [ld_imeiField.stringValue substringWithRange:NSMakeRange(8, 6)],
																 [ld_imeiField.stringValue substringFromIndex:14]
																 ];
	}
	else if (sb_imeiField.stringValue.length)
	{
		ld_imeiField.stringValue = sb_imeiField.stringValue;
		pr_imei2Field.stringValue = sb_imei2Field.stringValue = [NSString stringWithFormat:@"%@ %@ %@ %@",
																 [sb_imeiField.stringValue substringToIndex:2],
																 [sb_imeiField.stringValue substringWithRange:NSMakeRange(2, 6)],
																 [sb_imeiField.stringValue substringWithRange:NSMakeRange(8, 6)],
																 [sb_imeiField.stringValue substringFromIndex:14]
																 ];
	}
	else if (sb_imei2Field.stringValue.length)
	{
		pr_imei2Field.stringValue = sb_imei2Field.stringValue;
		sb_imeiField.stringValue = ld_imeiField.stringValue = [sb_imei2Field.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
	}
}

//
- (IBAction)fake:(id)sender
{
	NSString *error = FakID::Fake(sb_imeiField.stringValue,
									sb_imei2Field.stringValue,
									
									ld_modelField.stringValue,
									ld_snField.stringValue,
									ld_imeiField.stringValue,
									ld_regionField.stringValue,
									ld_wifiField.stringValue,
									ld_btField.stringValue,
									ld_udidField.stringValue,
									
									pr_snField.stringValue,
									pr_modelField.stringValue,
									pr_imei2Field.stringValue,
									pr_modemField.stringValue,
									pr_wifiField.stringValue,
									pr_btField.stringValue,
									pr_tcField.stringValue,
									pr_acField.stringValue,
									pr_carrierField.stringValue);
	if (error)
	{
		NSRunAlertPanel(@"Error", error, @"OK", nil, nil);
		//[self load];
	}
	else if (sender)
	{
		NSString *msg = [NSString stringWithFormat:@"All done. You can get the result file at:\n\n%@\n\n%@\n\n%@", kBundleSubPath(@"Contents/Resources/FakPREF/"), kBundleSubPath(@"Contents/Resources/lockdownd/"), kBundleSubPath(@"Contents/Resources/SpringBoard/")];
		NSRunAlertPanel(@"Done", msg, @"OK", nil, nil);
	}
}

//
- (IBAction)deploy:(id)sender
{
	//
	if (hostField.stringValue.length == 0)
	{
		NSRunAlertPanel(@"Error", @"iPhone host name or ip address should not be empty.", @"OK", nil, nil);
		return;
	}
	
	//
	[self fake:nil];
	
	//
	FILE *fp = fopen(kBundleSubPath(@"Contents/Resources/FakID/FakID.host").UTF8String, "w");
	if (!fp)
	{
		NSRunAlertPanel(@"Error", @"Create signal file error.", @"OK", nil, nil);
	}
	fputs(hostField.stringValue.UTF8String, fp);
	fclose(fp);
	
	//
	//NSString *cmd = [NSString stringWithFormat:@"/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal %@", kBundleSubPath(@"Contents/Resources/FakID/FakID.sh")];
	//system(cmd.UTF8String);
	
	FakID::Run(@"/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal",
				 [NSArray arrayWithObjects:kBundleSubPath(@"Contents/Resources/FakID/FakID.sh"), nil],
				 nil,
				 NO);
}


//
- (IBAction)pwnage:(id)sender
{
	[self fake:nil];

	NSString *from_sb = kBundleSubPath(@"Contents/Resources/SpringBoard/SpringBoard");
	NSString *from_ld = kBundleSubPath(@"Contents/Resources/lockdownd/lockdownd");
	NSString *from_pr = kBundleSubPath(@"Contents/Resources/Preferences/Preferences");
	NSString *to_sb = kBundleSubPath(@"Contents/Resources/PwnageTool.app/Contents/Resources/CustomPackages/FakID.bundle/files/System/Library/CoreServices/SpringBoard.app/SpringBoard");
	NSString *to_ld = kBundleSubPath(@"Contents/Resources/PwnageTool.app/Contents/Resources/CustomPackages/FakID.bundle/files/usr/libexec/lockdownd");
	NSString *to_pr = kBundleSubPath(@"Contents/Resources/PwnageTool.app/Contents/Resources/CustomPackages/FakID.bundle/files/Applications/Preferences.app/Preferences");
	
	[[NSFileManager defaultManager] copyItemAtPath:from_sb toPath:to_sb error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:from_ld toPath:to_ld error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:from_pr toPath:to_pr error:nil];

	FakID::Run(kBundleSubPath(@"Contents/Resources/PwnageTool.app/Contents/MacOS/PwnageTool"),
			   [NSArray array],
			   nil,
			   NO);
}

@end
