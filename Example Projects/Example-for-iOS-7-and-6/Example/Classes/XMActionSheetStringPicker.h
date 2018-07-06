//
//  XMActionSheetStringPicker.h
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import "XMAbstractActionSheetPicker.h"
@class XMActionSheetStringPicker;
typedef void(^ActionStringDoneBlock)(XMActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue);
typedef void(^ActionStringCancelBlock)(XMActionSheetStringPicker *picker);

@interface XMActionSheetStringPicker : XMAbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) ActionStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringCancelBlock onActionSheetCancel;

+ (instancetype)showPickerWithTitle:(NSString *)title
                               rows:(NSArray *)strings
                   initialSelection:(NSInteger)index
                          doneBlock:(ActionStringDoneBlock)doneBlock
                        cancelBlock:(ActionStringCancelBlock)cancelBlock
                             origin:(id)origin;

@end
