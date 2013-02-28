#import "CMSSessionsTableViewController.h"
#import "CMSScheduleTableViewCell.h"
#import "CMSSpeaker.h"
#import "CMSDocument.h"

@implementation CMSSessionsTableViewController

@synthesize fetchedResultsController=_fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) return _fetchedResultsController;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[CMSSession entityName]];

    NSSortDescriptor *startSort = [NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"topic" ascending:YES];
    [fetchRequest setSortDescriptors:@[startSort, nameSort]];

    _fetchedResultsController.delegate = nil;
    NSManagedObjectContext *context = [CMSDocument sharedDocument].managedObjectContext;
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"start" cacheName:@"Sessions"];
    _fetchedResultsController.delegate = self;

    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Error performing fetch: %@", error);
    }

    return _fetchedResultsController;
}

@end
