//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"

@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate> {
	CGRect keyboardBounds;
	UIKeyboardView *keyboardToolbar;
    __unsafe_unretained id <UIKeyboardViewControllerDelegate> _boardDelegate;
    UIView *objectView;
}

@property (nonatomic, assign) id <UIKeyboardViewControllerDelegate> boardDelegate;
@property int isShowButton;
@end

@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional

- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (void)alttextViewDidEndEditing:(UITextView *)textView;
- (BOOL)textFieldShouldEnd:(UITextField *)textField;
@end
