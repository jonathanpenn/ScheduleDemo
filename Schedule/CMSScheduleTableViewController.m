#import "CMSScheduleTableViewController.h"
#import "CMSFlipThroughContainerViewController.h"
#import "CMSSessionDetailViewController.h"
#import "CMSScheduleTableViewCell.h"
#import "CMSSpeaker.h"
#import "CMSDocument.h"
#import "CMSDataLoader.h"

@interface CMSScheduleTableViewController ()

@property (nonatomic, strong) NSDateFormatter *indexFormatter;
@property (nonatomic, strong) NSDateFormatter *parsingDateFormatter;
@property (nonatomic, strong) NSDateFormatter *sectionDateFormatter;

@end

@implementation CMSScheduleTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefreshControl];
}


#pragma mark - Actions

- (void)refreshData:(id)sender
{
    [[CMSDataLoader sharedLoader] fetchAndRefreshData:^(NSError *error) {
        if (error) NSLog(@"Unable to refresh data: %@", error);
        [self.refreshControl endRefreshing];
    }];
}

- (void)cellSwiped:(UISwipeGestureRecognizer *)swipe
{
    CMSScheduleTableViewCell *cell = (CMSScheduleTableViewCell *)swipe.view;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    CMSSession *session = [self.fetchedResultsController objectAtIndexPath:path];

    [session toggleFavorite];
    NSError *error = nil;
    if (![[CMSDocument sharedDocument] save:&error]) {
        NSLog(@"Unable to perisist favorite to disk %@", error);
    }

    cell.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 animations:^{
        cell.starView.alpha = 1.0;
        cell.transform = CGAffineTransformMakeTranslation(40, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            cell.starView.alpha = 0.3;
            cell.transform = CGAffineTransformIdentity;
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSString *text = [self.sectionDateFormatter stringFromDate:[self.parsingDateFormatter dateFromString:sectionInfo.name]];
    return text;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *sections = [self.fetchedResultsController sections];
    if ([sections count] < 5) return nil;
    NSMutableArray *titles = [NSMutableArray array];
    for (id<NSFetchedResultsSectionInfo> sectionInfo in sections) {
        NSString *raw = [self.indexFormatter stringFromDate:[self.parsingDateFormatter dateFromString:sectionInfo.name]];
        NSArray *pieces = [raw componentsSeparatedByString:@" "];
        [titles addObject:[NSString stringWithFormat:@"%@ %@%@", pieces[0], pieces[1], pieces[2]]];
    }
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMSFlipThroughContainerViewController *flipController = [[CMSFlipThroughContainerViewController alloc] init];
    CMSSessionDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CMSSessionDetailViewController class])];
    CMSSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.session = session;
    controller.scheduleDataSource = self;
    [flipController setViewController:controller];
    [self.navigationController pushViewController:flipController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)path
{
    static NSString *CellIdentifier = @"ScheduleCell";
    CMSScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:path];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swipe];

    [self configureCell:cell atIndexPath:path];

    return cell;
}

- (void)configureCell:(CMSScheduleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CMSSession *session = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([session.isFavorite boolValue]) {
        cell.starView.hidden = NO;
        cell.starView.alpha = 0.3;
        cell.starView.isFilled = YES;
    } else {
        cell.starView.hidden = YES;
    }
    cell.topicControl.text = session.topic;
    cell.speakerControl.text = session.speaker.name;
}


#pragma mark - NSFetched Results Controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:(CMSScheduleTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Schedule Data Soruce

- (CMSSession *)nextSessionInListAfter:(CMSSession *)session
{
    NSIndexPath *path = [self.fetchedResultsController indexPathForObject:session];
    NSIndexPath *nextPath = nil;

    if (path == nil) {
        return nil;
    } else if (path.row < [self tableView:self.tableView numberOfRowsInSection:path.section] - 1) {
        nextPath = [NSIndexPath indexPathForRow:path.row + 1 inSection:path.section];
    } else if (path.section < [self numberOfSectionsInTableView:self.tableView] - 1) {
        nextPath = [NSIndexPath indexPathForRow:0 inSection:path.section + 1];
    } else {
        return nil;
    }

    return [self.fetchedResultsController objectAtIndexPath:nextPath];
}

- (CMSSession *)prevSessionInListBefore:(CMSSession *)session
{
    NSIndexPath *path = [self.fetchedResultsController indexPathForObject:session];
    NSIndexPath *prevPath = nil;

    if (path == nil) {
        return nil;
    } else if (path.row > 0) {
        prevPath = [NSIndexPath indexPathForRow:path.row-1 inSection:path.section];
    } else if (path.section > 0) {
        NSInteger row = [self tableView:self.tableView numberOfRowsInSection:path.section-1]-1;
        prevPath = [NSIndexPath indexPathForRow:row inSection:path.section-1];
    } else {
        return nil;
    }

    return [self.fetchedResultsController objectAtIndexPath:prevPath];
}


#pragma mark - Lazy Properties

- (NSDateFormatter *)parsingDateFormatter
{
    if (!_parsingDateFormatter) {
        _parsingDateFormatter = [[NSDateFormatter alloc] init];
        [_parsingDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    }
    return _parsingDateFormatter;
}

- (NSDateFormatter *)sectionDateFormatter
{
    if (!_sectionDateFormatter) {
        _sectionDateFormatter = [[NSDateFormatter alloc] init];
        [_sectionDateFormatter setDateFormat:@"EEE h:mm a"];
    }
    return _sectionDateFormatter;
}

- (NSDateFormatter *)indexFormatter
{
    if (!_indexFormatter) {
        _indexFormatter = [[NSDateFormatter alloc] init];
        [_indexFormatter setDateFormat:@"EEEEE h a"];
    }
    return _indexFormatter;
}


#pragma mark - Utility Methods

- (void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventAllEvents];
    self.refreshControl = refreshControl;
}


@end
