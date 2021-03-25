#import "SongBypass.h"
#import <AVFoundation/AVFoundation.h>

extern void addMusicString(char const* music);

@implementation NSString (SwagMoment)

- (BOOL)isEmpty {
   if([self length] == 0) { //string is empty or nil
       return YES;
   } 

   if(![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
       //string is all whitespace
       return YES;
   }

   return NO;
}

@end

@implementation SongBypassTool1
-(void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Song Bypass"
                                                    message:@"Enter the URL for the song (must be mp3)"
                                                   delegate:self
                                          cancelButtonTitle:@"cancl"
                                          otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* urlstr = [alertView textFieldAtIndex:0].text;

        NSURL* url = [NSURL URLWithString:urlstr];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];

        if (![NSURLConnection canHandleRequest:req]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"Invalid URL" 
                                                            delegate:nil
                                                            cancelButtonTitle:@"ok" 
                                                            otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            SongBypassTool2* del = [[SongBypassTool2 alloc] init];
            [del retain];
            del.releaser = self;
            del.bypassURL = url;
            [del showAlert];
        }
    });

}

@end


@implementation SongBypassTool2

-(void)gdStuffSongID:(int)songid url:(NSString*)url {
    NSString* str = @"1~|~%d~|~2~|~Song %d~|~3~|~615~|~4~|~camden314~|~5~|~6.9~|~6~|~~|~10~|~%@~|~7~|~";
    NSString* out = [NSString stringWithFormat:str, songid, songid, url];
    addMusicString([out UTF8String]);

}
-(void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Song Bypass"
                                                    message:@"Enter the song ID"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:@"Ok",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}
-(void)errorMessage:(NSString*)message {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:message
                                                        delegate:nil
                                                        cancelButtonTitle:@"ok" 
                                                        otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self release];
        [self.releaser release];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSString* idstr = [alertView textFieldAtIndex:0].text;
    if ([idstr isEmpty])
        return;

    int i = [idstr integerValue];
    if (i <= 0 || i>100000000) {
        [self errorMessage:@"Invalid Song ID"];
        return;
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* destination = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp3",i]];

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.bypassURL];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *urlData, NSURLResponse *response, NSError *error) {

      NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;  
        if (!urlData || [res statusCode]!=200 || error) {
            [self errorMessage:[NSString stringWithFormat:@"Could not download mp3, statuc returned %d", (int)[res statusCode]]];
        } else {

            NSError* err;
            AVAudioPlayer *obj = [[AVAudioPlayer alloc]initWithData:urlData error:&err];
            if (!err) {
                [urlData writeToFile:destination atomically:YES];
                [self gdStuffSongID:i url:self.bypassURL.absoluteString];
            } else {
                [self errorMessage: @"mp3 file is unreadable"];
            }
        } 
        [self release];
        [self.releaser release];
    }];

    [postDataTask resume];
    });
}
@end