//
//  XMActionSheetDatePicker.h
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import "XMAbstractActionSheetPicker.h"
@class XMActionSheetDatePicker;

typedef void(^ActionDateDoneBlock)(XMActionSheetDatePicker *picker, id selectedDate, id origin); //selectedDate is NSDate or NSNumber for "UIDatePickerModeCountDownTimer"
typedef void(^ActionDateCancelBlock)(XMActionSheetDatePicker *picker);

@interface XMActionSheetDatePicker : XMAbstractActionSheetPicker
@property (nonatomic, retain) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nonatomic, retain) NSDate *maximumDate; // default is nil

@property (nonatomic) NSInteger minuteInterval; // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30

@property (nonatomic, retain) NSLocale   *locale;   // default is [NSLocale currentLocale]. setting nil returns to default
@property (nonatomic, copy)   NSCalendar *calendar; // default is [NSCalendar currentCalendar]. setting nil returns to default
@property (nonatomic, retain) NSTimeZone *timeZone; // default is nil. use current time zone or time zone from calendar

@property (nonatomic, assign) NSTimeInterval countDownDuration; // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).

@property (nonatomic, copy) ActionDateDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionDateCancelBlock onActionSheetCancel;


+ (instancetype)showPickerWithTitle:(NSString *)title
                     datePickerMode:(UIDatePickerMode)datePickerMode
                       selectedDate:(NSDate *)selectedDate
                        minimumDate:(NSDate *)minimumDate
                        maximumDate:(NSDate *)maximumDate
                          doneBlock:(ActionDateDoneBlock)doneBlock
                        cancelBlock:(ActionDateCancelBlock)cancelBlock
                             origin:(UIView*)view;

@end
