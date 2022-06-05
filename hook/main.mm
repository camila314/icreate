// Copyright 2021 sex
#include "ioslib.h"
#include "SongBypass.h"
#include "AntiPiracy.h"
#include <cc_defs.hpp>
#include <string>
#include <vector>
#include <algorithm>
#include <dlfcn.h>

extern long base;

using namespace cocos2d;
//#define ANTIPIRACY_ 1


#define TRAMPOLINE(fn, str, ...) \
    long original_##fn; \
    __attribute__((naked)) void trampoline_##fn(__VA_ARGS__) { \
        __asm volatile ( \
            str \
            "br %[t]" \
            : \
            : [t] "r" (original_##fn) \
        ); \
    }


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
                //addMusicString([out UTF8String]);
                if (out.UTF8String && strlen(out.UTF8String)>0) {
                    addMusicString([out UTF8String]);
                }
                //logData(out.UTF8String, std::string("does this have a title (yes or no)"));
        }
    }];
}
}


TRAMPOLINE(songBypass,
    "sub sp, sp, #0x30\n"
    "stp x20, x19, [sp, #0x10]\n"
, long)

void songBypass(long instance) { // my hook 
    SongBypassTool1* del = [[SongBypassTool1 alloc] init];
    [del retain];
    [del showAlert];

    trampoline_songBypass(instance);
}
//314

//** SHOW DEGREES FOR ROTATION

CCLabelBMFont* sharedLabel;

TRAMPOLINE(rotateDeg,
    "sub sp, sp, #0x40\n"
    "stp d9, d8, [sp, #0x10]\n"
, GJRotationControl*, CCPoint)

void rotateDeg(GJRotationControl* slf, CCPoint loc) {
    trampoline_rotateDeg(slf, loc);
    sharedLabel->setString(CCString::createWithFormat("%d", (int)slf->_rotation())->getCString());
}


TRAMPOLINE(rotateInit,
    "sub sp, sp, #0x30\n"
    "stp x20, x19, [sp, #0x10]\n"
, GJRotationControl*)

void rotateInit(GJRotationControl* slf) {
    trampoline_rotateInit(slf);
    sharedLabel = CCLabelBMFont::create("0", "bigFont.fnt");
    slf->addChild(sharedLabel);
    sharedLabel->setPosition(CCPoint(0,40));
    sharedLabel->setScale(0.5);
}
//314

//** GLOBAL CLIPBOARD

TRAMPOLINE(editorUiKilled,
    "stp x20, x19, [sp, #-0x20]!\n"
    "stp x29, x30, [sp, #0x10]\n"
, EditorUI*)

std::string g_clipboard;
void editorUiKilled(EditorUI* slf) {
    g_clipboard = slf->_clipboard();
    return trampoline_editorUiKilled(slf);
}


TRAMPOLINE(editorUiMade,
    "sub sp, sp, #0xe0\n"
    "stp d15, d14, [sp, #0x50]\n"
, EditorUI*, LevelEditorLayer*)

void editorUiMade(EditorUI* slf, LevelEditorLayer* lel) {
    trampoline_editorUiMade(slf, lel);
    slf->_clipboard() = g_clipboard;
    slf->updateButtons();
}
//314

//** PRACTICE SONG HACK

TRAMPOLINE(startMusic,
    "sub sp, sp, #0x70\n"
    "stp d9, d8, [sp, #0x30]\n"
, PlayLayer*)

void startMusic(PlayLayer* slf) {
    auto p = slf->_practiceMode();
    slf->_practiceMode() = false;
    trampoline_startMusic(slf);
    slf->_practiceMode() = p;
}

TRAMPOLINE(togglePracticeMode,
    "sub sp, sp, #0x40\n"
    "stp x20, x19, [sp, #0x20]\n"
, PlayLayer*, bool)

void togglePracticeMode(PlayLayer* slf, bool p) {
    if (!slf->_practiceMode() && p) {
        slf->_practiceMode() = p;
        slf->_uiLayer()->toggleCheckpointsMenu(p);
        startMusic(slf);
        if (p) slf->stopActionByTag(0x12);
    } else {
        trampoline_togglePracticeMode(slf, p);
    }
}

TRAMPOLINE(playerDestroyed,
    "stp x20, x19, [sp, #-0x20]!\n"
    "stp x29, x30, [sp, #0x10]\n"
, PlayerObject*, bool)

void playerDestroyed(PlayerObject* po, bool d) {
    GameSoundManager::sharedManager()->stopBackgroundMusic();
    trampoline_playerDestroyed(po, d);
}

//314

std::map<long, long>* sus;
void inject() {
    base = getBase();

    sus = new std::map<long, long>();
    ADD_HOOK(0x3a02c, songBypass);
    ADD_HOOK(0x2c4a50, rotateDeg);
    ADD_HOOK(0x2c4914, rotateInit);
    ADD_HOOK(0x2a5cdc, editorUiMade);
    ADD_HOOK(0x2a5c28, editorUiKilled);
    ADD_HOOK(0xaee60, startMusic);
    ADD_HOOK(0xb8c84, togglePracticeMode);
    ADD_HOOK(0x14a84c, playerDestroyed);


    dispatch_async(dispatch_get_main_queue(), ^{
        reloadMusic();
    });

    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent: @"shit.dylib"];
    dlopen(documents.UTF8String, RTLD_NOW);
}