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
    
    if ([self.passwordField.text length]< MIN_PASSWORD_LENGTH){ // password is too short
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


-(void)actionAfterLastResponder {
    [self save:nil];
}


@end
