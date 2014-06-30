@interface SideSwipeGestureRecognizer : UIPanGestureRecognizer { 
	unsigned direction_; 
	float swipeEdge_; 
}
@property (assign,nonatomic) float swipeEdge; 
@property (assign,nonatomic) unsigned direction; 
-(void)setDirection:(unsigned)arg1;
-(void)setSwipeEdge:(float)arg1;
@end

@interface Tab 
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
- (id)tabModel;
@end

%hook BrowserViewController
- (void)handleiPhoneSwipe:(SideSwipeGestureRecognizer *)fp8 { 
	//%log;
	if([fp8 state] == 3) { // 1 = Began, 2 = Changed, 3 = Ended
		// NSLog(@"direction = %d", fp8.direction);
		// NSLog(@"edge = %f",fp8.swipeEdge);
		Tab *curTab = [[self tabModel] currentTab];
		if(fp8.direction == 2) { // right
			if([curTab canGoForward]) {
				[curTab goForward];
			}
		} else if([curTab canGoBack]) {
			[curTab goBack];
		}	
	} 

	// direction = 1, edge = 20  => left
	//direction = 2, edge = 20 => right

}
- (void)handleiPadSwipe:(SideSwipeGestureRecognizer *)fp8 {
	//%log;
	if([fp8 state] == 3) { // 1 = Began, 2 = Changed, 3 = Ended
		// NSLog(@"direction = %d", fp8.direction);
		// NSLog(@"edge = %f",fp8.swipeEdge);
		Tab *curTab = [[self tabModel] currentTab];
		if(fp8.direction == 2) { // right
			if([curTab canGoForward]) {
				[curTab goForward];
			}
		} else if([curTab canGoBack]) {
			[curTab goBack];
		}	
	} 
}
%end