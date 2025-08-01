#import "MTAutumnBoard.h"

/*
	Theme …
*/
@implementation MTAutumnBoard

	/*
		Initialization …
	*/
	- (id)init
	{
		self = [super init];

		if (self)
		{
			// Get the "Theme.plist" from our Preference Bundle …

			NSBundle *prefBundle = [NSBundle bundleForClass: self.class];
			NSString *prefBundleTheme = ROOT_PATH_NS([prefBundle pathForResource: @"Theme" ofType: @"plist"]);

			NSDictionary *theme = [NSDictionary dictionaryWithContentsOfFile: prefBundleTheme];

			// Our Dictionary of Colors …

			NSDictionary *tintColors;

			// If "Theme.plist" contains a Dictionary named "AXTintColors" …

			if(theme[@"AXTintColors"])
			{
				// … get them.

				tintColors = theme[@"AXTintColors"];
			}

			// Now check, if every Color exists and - if so - convert it's Hex-Color-String to an UI Color, otherwise use the Default Color …

			_tintApply		= tintColors[@"AXApplyButton"]	 ? [self colorWithHexString: tintColors[@"AXApplyButton"]]	 : [UIColor colorWithRed: 68/255.0f green: 192/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintApplyNo	= tintColors[@"AXApplyNo"]		 ? [self colorWithHexString: tintColors[@"AXApplyNo"]]		 : [UIColor colorWithRed: 68/255.0f green: 192/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintApplyYes	= tintColors[@"AXApplyYes"]		 ? [self colorWithHexString: tintColors[@"AXApplyYes"]]		 : [UIColor colorWithRed: 192/255.0f green: 68/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintDebug		= tintColors[@"AXDebugSwitch"]	 ? [self colorWithHexString: tintColors[@"AXDebugSwitch"]]	 : [UIColor colorWithRed: 68/255.0f green: 192/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintEnable		= tintColors[@"AXEnableSwitch"]	 ? [self colorWithHexString: tintColors[@"AXEnableSwitch"]]	 : [UIColor colorWithRed: 68/255.0f green: 192/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintNavBar		= tintColors[@"AXNavigationBar"] ? [self colorWithHexString: tintColors[@"AXNavigationBar"]] : [UIColor colorWithRed: 68/255.0f green: 192/255.0f blue: 84/255.0f alpha: 1.0f];
			_tintTwitter	= tintColors[@"AXTwitterButton"] ? [self colorWithHexString: tintColors[@"AXTwitterButton"]] : [UIColor colorWithRed: 0/255.0f green: 152/255.0f blue: 192/255.0f alpha: 1.0f];
			_tintWebsite	= tintColors[@"AXWebsiteButton"] ? [self colorWithHexString: tintColors[@"AXWebsiteButton"]] : [UIColor colorWithRed: 114/255.0f green: 115/255.0f blue: 115/255.0f alpha: 1.0f];
		}

		return self;
	}

	/*
		Functions …
	*/

	// Convert Hex-Color-String to UI Color …

	- (UIColor *)colorWithHexString: (NSString *)stringToConvert
	{
		// Split the String into an Array using the Colon …

		NSArray *components = [stringToConvert componentsSeparatedByString: @":"];

		// The first Component is our Color …

		NSString *hashString = ([components count] > 0) ? components[0] : components;

		// … and the second our Alpha Value.

		float alphaValue = ([components count] > 1) ? [components[1] floatValue] : 1.0f;

		// Now let's remove the Hashtag ( "#" ) from our Hex-String, …

		NSString *noHashString = [hashString stringByReplacingOccurrencesOfString: @"#" withString: @""];

		// … remove Symbol Characters, like "+" and "$" …

		NSScanner *scanner = [NSScanner scannerWithString: noHashString];

		[scanner setCharactersToBeSkipped: [NSCharacterSet symbolCharacterSet]];

		// … convert the String, by getting it'S Components for Red, Green and Blue …

		unsigned hex;

		if (! [scanner scanHexInt: &hex])
		{
			return nil;
		}

		int red = (hex >> 16) & 0xFF;
		int green = (hex >> 8) & 0xFF;
		int blue = (hex) & 0xFF;

		// … and return the Components, plus the Alpha Value as new UI Color.

		return [UIColor colorWithRed: red/255.0f green: green/255.0f blue: blue/255.0f alpha: alphaValue];
	}

@end
