#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

#import <rootless.h>

#include <dlfcn.h>

#include <CydiaSubstrate/CydiaSubstrate.h>

#define DEFAULT_VERSION @"2.25.21.6";

/*
	Preferences …
*/
NSDictionary *preferences;

/*
	Variables …
*/
BOOL enabled;
BOOL debugLogging;

int newVersionMajor;
int newVersionMinor;
int newVersionBuild;
int newVersionRevision;

NSString *newVersion;
NSString *newBuildHash;

static NSDate * (*_orig_WAAppExpirationDate)();
static NSDate * (*_orig_WABuildDate)();
static NSDate * (*_orig_WADeprecatedPlatformCutOffDate)();

static NSString * (*_orig_WABuildVersion)(void *, void *);
static NSString * (*_orig_WABuildHash)();

/*
	Functions …
*/
static NSString *md5HexDigest(NSString *input)
{
	const char* str = [input UTF8String];

	unsigned char result[CC_MD5_DIGEST_LENGTH];

	CC_MD5(str, (CC_LONG)strlen(str), result);

	NSMutableString *ret = [NSMutableString stringWithCapacity: CC_MD5_DIGEST_LENGTH * 2];

	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
	{
		[ret appendFormat: @"%02x", result[i]];
	}

	return ret;
}

/*
	Function Overrides …
*/
static NSDate *_new_WAAppExpirationDate()
{
	if (debugLogging)
	{
		NSLog(@"_new_WAAppExpirationDate called");

		NSDate *originalDate = _orig_WAAppExpirationDate();

		NSLog(@"Original expiration date: %@", originalDate);
	}

	// Modify the Date or do whatever you want here …

	return [NSDate dateWithTimeIntervalSinceNow: 31536000];
}

static NSDate *_new_WABuildDate()
{
	if (debugLogging)
	{
		NSLog(@"_new_WABuildDate called");

		NSDate *originalDate = _orig_WABuildDate();

		NSLog(@"Original build date: %@", originalDate);
	}

	// Modify the Date or do whatever you want here …

	return [NSDate date];
}

static NSString *_new_WABuildHash()
{
	if (debugLogging)
	{
		NSLog(@"_new_WABuildHash called");

		NSString *originalVersion = _orig_WABuildHash();

		NSLog(@"Original build hash: %@", originalVersion);
	}

	// Modify the Build Hash or do whatever you want here …

	return newBuildHash;
}

static NSString *_new_WABuildVersion(void *arg1, void *arg2)
{
	if (debugLogging)
	{
		NSLog(@"_new_WABuildVersion called");

		NSString *originalVersion = _orig_WABuildVersion(arg1, arg2);

		NSLog(@"Original build version: %@", originalVersion);
	}

	// Modify the Version or do whatever you want here …

	return newVersion;
}

static NSDate *_new_WADeprecatedPlatformCutOffDate()
{
	if (debugLogging)
	{
		NSLog(@"_new_WADeprecatedPlatformCutOffDate called");

		NSDate *originalDate = _orig_WADeprecatedPlatformCutOffDate();

		NSLog(@"Original expiration date: %@", originalDate);
	}

	// Modify the Date or do whatever you want here …

	return [NSDate dateWithTimeIntervalSinceNow: 31536000];
}

/*
	Hooks …
*/
%group Axolotl

	%hook WALogWriter

		- (NSString*)formatLogText: (NSString*)ar1 withLevel: (int)ar2
		{
			NSString *result = %orig;

			if (debugLogging)
			{
				NSLog(@"WALog: %@", result);
			}

			return result;
		}

	%end

	%hook WAMessage

		- (bool)needsLocalNotification
		{
			return true;
		}

	%end

	%hook WAPBClientPayload_UserAgent_AppVersion

		- (void)setPrimary: (int)i
		{
			%orig(newVersionMajor);
		}

		- (void)setSecondary: (int)i
		{
			%orig(newVersionMinor);
		}

		- (void)setTertiary: (int)i
		{
			%orig(newVersionBuild);
		}

		- (void)setQuaternary: (int)i
		{
			%orig(newVersionRevision);
		}

	%end

	/*
		WACreateUserAgent
		WASubmitMessageSendEvent
		WAChatServers
		WAStreamVersion
		WACreateClientPayload
	*/

	%hook WARootViewController

		- (bool)isBuildExpired
		{
			return NO;
		}

		- (void)expireBuild
		{
			return;
		}

		- (void)presentHelperScreen
		{
			return;
		}

		- (void)wa_applicationDidEnterBackground
		{
			return;
		}

	%end

	%hook WamEventDaily

		- (double)iphone_jailbroken
		{
			return 0;
		}

	%end

%end

