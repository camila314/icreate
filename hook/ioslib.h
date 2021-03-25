#import <UIKit/UIKit.h>
#include <string>
#include <mach-o/dyld.h>
#include <map>
#include <cc_defs.hpp>

#define ADD_HOOK(addr, redirect) sus->insert(std::pair<long, long>(getBase()+(addr), reinterpret_cast<long>(redirect))); \
	original_##redirect = getBase()+(addr)+8

inline long getBase() {
    return _dyld_get_image_vmaddr_slide(0)+0x100000000;
}

void logData(char const* title, const std::string& data);

extern std::map<long, long>* sus;

void inject() __attribute__((constructor));