#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AntiPiracy : NSObject <UIAlertViewDelegate>
-(void)check;
@end

@interface NSString (SwagMD5)
- (NSString *)md5;
@end