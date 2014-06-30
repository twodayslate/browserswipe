/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

@interface SessionController
-(BOOL)canGoBack;
-(BOOL)canGoForward;
-(void)goBack;
-(void)goForward;
- (id)visibleEntry;
@end

@interface SideSwipeGestureRecognizer : UIPanGestureRecognizer
-(void)touchesEnded:(id)arg1 withEvent:(id)arg2;
-(void)touchesBegan:(id)arg1 withEvent:(id)arg2;
@end

@interface CardSideSwipeView : UIView
-(id)initWithFrame:(CGRect)arg1 topMargin:(float)arg2 model:(id)arg3 isIncognito:(BOOL)arg4;
-(void)handleHorizontalPan:(id)arg1;
-(void)setCardTabDisplaySide:(int)arg1;
-(void)updateViewsForDirection:(unsigned)arg1;
-(void)setupCard:(id)arg1 withIndex:(int)arg2;
-(void)updateCards;
-(void)updateCardPositions;
@end

@interface TabModelObserver
-(void)tabModel:(id)arg1 didReplaceTab:(id)arg2 withTab:(id)arg3 atIndex:(unsigned)arg4;
-(void)tabModel:(id)arg1 didChangeActiveTab:(id)arg2 previousTab:(id)arg3 atIndex:(unsigned)arg4 ;
@end

%hook TabModelObserver
-(void)tabModel:(id)arg1 didReplaceTab:(id)arg2 withTab:(id)arg3 atIndex:(unsigned)arg4 {%log; %orig; }
-(void)tabModel:(id)arg1 didChangeActiveTab:(id)arg2 previousTab:(id)arg3 atIndex:(unsigned)arg4  { %log; %orig; }
%end

@interface Tab 
-(id)history;
-(BOOL)canGoBack;
-(BOOL)canGoForward;
-(void)goBack;
-(void)goForward;
@end

@interface TabModel
- (id)currentTab;
@end

@interface BrowserViewController
- (void)handleiPhoneSwipe:(id)fp8;
- (void)handleiPadSwipe:(id)fp8;
- (id)currentSessionEntry;
- (id)tabModel;
@end

%hook BrowserViewController
- (void)handleiPhoneSwipe:(SideSwipeGestureRecognizer *)fp8 { 
	//%log;
	if([fp8 state] == 3) { // 1 = Began, 2 = Changed, 3 = Ended
		//NSLog(@"Session Entry = %@",[self currentSessionEntry]);
		TabModel *curMod = [self tabModel];
		Tab *curTab = [curMod currentTab];
		if([curTab canGoBack]) {
			[curTab goBack];
		}
	} 
}
- (void)handleiPadSwipe:(id)fp8 {
	//%log;
	if([fp8 state] == 3) { // 1 = Began, 2 = Changed, 3 = Ended
		//NSLog(@"Session Entry = %@",[self currentSessionEntry]);
		TabModel *curMod = [self tabModel];
		Tab *curTab = [curMod currentTab];
		if([curTab canGoBack]) {
			[curTab goBack];
		}
	} 
}
%end

%hook CardSideSwipeView
-(void)handleHorizontalPan:(id)arg1 { %log; %orig; }
-(void)setCardTabDisplaySide:(int)arg1 { %log; %orig; }
-(void)updateViewsForDirection:(unsigned)arg1{ %log; %orig; } // 1 = left, 2 = right
-(void)setupCard:(id)arg1 withIndex:(int)arg2{ %log; %orig; }
-(void)updateCards { %log; %orig; }
-(void)updateCardPositions { %log; %orig; }
%end

%hook SideSwipeGestureRecognizer
-(void)touchesEnded:(id)arg1 withEvent:(id)arg2 {
	%log; %orig;
}
%end