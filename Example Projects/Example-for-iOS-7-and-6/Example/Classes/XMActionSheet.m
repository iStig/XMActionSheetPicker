//
//  XMActionSheet.m
//  ActionSheetPicker-iOS-5-7
//
//  Created by iStig on 2018/7/6.
//

#import "XMActionSheet.h"

static const float delay = 0.f;
static const float duration = 0.25f;
static const enum UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn;

@interface XMActionSheetViewController: UIViewController
@property (nonatomic, strong) XMActionSheet *actionSheet;
@end

@interface XMActionSheet () {
    UIWindow *_XMActionSheetWindow;
    UIView *_view;
}

@property (nonatomic, assign) BOOL presented;
@property (nonatomic, assign) UIWindowLevel windowLevel;

- (void)configureFrameForBounds:(CGRect)bounds;
- (void)showInContainerViewAnimated:(BOOL)animated;

@end

@implementation XMActionSheet

#pragma mark -- life cycle
- (instancetype)initWithView:(UIView *)aView windowLevel:(UIWindowLevel)windowLevel {
    if ((self = [super init])) {
        _view = aView;
        _windowLevel = windowLevel;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:247.f/255.f green:247.f/255.f blue:247.f/255.f alpha:1.0f];
        [self addSubview:_bgView];
        [self addSubview:_view];
    }
    return self;
}

#pragma mark -- publice method
- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated {
    CGPoint fadeOutToPoint = CGPointMake(_view.center.x, self.center.y + CGRectGetHeight(_view.frame));
    
    void (^actions)(void) = ^{
        self.center = fadeOutToPoint;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.0f];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        [self destroyWindow];
        [self removeFromSuperview];
    };
    
    if (animated) {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:actions
                         completion:completion];
    } else {
        actions();
        completion(YES);
    }
    
    self.presented = NO;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    [self showInContainerView];
}

- (void)showInContainerView {
    UIWindow *sheetWindow = [self window];
    if (![sheetWindow isKeyWindow]) {
        [sheetWindow makeKeyAndVisible];
    }
    sheetWindow.hidden = NO;
    self.actionSheetContainer.actionSheet = self;
}

#pragma mark -- private method
- (void)configureFrameForBounds:(CGRect)bounds {
    self.frame = CGRectMake(bounds.origin.x,
                            bounds.origin.y,
                            bounds.size.width,
                            bounds.size.height + _view.bounds.size.height);
    
    _view.frame = CGRectMake(_view.bounds.origin.x,
                             bounds.size.height,
                             _view.bounds.size.width,
                             _view.bounds.size.height);
    
    _view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _bgView.frame = _view.frame;
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)showInContainerViewAnimated:(BOOL)animated {
    CGPoint toPoint;
    CGFloat y = self.center.y - CGRectGetHeight(_view.frame);
    toPoint = CGPointMake(self.center.x, y);

    void (^animations)(void) = ^{
        self.center = toPoint;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f];
    };

    if (animated) {
    [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:nil];
    } else {
    animations();
    }
    self.presented = YES;
}

- (void)destroyWindow {
    if (_XMActionSheetWindow) {
        
        [self actionSheetContainer].actionSheet = nil;
        _XMActionSheetWindow.hidden = YES;
        
        if ([_XMActionSheetWindow isKeyWindow]) {
            [_XMActionSheetWindow resignFirstResponder];
        }
        
        _XMActionSheetWindow.rootViewController = nil;
        _XMActionSheetWindow = nil;
    }
}

#pragma mark -- getter&&setter
- (XMActionSheetViewController *)actionSheetContainer {
    return (XMActionSheetViewController *) [self window].rootViewController;
}

- (UIWindow *)window {
    if (_XMActionSheetWindow) {
        return _XMActionSheetWindow;
    } else {
        return _XMActionSheetWindow = ({
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel        = self.windowLevel;
            window.backgroundColor    = [UIColor clearColor];
            window.rootViewController = [XMActionSheetViewController new];
            window;
        });
    }
}

@end


#pragma mark - XMActionSheet Container
@implementation XMActionSheetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self presentActionSheetAnimated:YES];
}

- (void)setActionSheet:(XMActionSheet *)actionSheet {
    // Prevent processing one action sheet twice
    if (_actionSheet == actionSheet)
    return;
    // Dissmiss previous action sheet if it presented
    if (_actionSheet.presented)
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    // Remember new action sheet
    _actionSheet = actionSheet;
    // Present new action sheet
    [self presentActionSheetAnimated:YES];
}

- (void)presentActionSheetAnimated:(BOOL)animated {
        // New action sheet will be presented only when view controller will be loaded
    if (_actionSheet && [self isViewLoaded] && !_actionSheet.presented) {
        [_actionSheet configureFrameForBounds:self.view.bounds];
        _actionSheet.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_actionSheet];
        [_actionSheet showInContainerViewAnimated:animated];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [UIApplication sharedApplication].statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

// iOS6 support
- (BOOL)shouldAutorotate {
    return YES;
}

@end

