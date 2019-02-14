//
//  UIKeyboardView.m
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardView.h"


@implementation UIKeyboardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:frame];
		
		keyboardToolbar.barStyle = UIBarStyleDefault;
        
		UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IQKeyboardManager.bundle/IQButtonBarArrowLeft"] style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonTap:)];;
		previousBarItem.tag=1;
		
        
        
		UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IQKeyboardManager.bundle/IQButtonBarArrowRight"] style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonTap:)];
		nextBarItem.tag=2;
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
																		style:UIBarButtonItemStyleDone
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
        
		doneBarItem.tag=3;
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem,spaceBarItem, nextBarItem,spaceBarItem,spaceBarItem,spaceBarItem,spaceBarItem, spaceBarItem, doneBarItem, nil]];
        [self addSubview:keyboardToolbar];
        
        
    }
    return self;
}
-(void)removeKeyboard{
    [keyboardToolbar removeFromSuperview];

}

-(void)removeDoneButton{
    [keyboardToolbar removeFromSuperview];
    UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IQKeyboardManager.bundle/IQButtonBarArrowLeft"] style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonTap:)];;
    previousBarItem.tag=1;
    
    
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IQKeyboardManager.bundle/IQButtonBarArrowRight"] style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonTap:)];
    nextBarItem.tag=2;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"", @"")
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(toolbarButtonTap:)];
    
    doneBarItem.tag=3;
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem,spaceBarItem, nextBarItem,spaceBarItem,spaceBarItem,spaceBarItem,spaceBarItem, spaceBarItem, doneBarItem, nil]];
    [self addSubview:keyboardToolbar];
}
- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//根据index找出对应的UIBarButtonItem
- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar items] count]) {
		return [[keyboardToolbar items] objectAtIndex:itemIndex];
	}
	return nil;
}

@end
