//
//  CreatePlaylistViewController.m
//  PTMusicApp
//
//  Created by hieu nguyen on 12/20/14.
//  Copyright (c) 2014 Fruity Solution. All rights reserved.
//

#import "CreatePlaylistViewController.h"
#import <QuartzCore/QuartzCore.h> 

@interface CreatePlaylistViewController ()

@end

@implementation CreatePlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nameTxt becomeFirstResponder];
    self.nameTxt.layer.borderColor=  [[UIColor lightGrayColor] CGColor];
    self.nameTxt.layer.borderWidth= 1.0f;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)keyboardWillShow: (NSNotification *) notif{
    // Do something here
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide: (NSNotification *) notif{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= OFFSET_FOR_KEYBOARD;
        //rect.size.height += OFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += OFFSET_FOR_KEYBOARD;
        //rect.size.height -= OFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onOK:(id)sender {
    if (self.nameTxt.text.length > 0) {
        [self.delegate onCreatePlaylist:self.nameTxt.text];
    }

}

- (IBAction)onCancel:(id)sender {
    [self.delegate onCancel];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
@end
