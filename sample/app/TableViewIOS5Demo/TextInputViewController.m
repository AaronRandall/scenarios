//
//  TextInputViewController.m
//  TableViewIOS5Demo
//
//  Created by Aaron Randall on 28/04/2013.
//
//

#import "TextInputViewController.h"

@interface TextInputViewController ()

@end

@implementation TextInputViewController

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
    self.passwordInput.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextInput:nil];
    [self setPasswordInput:nil];
    [super viewDidUnload];
}
- (IBAction)login:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Demo event"
                                                      message:@"Login button clicked"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
@end
