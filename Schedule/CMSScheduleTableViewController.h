#import <UIKit/UIKit.h>
#import "CMSSession.h"
#import "CMSScheduleDataSource.h"

@class CMSFlipThroughContainerViewController;

@interface CMSScheduleTableViewController : UITableViewController
<NSFetchedResultsControllerDelegate, CMSScheduleDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *localContext;

@end

