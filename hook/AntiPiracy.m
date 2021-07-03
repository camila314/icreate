#import "AntiPiracy.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation AntiPiracy
-(void)check {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Anti-Piracy"
                                                    message:@"Enter the API key provided to you"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    // objc moment

    NSString* determiner = [paths[0] stringByAppendingPathComponent:@"chk"];
    if (![fileManager fileExistsAtPath:determiner]){ 
    	[alert show];
    }
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString* supplied = [alertView textFieldAtIndex:0].text;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    // objc moment

    NSString* determiner = [paths[0] stringByAppendingPathComponent:@"chk"];
    if (![fileManager fileExistsAtPath:determiner]){ 
        // first time running, check if its legit
        NSString *publicIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://ipv4.icanhazip.com/"] 
                                       encoding:NSUTF8StringEncoding error:nil];
        publicIP = [publicIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]; // remove \n

        NSString* beforeMD5 = [NSString stringWithFormat:@"%@wVaHjd93SH1mUKP8iEF8ToZ", publicIP];
        NSString* key= [beforeMD5 md5];

        if (![supplied isEqualToString:key]) {
            // cringe piracy
            dispatch_async(dispatch_get_main_queue(), ^{
	            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LOL"
	                                                       message:@"Wrong key."
	                                                       delegate:nil
	                                                       cancelButtonTitle:@"Ok"
	                                                       otherButtonTitles:nil];
	            [alert show];

	            [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer *timer) {
    				 __builtin_trap();
				}];
            });
        } else {
            // not cringe, legitimate copy
            void * bytes = malloc(4);
            NSData * data = [NSData dataWithBytes:bytes length:4];
            free(bytes);
            [data writeToFile:determiner atomically:NO];
            [self release];
        }
    }

}
@end




@implementation NSString (SwagMD5)
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
        result[0], result[1], result[2], result[3], 
        result[4], result[5], result[6], result[7],
        result[8], result[9], result[10], result[11],
        result[12], result[13], result[14], result[15]
        ];  
}
@end

