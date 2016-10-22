#import <dlfcn.h>
#import <objc/runtime.h>
#import <notify.h>
#import <substrate.h>

#define PLIST_PATH_Settings "/var/mobile/Library/Preferences/com.julioverne.pipenabler.plist"

@interface PGPictureInPictureProxy : NSObject
@property (assign,nonatomic) BOOL pictureInPictureShouldStartWhenEnteringBackground;
-(void)updatePictureInPicturePossible:(BOOL)arg1;
@end
@interface AVPlayer : NSObject
- (void)setAllowsExternalPlayback:(BOOL)arg1;
- (float)rate;
@end
@class AVPlayerLayer;
@interface AVPictureInPictureController : NSObject
{
    PGPictureInPictureProxy * _pictureInPictureProxy;
}
@property (nonatomic, retain) id delegate;
- (id)initWithPlayerLayer:(AVPlayerLayer*)arg1;
- (AVPlayerLayer*)playerLayer;

- (BOOL)isPictureInPictureActive;
- (void)startPictureInPicture;
- (void)stopPictureInPicture;
@end
@interface AVPlayerLayer : NSObject
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) AVPictureInPictureController* AVPictureInPictureController;
+ (id)playerLayerWithPlayer:(id)arg1;
-(void)setPIPModeEnabled:(BOOL)arg1;
- (BOOL)isReadyForDisplay;

- (void)requestShowPIPNow;
- (void)showPIPNow;
@end
extern id AVAudioSessionCategoryPlayback;
@interface AVAudioSession : NSObject
+ (id)sharedInstance;
- (BOOL)setCategory:(id)arg1 error:(id *)arg2;
- (BOOL)setActive:(BOOL)arg1 error:(id *)arg2;
@end