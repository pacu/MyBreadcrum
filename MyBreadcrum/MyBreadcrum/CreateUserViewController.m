//
//  ACCreateUserViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "CreateUserViewController.h"
#import "ACAppDelegate.h"
#import "User.h"




@interface CreateUserViewController ()
@property (nonatomic,strong) NSFetchedResultsController *userResults;
@end
#define PASSWORD_LENGHT 8
@implementation CreateUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    ACAppDelegate *appDelegate = APP_DELEGATE;
    NSFetchRequest          * request   = [[NSFetchRequest alloc ]initWithEntityName:@"User"];
    NSManagedObjectContext  * ctx       = appDelegate.managedObjectContext;
    NSError                 * error     = nil;
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"username" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    
    // retrieve user list to validate unicity
    self.userResults = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];

    [self.userResults performFetch:&error];
    
    NSAssert(!error, @"Error should be nil %@",error);
    
    

    [self registerForKeyboardNotifications];

    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.errorLabel             = nil;
    self.passwordField          = nil;
    self.confirmPasswordField   = nil;
    self.errorLabel             = nil;
    self.createUserButton       = nil;
    self.delegate               = nil;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender{

    [self.delegate createUserCancelled];
}
-(IBAction)save:(id)sender{
    
    NSString * message = nil;
    if ([self isFormValid:&message]){
        NSEntityDescription * desc = [NSEntityDescription entityForName:@"User"
                                                 inManagedObjectContext:[APP_DELEGATE managedObjectContext] ];
        
        User              *newUser = [[User alloc]initWithEntity:desc
                                  insertIntoManagedObjectContext:[APP_DELEGATE managedObjectContext]];
        
        newUser.username    = self.userField.text;
        newUser.password    = self.passwordField.text; // DISCUSSION: Password should be stored as a HASH of the original string
        
        if (![APP_DELEGATE saveContext]) {
            [[[UIAlertView alloc]initWithTitle:@"Error"
                                       message:@"There was a problem saving your user"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles: nil]show];
        }
        [self.delegate didCreateUser:self];
        
    }else {
        self.errorLabel.text    = message;
        self.errorLabel.hidden  = NO;
        
        
    }
    

        
}
#pragma mark - validation
-(BOOL) isFormValid:(__autoreleasing NSString**)message{
    NSPredicate         *predicate = [NSPredicate predicateWithFormat:@"username = %@",self.userField.text];
    
    NSArray                 *array = [[self.userResults fetchedObjects] filteredArrayUsingPredicate:predicate];
    
    NSMutableString  *errorMessage = [[NSMutableString alloc] initWithString:@""];
    BOOL                     error = NO;
    
    if ([self.userField.text length]<=0){ //user is empty
        
        [errorMessage appendString:@"Username is invalid"];
        error = YES;
        
    }else if (array.count != 0){ //user already exists
        
        [errorMessage appendString:@"User name is already taken. "];
        error = YES;
        
    }
    
    if ([self.passwordField.text length]< PASSWORD_LENGHT){ // password is too short
        [errorMessage appendString:@"\nPassword is too short use 8 or more chars. "];
        error = YES;
    }else{
        if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) { // passwords do not match
            [errorMessage appendString:@"\nPasswords do not match"];
            error = YES;
        }
    }
    
    
    if (error){
        *message = errorMessage;
    }
    return !error;
    
    
}
#pragma mark - textfield delegate and stuff
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _activeTextField = textField;
    
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
    
    if (textField.tag == MBCreateUserFieldConfirm) {
        [textField resignFirstResponder];
        [self save:textField];
        return YES;
    }else {
        UITextField *next = (UITextField*)[self.view viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
        _activeTextField = next;
        
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

    [self moveSubView:_activeTextField awayFromKeyboardFrame:_lastKeyboardFrame];

    
   
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    [self animateViewReset];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    if (touch.view != _activeTextField){
        [_activeTextField resignFirstResponder];
        _activeTextField = nil;
    }
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - animations
-(void)animateViewReset {

    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];

}


/**
 Moves the subview away (upwards) from the received frame height. 
 use this method to make a textfield visible when is hidden by the keyboard.
 */
-(void)moveSubView:(UIView*)subview awayFromKeyboardFrame:(CGRect)rect{
    if (CGRectIntersectsRect(rect, subview.frame)){
        CGFloat viewOffset = subview.frame.origin.y - rect.origin.y + subview.frame.size.height ;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-viewOffset, self.view.frame.size.width, self.view.frame.size.height);
            
        }];
    }
}
@end
