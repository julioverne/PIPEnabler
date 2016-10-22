#import "pipenabler.h"

static BOOL autoShowPIP;
static __strong NSString* kShowPIP = @"autoShowPIP";
static __strong NSString* kNSNoti = @"com.julioverne.pipenabler/PIPNow";
static __strong NSString* kNSNotiTG = @"com.julioverne.pipenabler/PIPNow/Toggle";
static __strong AVPictureInPictureController* AVPictureInPictureControllerCurrent;

%hook AVPlayerLayer
%property (nonatomic, retain) id AVPictureInPictureController;
- (id)init
{
	id ret = %orig;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestShowPIPNow) name:kNSNoti object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestShowPIPNowToggle) name:kNSNotiTG object:nil];
	return ret;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	%orig;
}
- (void)_setItem:(id)arg1 readyForDisplay:(BOOL)arg2
{
	%orig;
	if(autoShowPIP&&arg2) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNSNoti object:nil];
	}
}
%new
- (void)requestShowPIPNow
{
	if([self respondsToSelector:@selector(showPIPNow)]) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showPIPNow) object:kShowPIP];
		[self performSelector:@selector(showPIPNow) withObject:kShowPIP afterDelay:0.6f];
	}
}
%new
- (void)requestShowPIPNowToggle
{
	@try {
		if(![self isReadyForDisplay]) {
			return;
		}
		[self.player setAllowsExternalPlayback:YES];
		if(!self.AVPictureInPictureController) {
			self.AVPictureInPictureController =  [[objc_getClass("AVPictureInPictureController") alloc] initWithPlayerLayer:self];
		}
		AVPictureInPictureControllerCurrent = self.AVPictureInPictureController;
		if(self.AVPictureInPictureController) {
			PGPictureInPictureProxy* PIPProxy = MSHookIvar<PGPictureInPictureProxy *>(self.AVPictureInPictureController, "_pictureInPictureProxy");
			PIPProxy.pictureInPictureShouldStartWhenEnteringBackground = YES;
			[PIPProxy updatePictureInPicturePossible:YES];
		}
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		[[AVAudioSession sharedInstance] setActive:YES error: nil];
		[self setPIPModeEnabled:YES];
		if (self.AVPictureInPictureController) {
			if([self.AVPictureInPictureController isPictureInPictureActive]) {
				[self.AVPictureInPictureController stopPictureInPicture];
			} else {
				[self.AVPictureInPictureController startPictureInPicture];
			}			
		}
	} @catch (NSException * e) {
	}
}
%new
- (void)showPIPNow
{
	@try {
		if(![self isReadyForDisplay]) {
			return;
		}
		[self.player setAllowsExternalPlayback:YES];
		if(!self.AVPictureInPictureController) {
			self.AVPictureInPictureController =  [[objc_getClass("AVPictureInPictureController") alloc] initWithPlayerLayer:self];
		}
		AVPictureInPictureControllerCurrent = self.AVPictureInPictureController;
		if(self.AVPictureInPictureController) {
			PGPictureInPictureProxy* PIPProxy = MSHookIvar<PGPictureInPictureProxy *>(self.AVPictureInPictureController, "_pictureInPictureProxy");
			PIPProxy.pictureInPictureShouldStartWhenEnteringBackground = YES;
			[PIPProxy updatePictureInPicturePossible:YES];
		}
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		[[AVAudioSession sharedInstance] setActive:YES error: nil];
		[self setPIPModeEnabled:YES];
		if (self.AVPictureInPictureController&&![self.AVPictureInPictureController isPictureInPictureActive]) {
			[self.AVPictureInPictureController startPictureInPicture];
		}
	} @catch (NSException * e) {
	}
}
- (BOOL)canEnterPIPMode
{
	return YES;
}
%end


%hook AVPlayer
- (void)play
{
	%orig;
	if(autoShowPIP) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNSNoti object:nil];
	}	
}
- (BOOL)_isPIPModePossible
{
	return YES;
}
- (BOOL)isPIPModePossible
{
	return YES;
}
%end


%hook AVPictureInPictureController
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end
%hook AVPlayerControllerInternal
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end
%hook AVPlayerViewController
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end
%hook WebAVPlayerController
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end
%hook PGPictureInPictureRemoteObject
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end
%hook PGPictureInPictureProxy
- (BOOL)isPictureInPicturePossible
{
	return YES;
}
%end


%hook UIApplication
-(void)_applicationDidEnterBackground
{
	@try {
		if(AVPictureInPictureControllerCurrent&&[AVPictureInPictureControllerCurrent isPictureInPictureActive]) {
			return;	
		}
	} @catch (NSException * e) {
		
	}
	%orig;	
}
%end


#import <libactivator/libactivator.h>
@interface PIPEnablerActivator : NSObject
+ (id)sharedInstance;
- (void)RegisterActions;
@end
@implementation PIPEnablerActivator
+ (id)sharedInstance
{
    __strong static id _sharedObject;
	if (!_sharedObject) {
		_sharedObject = [[self alloc] init];
	}
	return _sharedObject;
}
- (void)RegisterActions
{
    if (access("/usr/lib/libactivator.dylib", F_OK) == 0) {
		dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	    if (Class la = objc_getClass("LAActivator")) {
			[[la sharedInstance] registerListener:(id<LAListener>)self forName:@"com.julioverne.pipenabler"];
		}
	}
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"PIPEnabler";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	return @"Current Playing Video to PIP";
}
- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
    static __strong UIImage* listenerIcon;
    if (!listenerIcon) {
		listenerIcon = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/PIPEnablerSettings.bundle"] pathForResource:scale==2.0f?@"icon@2x":@"icon" ofType:@"png"]];
	}
    return listenerIcon;
}
- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
    static __strong UIImage* listenerIcon;
    if (!listenerIcon) {
		listenerIcon = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/PIPEnablerSettings.bundle"] pathForResource:scale==2.0f?@"icon@2x":@"icon" ofType:@"png"]];
	}
    return listenerIcon;
}
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	@autoreleasepool {
		notify_post("com.julioverne.pipenabler/PIPNow");
	}
}
@end


static void settingsChangedPIPEnabler(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@autoreleasepool {
		NSDictionary *PIPPrefs = [[[NSDictionary alloc] initWithContentsOfFile:@PLIST_PATH_Settings]?:[NSDictionary dictionary] copy];
		autoShowPIP = (BOOL)([[PIPPrefs objectForKey:kShowPIP]?:@YES boolValue]);
	}
}

static void currentVideoToPIP(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNSNotiTG object:nil];
}


static const CFStringRef kPicInPic = CFSTR("nVh/gwNpy7Jv1NOk00CMrw");
static Boolean (*MGGetBoolAnswer_o)(CFStringRef property);
static Boolean MGGetBoolAnswer_r(CFStringRef property)
{
	Boolean ret = MGGetBoolAnswer_o(property);
	if(CFEqual(property, kPicInPic)) {
		ret = true;
	}
	return ret;
}

%ctor
{
	@autoreleasepool {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedPIPEnabler, CFSTR("com.julioverne.pipenabler/SettingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, currentVideoToPIP, CFSTR("com.julioverne.pipenabler/PIPNow"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		settingsChangedPIPEnabler(NULL, NULL, NULL, NULL, NULL);
		%init;
		MSHookFunction((void *)(dlsym(RTLD_DEFAULT, "MGGetBoolAnswer")), (void *)MGGetBoolAnswer_r, (void **)&MGGetBoolAnswer_o);
		if(%c(SpringBoard)!=nil) {
			[[PIPEnablerActivator sharedInstance] RegisterActions];
		}
	}
}
