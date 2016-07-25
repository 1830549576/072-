#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *OUTPUT;
}

- (IBAction)inputAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *OUTPUT;
- (IBAction)eatBun:(id)sender;

@end

