#import <Foundation/Foundation.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

#import <rootless.h>
#import <spawn.h>

#import "MTAutumnBoard.h"

@interface AxolotlPreferencesListController: PSListController<UIPopoverPresentationControllerDelegate>
{
	UITableView *tableViewRoot;
}

	@property (nonatomic, retain) UIBarButtonItem *applyButtonItem;
	@property (nonatomic, retain) UIBarButtonItem *twitterButtonItem;
	@property (nonatomic, retain) UIBarButtonItem *websiteButtonItem;

	@property (nonatomic, retain) UIViewController *popController;

	@property (nonatomic, retain) UIView *headerView;
	@property (nonatomic, retain) UIImageView *headerImageView;
	@property (nonatomic, retain) UIImageView *iconView;

	- (void)applyChanges: (UIButton *)sender;
	- (void)handleYes: (UIButton *)sender;
	- (void)handleNo: (UIButton *)sender;
	- (void)open: (PSSpecifier *)sender;
	- (void)visitTwitter: (UIButton *)sender;
	- (void)visitWebsite: (UIButton *)sender;

	- (void)dismissKeyboard;

@end