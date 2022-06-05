#include <cc_defs.hpp>
#include <mach-o/dyld.h>
inline long getBase() {
    return _dyld_get_image_vmaddr_slide(0)+0x100000000;
}

long base;

typedef bool _void;

using namespace cocos2d;
#define STATIC_STUB(addr, ret, ...) \
	(reinterpret_cast<ret (*)(__VA_ARGS__)>(getBase()+addr))

#define MEMBER_STUB(cls, addr, ret, ...) \
	(reinterpret_cast<ret (*)(cls* self, __VA_ARGS__)>(getBase()+addr))

CCRect::CCRect(float a1, float b1, float c1, float d1) {MEMBER_STUB(CCRect, 0x16494,void,float,float,float,float)(this,a1,b1,c1,d1);}
ui::Margin::Margin() {return;}


CCSize::CCSize(float s1, float s2) {height = s2;width = s1;}
CCSize::CCSize() {height = 0.0;width = 0.0;}


CCPoint::CCPoint(float s1, float s2) {x = s1;y = s2;}
CCPoint::CCPoint() {x = 0.0;y = 0.0;}
CCPoint::CCPoint(CCPoint const& p) {x = p.x;y = p.y;}

void CCNode::stopActionByTag(int a) {return MEMBER_STUB(CCNode, 0x15ef98, void, int)(this, a);}

CCString* CCString::create(std::string const& s) {return STATIC_STUB(0x1a1f18, CCString*, std::string const&)(s);}
bool CCString::initWithFormatAndValist(char const* ck, va_list va) {return MEMBER_STUB(CCString, 0x1a1c30, bool, char const*, va_list)(this, ck, va);}
CCString* CCString::createWithFormat(const char* format, ...) {
    CCString* pRet = CCString::create("");
    va_list ap;
    va_start(ap, format);
    pRet->initWithFormatAndValist(format, ap);
    va_end(ap);

    return pRet;
}
const char* CCString::getCString() const {return m_sString.c_str();}


CCLabelBMFont* CCLabelBMFont::create(char const* a, char const* b) {return STATIC_STUB(0x2194ec, CCLabelBMFont*, char const*, char const*)(a,b);}

CCArray* CCDictionary::allKeys() {return MEMBER_STUB(CCDictionary, 0x2de774, CCArray*, _void)(this, 0);}

MusicDownloadManager* MusicDownloadManager::sharedState() {return STATIC_STUB(0xd1038, MusicDownloadManager*)();}
void MusicDownloadManager::addSong(std::string mus) {MEMBER_STUB(MusicDownloadManager, 0xd21a8, void, std::string)(this, mus);}

GameLevelManager* GameLevelManager::sharedState() {return STATIC_STUB(0x46ed0, GameLevelManager*)();}
CCDictionary* GameLevelManager::getAllUsedSongIds(){return MEMBER_STUB(GameLevelManager, 0x6ee90, CCDictionary*, _void)(this, 0);}


FLAlertLayer* FLAlertLayer::create(void* fdsg, char const* x, const std::string &thing, char const* l, char const* u, float f) {return STATIC_STUB(0x1fe374, FLAlertLayer*, void* fdsg, char const* x, const std::string &thing, char const* l, char const* u, float f)(fdsg,x,thing,l,u,f);}

void EditorUI::updateButtons() {MEMBER_STUB(EditorUI, 0x2b5754, void, _void)(this, 0);}

GameSoundManager* GameSoundManager::sharedManager() {return STATIC_STUB(0x1a29d0, GameSoundManager*)();}
void GameSoundManager::stopBackgroundMusic() {MEMBER_STUB(GameSoundManager, 0x1a3390, void, _void)(this, 0);}

void UILayer::toggleCheckpointsMenu(bool b) {MEMBER_STUB(UILayer, 0x2be14, void, bool)(this, b);}