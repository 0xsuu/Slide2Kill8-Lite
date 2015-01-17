
///////////
//Headers//
///////////
@interface SBUIController : NSObject

+ (id)sharedInstance;
- (id)_appSwitcherController;

@end

@interface SBDisplayItem : NSObject

@property(readonly, assign, nonatomic) NSString* displayIdentifier;
@property(readonly, assign, nonatomic) NSString* type;

+ (id)displayItemWithType:(NSString*)type displayIdentifier:(id)identifier;
- (id)initWithType:(NSString*)type displayIdentifier:(id)identifier;

@end

@interface SBDisplayLayout : NSObject

@property(readonly, assign, nonatomic) NSArray* displayItems;

@end

@interface SBAppSwitcherIconController : UIViewController

@end

@interface SBAppSwitcherController : UIViewController
{
    SBAppSwitcherIconController* _iconController;
}

- (id)getSelf;
- (id)getIconController;
- (void)_quitAppWithDisplayItem:(SBDisplayItem *)displayItem;
- (void)forceDismissAnimated:(BOOL)animated;
- (void)killAllApps;

@end

@interface SBMediaController

+ (id)sharedInstance;
- (id)nowPlayingApplication;
- (BOOL)isPlaying;

@end

@interface SBApplication

- (id)bundleIdentifier;

@end

///////////////////
//Global Variants//
///////////////////
UIViewController *scrollerViewController;
UIViewController *appIconScrollerViewController;

///////////////////////
//Switcher Controller//
///////////////////////
%hook SBAppSwitcherController

%new
- (id)getSelf
{
    SBUIController *uiController = [%c(SBUIController) sharedInstance];
    SBAppSwitcherController *switcherController = [uiController _appSwitcherController];
    return switcherController;
}

%new
- (id)getIconController
{
    SBUIController *uiController = [%c(SBUIController) sharedInstance];
    SBAppSwitcherController *switcherController = [uiController _appSwitcherController];
    SBAppSwitcherIconController *iconController = MSHookIvar<SBAppSwitcherIconController *>(switcherController, "_iconController");
    return iconController;
}

//Get scroll view controller
-(BOOL)switcherScroller:(UIViewController *)scroller isDisplayItemRemovable:(SBDisplayItem *)displayItem
{
    scrollerViewController = scroller;
    return %orig;
}

//Get Icon View Controller
-(BOOL)switcherIconScroller:(id)scroller shouldHideIconForDisplayLayout:(id)displayLayout
{
    appIconScrollerViewController = scroller;
    return %orig;
}

//Kill All Apps
%new
- (void)killAllApps
{
    //Init app list
    NSMutableArray *appDisplayItemList = MSHookIvar<NSMutableArray *>([self getIconController], "_appList");
    NSMutableArray *killList = [[NSMutableArray alloc] init];
    
    //Get settings Kill now playing
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.suu.slide2kill8litesettings.plist"];
    BOOL killMusic = [[dict objectForKey:@"killMusic"] boolValue];
    
    //Get now playing
    SBMediaController *mediaController = [%c(SBMediaController) sharedInstance];
    BOOL isPlaying = [mediaController isPlaying];
    SBApplication *nowPlayingApp = [mediaController nowPlayingApplication];
    NSString *playingID = [nowPlayingApp bundleIdentifier];
    
    //Get the array of kill aoo list
    for (SBDisplayLayout *display in appDisplayItemList)
    {
        NSMutableArray *dispItems = [[NSMutableArray alloc] initWithArray:[display.displayItems copy]];
        SBDisplayItem *dispItem = dispItems[0];
        
        if (![dispItem.type isEqualToString:@"Homescreen"])
        {
            if (![dispItem.displayIdentifier isEqualToString:playingID] || killMusic || !isPlaying)
            {
                [killList addObject:dispItem];
            }
        }
    }
    
    //Kill
    for (id killApp in killList)
    {
        [self _quitAppWithDisplayItem:killApp];
    }
    
    //Quit animation
    [UIView animateWithDuration:0.2f animations:^(void)
     {
         scrollerViewController.view.frame = CGRectMake(scrollerViewController.view.frame.origin.x,
                                                        scrollerViewController.view.frame.origin.y + 600,
                                                        scrollerViewController.view.frame.size.width,
                                                        scrollerViewController.view.frame.size.height);
         
         appIconScrollerViewController.view.frame = CGRectMake(appIconScrollerViewController.view.frame.origin.x,
                                                               appIconScrollerViewController.view.frame.origin.y + 10,
                                                               appIconScrollerViewController.view.frame.size.width,
                                                               appIconScrollerViewController.view.frame.size.height);
         
         scrollerViewController.view.alpha = 0.0f;
         appIconScrollerViewController.view.alpha = 0.0f;
     }
    completion:^(BOOL finished)
     {
         [self forceDismissAnimated: YES];
     }];
}

%end

%hook SBAppSwitcherPageViewController

- (void)scrollViewWillEndDragging:(id)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint*)offset
{
    %orig;
    
    //Get settings enabled
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.suu.slide2kill8litesettings.plist"];
    BOOL isEnabled = [[dict objectForKey:@"Enabled"] boolValue];
    
    //Slide enough ? Kill : Not Kill
    if (velocity.y <= -1.0f && isEnabled)
    {
        SBUIController *uiController = [%c(SBUIController) sharedInstance];
        SBAppSwitcherController *switcherController = [uiController _appSwitcherController];
        [switcherController killAllApps];
    }
    
    [dict release];
}

%end
