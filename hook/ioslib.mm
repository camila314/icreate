#include "ioslib.h"

void error() {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fatal error" 
                                                    message:@"Unable to find hook address" 
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
    [alert show];
    [alert release];
}

void logData(char const* title, const std::string& data) {
    dispatch_async(dispatch_get_main_queue(), ^{
        FLAlertLayer::create(title, data, "Ok")->show();
    });
}

extern "C" {
long findthehook(long inp) {
    if (sus->count(inp) > 0) {
        return sus->at(inp);
    } else {
        return reinterpret_cast<long>(error);
    }
}
}