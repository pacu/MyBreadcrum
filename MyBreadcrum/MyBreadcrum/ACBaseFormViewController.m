//
//  ACBaseFormViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "ACBaseFormViewController.h"

@interface ACBaseFormViewController ()

@end

@implementation ACBaseFormViewController
@synthesize activeTextField,textFieldResponderChain;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.lastResponderInvokesAction = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSIndexSet *unsortedTextfieldsIndexes = [[self.view subviews] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
            BOOL isTextField = [obj isKindOfClass:[UITextField class]];
            
            if (isTextField && [obj tag]==0)
                @throw [NSException exceptionWithName:@"UntaggedTextFieldException"
                                               reason:@"untagged texfield on responder chain"
                                             userInfo:nil];
        
            return isTextField;
        
    }];
    
    
    NSSortDescriptor *tagSorter = [[NSSortDescriptor alloc]initWithKey:@"tag" ascending:YES];
    NSArray * sortDescriptors = [NSArray arrayWithObject:tagSorter];
    
    
    self.textFieldResponderChain = [[[self.view subviews]objectsAtIndexes:unsortedTextfieldsIndexes] sortedArrayUsingDescriptors:sortDescriptors];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield delegate and stuff
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.activeTextField = textField;
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
    
}// became first responder

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == [self.textFieldResponderChain count] && self.lastResponderInvokesAction) {
        [textField resignFirstResponder];
        [self actionAfterLastResponder];
        return YES;
    }else {
        UITextField *next = (UITextField*)[self.textFieldResponderChain objectAtIndex:textField.tag]; // tag has the nominal position of the array not the index
        [next becomeFirstResponder];
        self.activeTextField = next;
        
        [self moveSubView:next awayFromKeyboardFrame:_lastKeyboardFrame];
        return NO;
    }
    return YES;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary      *info = [aNotification userInfo];
    
    _lastKeyboardFrame      = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    [self moveSubView:self.activeTextField awayFromKeyboardFrame:_lastKeyboardFrame];
    
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [self animateViewReset];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if (touch.view != self.activeTextField){
        [self.activeTextField resignFirstResponder];
        self.activeTextField = nil;
    }
    [super touchesBegan:touches withEvent:event];
}
#pragma mark - animations

-(void)animateViewReset {
    
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
    
}

-(void)moveSubView:(UIView*)subview awayFromKeyboardFrame:(CGRect)rect{
    if (CGRectIntersectsRect(rect, subview.frame)){
        CGFloat viewOffset = subview.frame.origin.y - rect.origin.y + subview.frame.size.height ;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-viewOffset, self.view.frame.size.width, self.view.frame.size.height);
            
        }];
    }
}

-(void)actionAfterLastResponder {
    //abstract method
}

-(BOOL) isFormValid:(__autoreleasing NSString**)message {
    *message = nil;
    return YES;
}
@end
