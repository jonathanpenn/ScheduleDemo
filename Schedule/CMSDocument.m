#import "CMSDocument.h"

NSString * const kDocumentFileName = @"data.sqlite";

@implementation CMSDocument

@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

+ (instancetype)sharedDocument
{
    static CMSDocument *document = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        document = [[CMSDocument alloc] init];
    });
    return document;
}

- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)type
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    context.parentContext = self.managedObjectContext;
    return context;
}

- (BOOL)initializeDocument:(NSError **)error
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:self.persistentStoreURL
                                                         options:nil
                                                           error:error]) {
        return NO;
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];

    return YES;
}

- (BOOL)deleteAndReset:(NSError **)error
{
    // These will be reconstructed when the properties are next accessed.
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;

    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:self.persistentStoreURL.path]) {
        return [[NSFileManager defaultManager]
                removeItemAtURL:self.persistentStoreURL error:error];
    } else {
        return YES;
    }
}

- (BOOL)save:(NSError **)error
{
    __block BOOL savedOK = NO;
    [self.managedObjectContext performBlockAndWait:^{
        savedOK = [self.managedObjectContext save:error];
    }];

    return savedOK;
}


#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls lastObject];
}

- (NSURL *)persistentStoreURL
{
    return [self.applicationDocumentsDirectory URLByAppendingPathComponent:kDocumentFileName];
}

@end
