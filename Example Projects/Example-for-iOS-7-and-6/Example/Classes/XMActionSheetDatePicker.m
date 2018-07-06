//
//  XMActionSheetDatePicker.m
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import "XMActionSheetDatePicker.h"
#import <objc/message.h>

@interface XMActionSheetDatePicker()
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDate *selectedDate;
@end

@implementation XMActionSheetDatePicker


+ (instancetype)showPickerWithTitle:(NSString *)title
                     datePickerMode:(UIDatePickerMode)datePickerMode
                       selectedDate:(NSDate *)selectedDate
                        minimumDate:(NSDate *)minimumDate
                        maximumDate:(NSDate *)maximumDate
                          doneBlock:(ActionDateDoneBlock)doneBlock
                        cancelBlock:(ActionDateCancelBlock)cancelBlock
                             origin:(UIView*)view
{
    XMActionSheetDatePicker* picker = [[XMActionSheetDatePicker alloc] initWithTitle:title
                                                                  datePickerMode:datePickerMode
                                                                    selectedDate:selectedDate
                                                                       doneBlock:doneBlock
                                                                     cancelBlock:cancelBlock
                                                                          origin:view];
    [picker setMinimumDate:minimumDate];
    [picker setMaximumDate:maximumDate];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title
               datePickerMode:(UIDatePickerMode)datePickerMode
                 selectedDate:(NSDate *)selectedDate
                    doneBlock:(ActionDateDoneBlock)doneBlock
                  cancelBlock:(ActionDateCancelBlock)cancelBlock
                       origin:(UIView*)origin
{
    self = [self initWithTitle:title datePickerMode:datePickerMode selectedDate:selectedDate target:nil action:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlock;
    }
    return self;
}

#pragma mark -- inherit superclass
- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = self.datePickerMode;
    datePicker.maximumDate = self.maximumDate;
    datePicker.minimumDate = self.minimumDate;
    datePicker.minuteInterval = self.minuteInterval;
    datePicker.calendar = self.calendar;
    datePicker.timeZone = self.timeZone;
    datePicker.locale = self.locale;
    
    // if datepicker is set with a date in countDownMode then
    // 1h is added to the initial countdown
    if (self.datePickerMode == UIDatePickerModeCountDownTimer) {
        datePicker.countDownDuration = self.countDownDuration;
        // Due to a bug in UIDatePicker, countDownDuration needs to be set asynchronously
        // more info: http://stackoverflow.com/a/20204317/1161723
        dispatch_async(dispatch_get_main_queue(), ^{
            datePicker.countDownDuration = self.countDownDuration;
        });
    } else {
        [datePicker setDate:self.selectedDate animated:NO];
    }
    
    [datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing (not used in this picker, but just in case somebody uses this as a template for another picker)
    self.pickerView = datePicker;
    
    return datePicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin
{
    if (self.onActionSheetDone)
    {
        if (self.datePickerMode == UIDatePickerModeCountDownTimer)
        self.onActionSheetDone(self, @(((UIDatePicker *)self.pickerView).countDownDuration), origin);
        else
        self.onActionSheetDone(self, self.selectedDate, origin);
        
        return;
    }
    else if ([target respondsToSelector:action])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (self.datePickerMode == UIDatePickerModeCountDownTimer) {
        [target performSelector:action withObject:@(((UIDatePicker *)self.pickerView).countDownDuration) withObject:origin];
        
    } else {
        [target performSelector:action withObject:self.selectedDate withObject:origin];
    }
#pragma clang diagnostic pop
    else
    NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), sel_getName(action));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin
{
    if (self.onActionSheetCancel)
    {
        self.onActionSheetCancel(self);
        return;
    }
    else
    if ( target && cancelAction && [target respondsToSelector:cancelAction] )
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark -- private method
- (void)eventForDatePicker:(id)sender
{
    if (!sender || ![sender isKindOfClass:[UIDatePicker class]])
    return;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.selectedDate = datePicker.date;
    self.countDownDuration = datePicker.countDownDuration;
}
@end
