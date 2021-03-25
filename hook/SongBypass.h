#import <UIKit/UIKit.h>


@interface SongBypassTool1 : NSObject <UIAlertViewDelegate>
-(void)showAlert;
@end

@interface SongBypassTool2 : NSObject <UIAlertViewDelegate>
@property (nonatomic, retain) NSURL* bypassURL;
@property (retain) SongBypassTool1* releaser;
-(void)errorMessage:(NSString*)message;
-(void)showAlert;
-(void)gdStuffSongID:(int)songid url:(NSString*)url;
@end