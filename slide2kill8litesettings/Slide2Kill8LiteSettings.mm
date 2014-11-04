#import <Preferences/Preferences.h>

@interface Slide2Kill8LiteSettingsListController: PSListController {
}
@end

@implementation Slide2Kill8LiteSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Slide2Kill8LiteSettings" target:self] retain];
	}
	return _specifiers;
}

- (void)getS2K8:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/0xSuu"]];
}

- (void)followSina:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.weibo.com/iamsuu"]];
}

- (void)followTwitter:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/0xSuu"]];
}

- (void)donate:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3255805@qq.com&lc=EN&item_name=Slide2Kill&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"]];
}

@end

// vim:ft=objc
