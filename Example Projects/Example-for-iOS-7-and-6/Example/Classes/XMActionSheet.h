//
//  XMActionSheet.h
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMActionSheet : UIView
@property (nonatomic, strong) UIView *bgView;

- (instancetype)initWithView:(UIView *)view windowLevel:(UIWindowLevel)windowLevel;

- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated;

//这个方法可以取缔
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (void)showInContainerView;

@end
