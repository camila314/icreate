// Copyright 2021 sex
#include "ioslib.h"
#include "SongBypass.h"
#include "AntiPiracy.h"
#include <cc_defs.hpp>
#include <string>
#include <vector>
#include <algorithm>

extern long base;

using namespace cocos2d;
#define ANTIPIRACY_ 1

//** SONG BYPASS

SongBypassTool1* del;

extern "C" {
void addMusicString(char const* music) {
    std::string mus(music);
    auto a = MusicDownloadManager::sharedState();
    a->addSong(mus);
}
void reloadMusic() {
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
                                                                        error:NULL];
    NSMutableArray *mp3Files = [[NSMutableArray alloc] init];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"mp3"]) {
            std::string strPath([[filename stringByDeletingPathExtension] UTF8String]);

                NSString* str = @"1~|~%@~|~2~|~Song %@~|~3~|~615~|~4~|~camden314~|~5~|~6.9~|~6~|~~|~10~|~localhost~|~7~|~";
                NSString* out = [NSString stringWithFormat:str, [filename stringByDeletingPathExtension], [filename stringByDeletingPathExtension]];
                addMusicString([out UTF8String]);
        }
    }];
}
}

long original_songBypass;
__attribute__((naked)) void trampoline_songBypass(long instance) {
    __asm volatile (
        "sub sp, sp, #0x30\n"
        "stp x20, x19, [sp, #0x10]\n"
        "br %[t]"
        : 
        : [t] "r" (original_songBypass)
        );
}
void songBypass(long instance) { // my hook 
    SongBypassTool1* del = [[SongBypassTool1 alloc] init];
    [del retain];
    [del showAlert];

    trampoline_songBypass(instance); // this gonna fail lmao
}

//** SHOW DEGREES FOR ROTATION

CCLabelBMFont* sharedLabel;
long original_rotateDeg;
__attribute__((naked)) void trampoline_rotateDeg(GJRotationControl* instance, CCPoint ccp) {
    __asm volatile (
        "sub sp, sp, #0x40\n"
        "stp d9, d8, [sp, #0x10]\n"
        "br %[t]"
        :
        : [t] "r" (original_rotateDeg)
    );
}
void rotateDeg(GJRotationControl* slf, CCPoint loc) {
    trampoline_rotateDeg(slf, loc);
    sharedLabel->setString(CCString::createWithFormat("%d", (int)slf->_rotation())->getCString());
}

long original_rotateInit;
__attribute__((naked)) void trampoline_rotateInit(GJRotationControl* instance) {
    __asm volatile (
        "sub sp, sp, #0x30\n"
        "stp x20, x19, [sp, #0x10]\n"
        "br %[t]"
        :
        : [t] "r" (original_rotateInit)
    );
}
void rotateInit(GJRotationControl* slf) {
    trampoline_rotateInit(slf);
    sharedLabel = CCLabelBMFont::create("0", "bigFont.fnt");
    slf->addChild(sharedLabel);
    sharedLabel->setPosition(CCPoint(0,40));
    sharedLabel->setScale(0.5);

    SongBypassTool1* del = [[SongBypassTool1 alloc] init];
    [del retain];
    [del showAlert];
}

std::map<long, long>* sus;
void inject() {
    base = getBase();
    // piracy lol
    #ifdef ANTIPIRACY_
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[AntiPiracy alloc] init] check];
        });
    #endif
    // piracy lol
    sus = new std::map<long, long>();
    ADD_HOOK(0x3a02c, songBypass);
    ADD_HOOK(0x2c4a50, rotateDeg);
    ADD_HOOK(0x2c4914, rotateInit);

    reloadMusic();
}