/*
	Constructor …
*/
%ctor
{
	// Load Preferences …

	preferences = [NSDictionary dictionaryWithContentsOfFile: ROOT_PATH_NS(@"/var/mobile/Library/Preferences/com.macthemes.axolotlprefs.plist")];

	// … and parse only the "enabled" Preference.

	enabled = preferences[@"enabled"] ? [preferences[@"enabled"] boolValue] : YES;

	// Let's check, if the Tweak is enabled and initialize them …

	if (enabled)
	{
		// Now let's get the Preferences for Debug Logging and the new Version …

		debugLogging = preferences[@"debugLogging"] ? [preferences[@"debugLogging"] boolValue] : NO;
		newVersion = preferences[@"newVersion"] ? [preferences[@"newVersion"] stringValue] : DEFAULT_VERSION;

		// Check, if the Version is valid …

		NSPredicate *isValidVersion = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", @"^\\d+(\\.\\d+){2,3}$"];

		// … and if not, use our Default Version.

		if (![isValidVersion evaluateWithObject: newVersion])
		{
			newVersion = DEFAULT_VERSION;
		}

		// Separate the Version by it's Point and get the Components …

		NSArray *components = [newVersion componentsSeparatedByString: @"."];

		// … and set the Variables.

		newVersionMajor = [components[0] intValue];
		newVersionMinor = [components[1] intValue];
		newVersionBuild = [components[2] intValue];
		newVersionRevision = ([components count] > 3) ? [components[3] intValue] : 0;

		// Get SharedModules-Framework …

		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *frameworkPath = [bundlePath stringByAppendingPathComponent: @"Frameworks/SharedModules.framework/SharedModules"];

		void *image = dlopen([frameworkPath UTF8String], RTLD_LAZY);

		// Initialize the Tweak …

		%init(Axolotl);

		// If we have a valid Image …

		if (image)
		{
			// Get Build Date and change it to our new Date …

			void * _WAAppExpirationDate = dlsym(image, "WAAppExpirationDate");

			if (_WAAppExpirationDate)
			{
				// Check, if Debug Logging is requested …

				if (debugLogging)
				{
					// Cast the Void Pointer to a Function Pointer and call it …

					NSDate * (*func)() = (NSDate *(*)())_WAAppExpirationDate;
					NSDate *result = func();

					NSLog(@"Function result: %@", result);
				}

				// Replace the original Function by our new One with different Expiration Date …

				MSHookFunction(_WAAppExpirationDate, (void *)&_new_WAAppExpirationDate, (void **)&_orig_WAAppExpirationDate);
			}
			else if (debugLogging)
			{
				NSLog(@"Failed to find WAAppExpirationDate");
			}

			// Get Build Date and change it to our new Date …

			void * _WABuildDate = dlsym(image, "WABuildDate");

			if (_WABuildDate)
			{
				// Check, if Debug Logging is requested …

				if (debugLogging)
				{
					// Cast the Void Pointer to a Function Pointer and call it …

					NSDate * (*func)() = (NSDate *(*)())_WABuildDate;
					NSDate *result = func();

					NSLog(@"Function result: %@", result);
				}

				// Replace the original Function by our new One with different Build Date …

				MSHookFunction(_WABuildDate, (void *)&_new_WABuildDate, (void **)&_orig_WABuildDate);
			}
			else if (debugLogging)
			{
				NSLog(@"Failed to find WABuildDate");
			}

			// Get the Build Version and change it to our new Version …

			void * _WABuildVersion = dlsym(image, "WABuildVersion");

			if (_WABuildVersion)
			{
				// Check, if Debug Logging is requested …

				if (debugLogging)
				{
					// Cast the Void Pointer to a Function Pointer and call it …

					NSString * (*func)(void *, void *) = (NSString *(*)(void *, void *))_WABuildVersion;

					// Pass NULL for the Arguments if you don't know what to pass …

					NSString *result = func((void*)@"", (void*)@"");

					NSLog(@"Function result: %@", result);
				}

				// Replace the original Function by our new One with different Build Version …

				MSHookFunction(_WABuildVersion, (void *)&_new_WABuildVersion, (void **)&_orig_WABuildVersion);
			}
			else if (debugLogging)
			{
				NSLog(@"Failed to find WABuildVersion");
			}

			// Get Build Hash and change it to our previously calculated Hash …

			void * _WABuildHash = dlsym(image, "WABuildHash");

			if (_WABuildHash)
			{
				// Let's calculate a new MD5-Hash of the Build Version, which is simply used as Build Hash …

				newBuildHash = md5HexDigest(newVersion);

				// Check, if Debug Logging is requested …

				if (debugLogging)
				{
					// Cast the Void Pointer to a Function Pointer and call it …

					NSString * (*func)() = (NSString *(*)())_WABuildHash;

					// Pass NULL for the Arguments if you don't know what to pass …

					NSString *result = func();

					NSLog(@"Function result: %@", result);
				}

				// Replace the original Function by our new One with different Build Hash …

				MSHookFunction(_WABuildHash, (void *)&_new_WABuildHash, (void **)&_orig_WABuildHash);
			}
			else if (debugLogging)
			{
				NSLog(@"Failed to find WABuildHash");
			}

			// Get Deprecated Platform Cut-Off Date and change it to our new Date …

			void *_WADeprecatedPlatformCutOffDate = dlsym(image, "_WADeprecatedPlatformCutOffDate");

			if (_WADeprecatedPlatformCutOffDate)
			{
				// Check, if Debug Logging is requested …

				if (debugLogging)
				{
					// Cast the Void Pointer to a Function Pointer and call it …

					NSDate * (*func)() = (NSDate *(*)())_WADeprecatedPlatformCutOffDate;
					NSDate *result = func();

					NSLog(@"Function result: %@", result);
				}

				MSHookFunction(_WADeprecatedPlatformCutOffDate, (void *)&_new_WADeprecatedPlatformCutOffDate, (void **)&_orig_WADeprecatedPlatformCutOffDate);
			}
			else if (debugLogging)
			{
				NSLog(@"Failed to find _WADeprecatedPlatformCutOffDate");
			}
		}
		else if (debugLogging)
		{
			NSLog(@"Failed to load image at path: %@", frameworkPath);
		}

		return;
	}
}
