@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate> {
    UIWindow *window_;
    UINavigationController *navController_;

    CCDirectorIOS *director_;
}

@property(nonatomic, retain) UIWindow *window;
@property(readonly) UINavigationController *navController;
@property(readonly) CCDirectorIOS *director;

@end
