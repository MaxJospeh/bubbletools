﻿package com.application {		import bubbletools.core.async.*;	import bubbletools.core.eventing.*;	import bubbletools.core.library.*;	import bubbletools.core.threading.*;		import bubbletools.ui.eventing.*;	import bubbletools.ui.framework.*;	import bubbletools.ui.interfaces.*;	import bubbletools.ui.main.*;	import bubbletools.ui.parameters.*;		import bubbletools.util.*;	// Make sure to import your control library here!		import com.control.*;		public class AppMainView extends View implements UIView {				public function AppMainView(uiml:String){			super(uiml);						// The super() call is required to register this class as the sole View instance			// Creating additional View instances is not needed nor supported.  The purpose of this			// class is to define the actions taken when the UIML is loaded.		}				//  =====================================================================================================		//  UIView implementation		//		//  NOTE : renderStarted(), renderAdditionalStarted(), and applicationComplete() are required, even if you do 		//  not define any actions in them.		//  =====================================================================================================				//  Basic method ----------------------------------------------------------------------------------------				//	======================================= applicationComplete ==========================================		//		//	This method is called after both of the following conditions are met : You have called		//  View.applicationReady() to inform it that your App is ready, and the static UIMLView class has finished		//  loading the UIML file.		//  		//  You should only call the View.applicationReady() method, in your main startup class, once your application		//  has all of its required content ready.		//  Then, when both are finsihed, applicationComplete() will be called automatically.		//  		//  This is an appropriate place to add the controls you want turned on for the UI.		//				public function applicationComplete():void {						//  Adding a control is simple, you specify a name for the control and an instance of a UIControl class.			//			//  For advanced purposes, you can use View.control(controlname) to access your control from other classes.			//  When calling View.control(controlname), you must cast it to the type you have created,i.e			//  var theControl:MyControlType = MyControlType(View.control(controlname));						controls.add("appMain", new AppMainControl());			// controls.add("appButtons", new AppButtonsControl());					}				//  Advanced methods -------------------------------------------------------------------------------------						//	========================================= renderStarted ==============================================		//			//	Called when the UI has completed loading its data files and is rendering.  This is a trivial event,		//  and will be called automatically.  If you have other loading going on in your main app class, you should		//  wait till that is complete and call View.applicationReady() before running any code.		//		//  renderStarted() is intended only for starting routines that do not care whether the application is ready.		//  		public function renderStarted():void {}						//	 ===================================== renderAdditionalStarted =========================================		//  		//  This is the callback from static UIMLView class when any additional UIML files have loaded via the static method :		//		//  UIMLView.loadAdditional(uiName:String, UIML:String, target:IComponent);		//		//  parameter : uiName - your own reference name		//  parameter :	UIML - the path to the xml file		//  parameter :	target - the component where the new UI will be loaded into.  If no component is set, UI.root()		//  will be used, which is the top level component.		//		//  NOTE : This is an advanced feature which only applies to large applications which load common UIML files.		//  UIMLView will only load 1 UIML file at a time, and lock out requests until that file is done, upon which		//  renderAdditionalStarted(uiName:String) will be notified.		//		// 	The string value <uiName> is used to reference the new UIML loaded, the value you passed earlier as uiName.		//  You may check at any time for additional UIML files you have loaded with UIMLView.exists(uiName):Boolean						public function renderAdditionalStarted(uiName:String):void {}				public function renderFailed(uiName:String):void {}    			}}