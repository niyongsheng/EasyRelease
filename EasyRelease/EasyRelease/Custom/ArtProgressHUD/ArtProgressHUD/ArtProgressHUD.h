#import <AppKit/AppKit.h>

typedef NS_ENUM(NSUInteger, EArtProgressHUDType){
    EArtProgressHUDInfo = 0,    //有图片的显示文本
    EArtProgressHUDWarning,     //警告
    EArtProgressHUDError,       //错误
    EArtProgressHUDSuccess,     //成功
    EArtProgressHUDLoading,     //loading
    EArtProgressHUDTypeNone     //无图片纯文字
};

@interface ArtProgressHUD : NSWindowController


/**
 吐司提示文字 无图片对应 EArtProgressHUDTypeNone

 @param aText 提示文本
 */
+ (void)showText:(NSString *)aText;


/**
 信息提示 EArtProgressHUDInfo

 @param aText 提示文本
 */
+ (void)showInfoText:(NSString *)aText;


/**
 错误提示 EArtProgressHUDError

 @param aText 提示文本
 */
+ (void)showErrorText:(NSString *)aText;


/**
 成功提示 EArtProgressHUDSuccess

 @param aText 提示文本
 */
+ (void)showSuccessText:(NSString *)aText;


/**
 文本提示 如果需要制定文本的位置view 使用这个方法 默认在整个window中提示

 @param aText 提示文本
 @param aType 提示类型
 @param aView 提示的位置
 */
+ (void)showText:(NSString *)aText type:(EArtProgressHUDType)aType inView:(NSView *)aView;


/**
 展示loading
 */
+ (void)showLoading;

/**
 在某个view上展示loading

 @param aView 对应的view
 */
+ (void)showLoading:(NSView *)aView;


/**
 view消失
 */
+ (void)dismissLoading;
@end
