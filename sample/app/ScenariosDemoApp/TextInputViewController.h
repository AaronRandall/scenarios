//
//  TextInputViewController.h
//  TableViewIOS5Demo
//
//  Created by Aaron Randall on 28/04/2013.
//
//

#import <UIKit/UIKit.h>

@interface TextInputViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInput;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end
