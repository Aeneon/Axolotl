#import "Preferences.h"

/*
	System Versioning Preprocessor Macros …

	Available Functions:

	- #define SYSTEM_VERSION_EQUAL_TO(v)					([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] == NSOrderedSame)
	- #define SYSTEM_VERSION_GREATER_THAN(v)				([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] == NSOrderedDescending)
	- #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)	([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] != NSOrderedAscending)
	- #define SYSTEM_VERSION_LESS_THAN(v)					([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] == NSOrderedAscending)
	- #define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)		([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] != NSOrderedDescending)
*/
#define SYSTEM_VERSION_LESS_THAN(v)							([[[UIDevice currentDevice] systemVersion] compare: v options: NSNumericSearch] == NSOrderedAscending)

/*
	Preferences …
*/
@implementation AxolotlPreferencesListController

	// Theming Enginge: AutumnBoard …

	MTAutumnBoard *autumnBoard;

	// The Preference-Specifiers from "Root.plist" …

	- (NSArray *)specifiers
	{
		if (!_specifiers)
		{
			_specifiers = [self loadSpecifiersFromPlistName: @"Root" target: self];
		}

		return _specifiers;
	}

	/*
		Initialization …
	*/
	- (instancetype)init
	{
		self = [super init];

		if (self)
		{
			// Allocate and initialize Theming Engine …

			autumnBoard = [[MTAutumnBoard alloc] init];

			// The Apply-Button …

			UIButton *applyButton = [UIButton buttonWithType: UIButtonTypeCustom];

			applyButton.frame = CGRectMake(0, 0, 30, 30);
			applyButton.layer.masksToBounds = YES;

			UIImage *imageCheckmark = [UIImage imageNamed: @"checkmark.png" inBundle: [NSBundle bundleForClass: self.class] compatibleWithTraitCollection: nil];

			[applyButton setImage: [imageCheckmark imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateNormal];
			[applyButton addTarget: self action: @selector(applyChanges:) forControlEvents: UIControlEventTouchUpInside];

			applyButton.tintColor = [autumnBoard tintApply];

			self.applyButtonItem = [[UIBarButtonItem alloc] initWithCustomView: applyButton];

			// The Visit-Twitter-Button …

			UIButton *twitterButton = [UIButton buttonWithType: UIButtonTypeCustom];

			twitterButton.frame = CGRectMake(0, 0, 30, 30);
			twitterButton.layer.masksToBounds = YES;

			UIImage *imageTwitter = [UIImage imageNamed: @"twitter.png" inBundle: [NSBundle bundleForClass: self.class] compatibleWithTraitCollection: nil];

			[twitterButton setImage: [imageTwitter imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateNormal];
			[twitterButton addTarget: self action: @selector(visitTwitter:) forControlEvents: UIControlEventTouchUpInside];

			twitterButton.tintColor = [autumnBoard tintTwitter];

			self.twitterButtonItem = [[UIBarButtonItem alloc] initWithCustomView: twitterButton];

			// The Visit-Website-Button …

			UIButton *websiteButton = [UIButton buttonWithType: UIButtonTypeCustom];

			websiteButton.frame = CGRectMake(0, 0, 30, 30);
			websiteButton.layer.masksToBounds = YES;

			UIImage *imageWebsite = [UIImage imageNamed: @"website.png" inBundle: [NSBundle bundleForClass: self.class] compatibleWithTraitCollection: nil];

			[websiteButton setImage: [imageWebsite imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate] forState: UIControlStateNormal];
			[websiteButton addTarget: self action: @selector(visitWebsite:) forControlEvents: UIControlEventTouchUpInside];

			websiteButton.tintColor = [autumnBoard tintWebsite];

			self.websiteButtonItem = [[UIBarButtonItem alloc] initWithCustomView: websiteButton];

			// Add the Buttons to the right Side of the Navigation Bar …

			NSArray *rightButtons;

			rightButtons = @[self.twitterButtonItem, self.applyButtonItem, self.websiteButtonItem];

			self.navigationItem.rightBarButtonItems = rightButtons;

			// Create a Title and a Image to Display in the Navigation Bar …

			self.navigationItem.titleView = [UIView new];

			self.iconView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 10, 10)];

			self.iconView.alpha = 0.0;
			self.iconView.contentMode = UIViewContentModeScaleAspectFit;
			self.iconView.image = [UIImage imageNamed: @"icon.png" inBundle: [NSBundle bundleForClass: self.class] compatibleWithTraitCollection: nil];
			self.iconView.translatesAutoresizingMaskIntoConstraints = NO;

			[self.navigationItem.titleView addSubview: self.iconView];

			[NSLayoutConstraint activateConstraints:
			@[
				[self.iconView.topAnchor constraintEqualToAnchor: self.navigationItem.titleView.topAnchor],
				[self.iconView.leadingAnchor constraintEqualToAnchor: self.navigationItem.titleView.leadingAnchor],
				[self.iconView.trailingAnchor constraintEqualToAnchor: self.navigationItem.titleView.trailingAnchor],
				[self.iconView.bottomAnchor constraintEqualToAnchor: self.navigationItem.titleView.bottomAnchor]
			]];
		}

		return self;
	}

	/*
		Function Overrides …
	*/
	- (void)viewDidLoad
	{
		[super viewDidLoad];

		// Create a new Tap Gesture Recognizer, so we can easily hide the Keyboard, if the User taps on a Table Element …

		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];

		[self.view addGestureRecognizer: tapGestureRecognizer];

		tapGestureRecognizer.cancelsTouchesInView = NO;

		// Get the Banner Image …

		UIImage *headerImage = [UIImage imageNamed: @"banner.png" inBundle: [NSBundle bundleForClass: self.class] compatibleWithTraitCollection: nil];

		// … create a new Header View and assign the Image to an Image View …

		self.headerView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, headerImage.size.width, headerImage.size.height)];

		self.headerImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];

		self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.headerImageView.image = headerImage;
		self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

		// … then add the newly created Sub View to the Header View.

		[self.headerView addSubview: self.headerImageView];

		[NSLayoutConstraint activateConstraints:
		@[
			[self.headerImageView.widthAnchor constraintEqualToConstant: headerImage.size.width],
			[self.headerImageView.heightAnchor constraintEqualToConstant: headerImage.size.height],
			[self.headerImageView.centerXAnchor constraintEqualToAnchor: self.headerView.centerXAnchor],
			[self.headerImageView.topAnchor constraintEqualToAnchor: self.headerView.topAnchor constant: 25]
		]];

		tableViewRoot.tableHeaderView = self.headerView;
		tableViewRoot.userInteractionEnabled = YES;

		// If the User leaves the Preferences-App, call the Selector `handleNo`, so no Changes will be made …

		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNo:) name: UIApplicationDidEnterBackgroundNotification object: nil];
	}

	- (void)viewWillAppear: (BOOL)animated
	{
		[super viewWillAppear: animated];

		CGRect frame = self.table.bounds;

		frame.origin.y = -frame.size.height;

		[self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];

		// Set the Navigation Bar's Tint Color using the assigned Color …

		self.navigationController.navigationController.navigationBar.tintColor = [autumnBoard tintNavBar];
	}

	- (void)viewWillDisappear: (BOOL)animated
	{
		[super viewWillDisappear: animated];

		// Reset the Navigation Bar's Tint Color …

		self.navigationController.navigationController.navigationBar.tintColor = nil;
	}

	- (void)scrollViewDidScroll: (UIScrollView *)scrollView
	{
		// We have to decrease the Height of our Header View, if we're on iOS 12 and below …

		CGFloat headerHeight = self.headerImageView.bounds.size.height - (SYSTEM_VERSION_LESS_THAN(@"13.0") ? 38 : 66);

		// Get the Y-Offset in our Scroll View ( the Position ) …

		CGFloat offsetY = scrollView.contentOffset.y;

		// If the Y-Offset is larger than the calculated Height of our Header, …

		if (offsetY > headerHeight)
		{
			// … fade-in the Icon View.

			[UIView animateWithDuration: 0.2 animations: ^
			{
				self.iconView.alpha = 1.0;
			}];
		}
		else
		{
			// … otherwise fade the Icon View out.

			[UIView animateWithDuration: 0.2 animations: ^
			{
				self.iconView.alpha = 0.0;
			}];
		}
	}

	/*
		Function Overrides ( UIKit ) …
	*/
	- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController: (UIPresentationController *)controller
	{
		return UIModalPresentationNone;
	}

	- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
	{
		tableView.tableHeaderView = self.headerView;

		return [super tableView: tableView cellForRowAtIndexPath: indexPath];
	}

	/*
		Events - Navigation Bar …
	*/
	- (void)visitWebsite: (id)sender
	{
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://macthemes.me/"] options: @{} completionHandler: nil];
	}

	- (void)visitTwitter: (id)sender
	{
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://twitter.com/iMacThemes"] options: @{} completionHandler: nil];
	}

	/*
		Events - Popover …
	*/
	- (void)applyChanges: (UIButton *)sender
	{
		[self.view endEditing: YES];

		// Localization-specific Stuff …

		NSBundle *prefBundle = [NSBundle bundleForClass: self.class];

		NSString *applyLabelText = [prefBundle localizedStringForKey: @"AXApplyLabel" value: @"" table: nil];
		NSString *yesButtonTitle = [prefBundle localizedStringForKey: @"AXApplyYes" value: @"" table: nil];
		NSString *noButtonTitle = [prefBundle localizedStringForKey: @"AXApplyNo" value: @"" table: nil];

		// Create new View Controller …

		self.popController = [[UIViewController alloc] init];

		self.popController.modalPresentationStyle = UIModalPresentationPopover;
		self.popController.preferredContentSize = CGSizeMake(200, 130);

		double offsetY = (SYSTEM_VERSION_LESS_THAN(@"13.0") ? 0 : 12.5);

		// The Apply-Label …

		UILabel *applyLabel = [[UILabel alloc] init];

		applyLabel.adjustsFontSizeToFitWidth = YES;
		applyLabel.font = [UIFont boldSystemFontOfSize: 20];
		applyLabel.frame = CGRectMake(20, 10 + offsetY, 160, 60);
		applyLabel.numberOfLines = 2;
		applyLabel.text = applyLabelText;
		applyLabel.textAlignment = NSTextAlignmentCenter;
		applyLabel.textColor = [applyLabel.textColor colorWithAlphaComponent: 0.75];

		[self.popController.view addSubview: applyLabel];

		// The Yes-Button …

		UIButton *yesButton = [UIButton buttonWithType: UIButtonTypeCustom];

		yesButton.frame = CGRectMake(100, 85 + offsetY, 100, 30);
		yesButton.titleLabel.font = [UIFont boldSystemFontOfSize: 20];

		[yesButton addTarget: self action: @selector(handleYes:) forControlEvents: UIControlEventTouchUpInside];
		[yesButton setTitle: yesButtonTitle forState: UIControlStateNormal];
		[yesButton setTitleColor: [autumnBoard tintApplyYes] forState: UIControlStateNormal];

		[self.popController.view addSubview: yesButton];

		// The No-Button …

		UIButton *noButton = [UIButton buttonWithType: UIButtonTypeCustom];

		noButton.frame = CGRectMake(0, 85 + offsetY, 100, 30);
		noButton.titleLabel.font = [UIFont boldSystemFontOfSize: 20];

		[noButton addTarget: self action: @selector(handleNo:) forControlEvents: UIControlEventTouchUpInside];
		[noButton setTitle: noButtonTitle forState: UIControlStateNormal];
		[noButton setTitleColor: [autumnBoard tintApplyNo] forState: UIControlStateNormal];

		[self.popController.view addSubview: noButton];

		// The Popover View …

		UIPopoverPresentationController *popover = self.popController.popoverPresentationController;

		popover.delegate = self;
		popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
		popover.barButtonItem = self.applyButtonItem;

		// Show the Popover View …

		[self presentViewController: self.popController animated: YES completion: nil];
	}

	- (void)handleYes: (UIButton *)sender
	{
		// Hide the Popover View …

		[self.popController dismissViewControllerAnimated: YES completion: nil];

		// Kill all Instances of WhatsApp …

		pid_t pid;

		const char* args[] = { "-9", "WhatsApp", NULL };

		posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);
	}

	- (void)handleNo: (UIButton *)sender
	{
		// Hide the Popover View …

		[self.popController dismissViewControllerAnimated: YES completion: nil];
	}

	/*
		Events - Root Table View …
	*/

	// Hide the Keyboard …

	- (void)dismissKeyboard
	{
		[self.view endEditing: YES];
	}

	// Open Links associated to Preference-Cells with the Custom Class `MTContantCell` …

	- (void)open: (PSSpecifier *)sender
	{
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString: [sender propertyForKey: @"url"]] options: @{} completionHandler: nil];
	}

@end