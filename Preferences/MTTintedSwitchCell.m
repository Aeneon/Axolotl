#import "MTTintedSwitchCell.h"

@implementation MTTintedSwitchCell
{
	UIColor *switchOnTintColor;
}

	- (instancetype)initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString *)identifier specifier: (PSSpecifier *)specifier
	{
		self = [super initWithStyle: style reuseIdentifier: identifier specifier: specifier];

		// Allocate and initialize Theming Engine …

		MTAutumnBoard *autumnBoard = [[MTAutumnBoard alloc] init];

		// Get the Key-Property from the given Preference-Specifier …

		NSString *key = [specifier propertyForKey: @"key"];

		// If the Key-Property equals "debugLogging", set the `switchOnTintColor` for it, otherwise, if it equals `enabled`, set the Tint Color we want to use …

		if ([key isEqual: @"debugLogging"])
		{
			switchOnTintColor = [autumnBoard tintDebug];
		}
		else if ([key isEqual: @"enabled"])
		{
			switchOnTintColor = [autumnBoard tintEnable];
		}

		return self;
	}

	- (void)layoutSubviews
	{
		[super layoutSubviews];

		// Set the Switch's Tint Color …

		[((UISwitch *)self.control) setOnTintColor: switchOnTintColor];
	}

@end