//
//  XMAbstractActionSheetPicker.h
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XMActionSheet;

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeValue,
    ActionTypeSelector,
    ActionTypeBlock
};

typedef NS_ENUM(NSInteger, TapAction) {
    TapActionNone,
    TapActionSuccess,
    TapActionCancel
};

typedef (void)(^ActionBlock)(void);

static NSString *const kButtonValue  = @"buttonValue";
static NSString *const kButtonTitle  = @"buttonTitle";
static NSString *const kActionType   = @"buttonAction";
static NSString *const kActionTarget = @"buttonActionTarget";

@interface XMAbstractActionSheetPicker : NSObject <UIPopoverControllerDelegate>
@property (nonatomic, strong) XMActionSheet *actionSheet;
@property (nonatomic, assign) UIWindowLevel windowLevel;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) int borderWidth;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic, assign, readonly) CGSize viewSize;
@property (nonatomic, strong) NSMutableArray *customButtons;
@property (nonatomic, assign) BOOL hideCancel; // show or hide cancel button.
@property (nonatomic, assign) CGRect presentFromRect;
@property (nonatomic, strong) NSDictionary *titleTextAttributes; // default is nil. Used to specify Title Label attributes.
@property (nonatomic, strong) NSAttributedString *attributedTitle; // default is nil. If titleTextAttributes not nil this value ignored.
@property (nonatomic, strong) NSMutableDictionary *pickerTextAttributes; // default with a NSMutableParagraphStyle to set label align center. Used to specify Picker Label attributes.
@property (nonatomic, strong) UIColor *pickerBackgroundColor;
@property (nonatomic, strong) UIColor *toolbarBackgroundColor;
@property (nonatomic, strong) UIColor *toolbarButtonsColor;
@property (nonatomic, strong) NSNumber *pickerBlurRadius;
@property (nonatomic, strong) Class popoverBackgroundViewClass; //allow popover customization on iPad
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations; // You can set your own supportedInterfaceOrientations value to prevent dismissing picker in some special cases.
@property (nonatomic, copy  ) TapAction tapDismissAction; // Specify, which action should be fired in case of tapping outside of the picker (on top darkened side). Default is TapActionNone.
@property (nonatomic, assign) BOOL popoverDisabled; // Disable popover behavior on iPad


- (void)setTextColor:(UIColor *)textColor;

// For subclasses.
- (instancetype)initWithTarget:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;

// Present the ActionSheetPicker
- (void)showActionSheetPicker;

// For subclasses.  This is used to send a message to the target upon a successful selection and dismissal of the picker (i.e. not canceled).
- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin;

// For subclasses.  This is an optional message upon cancelation of the picker.
- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin;

// For subclasses.  This returns a configured picker view.  Subclasses should autorelease.
- (UIView *)configuredPickerView;

// Adds custom buttons to the left of the UIToolbar that select specified values
- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value;

// Adds custom buttons to the left of the UIToolbar that implement specified block
- (void)addCustomButtonWithTitle:(NSString *)title actionBlock:(ActionBlock)block;

// Adds custom buttons to the left of the UIToolbar that implement specified selector
- (void)addCustomButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;

//For subclasses. This responds to a custom button being pressed.
- (void)customButtonPressed:(id)sender;

// Allow the user to specify a custom cancel button
- (void)setCancelButton:(UIBarButtonItem *)button;

// Allow the user to specify a custom done button
- (void)setDoneButton:(UIBarButtonItem *)button;

// Hide picker programmatically
- (void)hidePickerWithCancelAction;

@end
