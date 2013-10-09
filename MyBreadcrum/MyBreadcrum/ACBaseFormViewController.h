//
//  ACBaseFormViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

//Provides functionality to handle several textfields on a responder chain.
//contains animations to shift the view up so that textfields are not
//hidden by the keyboard
//UIResponder chain of textfields is created by the textfield's tag attribute
//which cannot be zero in any case. Tag must be a continous number starting
//from 1.
//The last text view will trigger  the actionAfterLastResponder Method if the
//property lastResponderInvokesAction is set to YES


#import <UIKit/UIKit.h>

@interface ACBaseFormViewController : UIViewController <UITextFieldDelegate>{
        CGRect          _lastKeyboardFrame;
}


// 0 is the first and count-1 is the last responder
@property (nonatomic,strong)    NSArray         *textFieldResponderChain;
@property (nonatomic,weak)      UITextField     *activeTextField;

// set if this is set to YES the actionAfterLastResponder is set to yes
@property (nonatomic)           BOOL             lastResponderInvokesAction;//default YES

/**
 resets the view to the original origin
 */
-(void)animateViewReset ;

/**
 Moves the subview away (upwards) from the received frame height.
 use this method to make a textfield visible when is hidden by the keyboard.
 */
-(void)moveSubView:(UIView*)subview awayFromKeyboardFrame:(CGRect)rect;



//abstract method
-(void)actionAfterLastResponder;


-(BOOL) isFormValid:(__autoreleasing NSString**)message;
@end


