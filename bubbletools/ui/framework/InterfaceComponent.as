﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import bubbletools.ui.eventing.*;	import bubbletools.ui.interfaces.IComponent;	import bubbletools.ui.interfaces.IParameters;	import bubbletools.ui.interfaces.Reporter;	import bubbletools.ui.interfaces.UIControl;	import bubbletools.ui.parameters.*;	import bubbletools.util.MouseEventCapture;	import bubbletools.util.MouseInteractive;	import bubbletools.util.Pointdata;	import bubbletools.util.Debug;		import flash.display.Sprite;	import flash.events.MouseEvent;	import flash.geom.Rectangle;	public class InterfaceComponent extends MouseInteractive implements IComponent {				public static var DESCRIPTION:String = "Main Component class from which all other components are derived.";				public var traceEvents:Boolean = false;		public var parentComponent:InterfaceComponent;		public var globalParameters:IParameters;		public var subComponents:Array;				public var selectedComponent:InterfaceComponent;				public var isSelected:Boolean = false;		public var isVisible:Boolean = true;				private var respondsTo:Array;				public var displayExists:Boolean = false;				public var contentSize:Pointdata;				public var view:ComponentView;				public var componentType:String;				public var allowSubcomponents:Boolean;				public var mouseEvents:MouseEventCapture;		public var clickOffset:Pointdata;				public var initPosition:Pointdata;		// Stores original position		public var currentSize:Pointdata;		// Temp var for scaling				public function InterfaceComponent(parentComponent:InterfaceComponent) {			this.parentComponent = parentComponent;			contentSize = new Pointdata(0,0);			subComponents = new Array();			respondsTo = new Array();		}		public function createComponentView():void {										if(id == "User_Interface") {								view = new ComponentView(id);				Main.instance().addChild(view);						} else {								//Javascript.call("flashAlert", ["createComponentView for "+id]);				view = parentComponent.getView().addSubView(id);			}		}		public function checkId():void {			if(getParameters().getId() != null) {				id = getParameters().getId();			}		}		public function getStage():Sprite {			return (Main.instance());		}				//  =====================================================================================================		// Main		//				public function addComponent(componentType:String, componentParameters:InterfaceParameters):IComponent {						if (allowSubcomponents) {								// Assign id if supplied in skin, otherwise pass null to use auto-generated id								var suppliedId:String = null;								if(componentParameters.getId() != null) {					suppliedId = componentParameters.getId();				}								// Create the component and fetch the newly created component's id								var newComponentId:String = UI.createComponent(componentType, suppliedId, this);								// Set new components to initially hidden if their parent is hidden								if(!getParameters().getVisible()) {					UI.component(newComponentId).isVisible = false;				}								//  Set the parameters for the new component								UI.component(newComponentId).setParameters(componentParameters);								//  Store the id of the new component in this component's subcomponents list								subComponents.push(newComponentId);								calculateContentSize();								//	Return a reference to the new component								return getSub(subComponents.length - 1);						} else {								Debug.output(this, "Sub components not allowed in UI type : "+getType());				return (null);							}		}				public function getSub(index:Number) {			var cId:String = subComponents[index];			return UI.component(cId);		}				public function removeComponent():void {			// NOTE : Do not call this function while looping through a subcomponents array.			// This function leads to code which modifies that array and will cause skips in the loop.			var id:Number = getChildId();			getView().removeContainer();			if(!isNaN(id)) {				parentComponent.removeSubcomponent(id);			}		}				public function getChildId():Number {			var childId:Number;			for (var i:Number = 0; i<parentComponent.getComponents().length; i++) {				if (parentComponent.getSub(i) == this) {					childId = i;					break;				}			}			return(childId);		}		private function removeSubcomponent(id:Number):void {						// Gather subcomponents for removal						var removalsArray:Array = collectRemovals(id);						// Remove all nested subcomponents					for(var i:Number = 0; i<removalsArray.length; i++) {								UI.remove(removalsArray[i]);							}						// Remove this id from the subcomponent array						subComponents.splice(id, 1);			}				private function collectRemovals(id:Number):Array {						// Create name list of nested subcomponents to remove						var removals:Array = new Array();						removals.push(getSub(id).getId());								if(getSub(id).subComponents.length > 0) {				for(var i:Number = 0; i<getSub(id).subComponents.length; i++) {					removals = removals.concat(getSub(id).collectRemovals(i));				}			}						return(removals);					}				public function select():void {			isSelected = true;		}		public function deselect():void {			isSelected = false;		}				public function disableMouseEventsExcluding(exclusion:InterfaceComponent):void {			if(mouseEvents) {				handleMouseEvent("out");				mouseEvents.stopCapture();			}			if(subComponents.length > 0) {				for(var i:Number = 0; i<subComponents.length; i++) {					if(InterfaceComponent(getSub(i)) != exclusion) {						getSub(i).disableMouseEventsExcluding(exclusion);					}				}			}		}				public function disableMouseEvents():void {			if(mouseEvents) {				handleMouseEvent("out");				mouseEvents.stopCapture();			}			if(subComponents.length > 0) {				for(var i:Number = 0; i<subComponents.length; i++) {					getSub(i).disableMouseEvents();				}			}		}				public function resumeMouseEvents():void {			if(mouseEvents) {				mouseEvents.resumeCapture();			}			if(subComponents.length > 0) {				for(var i:Number = 0; i<subComponents.length; i++) {					getSub(i).resumeMouseEvents();				}			}		}				// fix		public function reset():void {			for(var i:Number = 0; i<subComponents.length; i++) {				if(getSub(i).subComponents.length > 0) {					getSub(i).reset();				}				getSub(i).getView().removeContainer();			}		}				//  =====================================================================================================		//	Reparenting		//				public function getParent():InterfaceComponent {			return parentComponent;		}				public function setParent(parentComponent:InterfaceComponent):void {			this.parentComponent = parentComponent;		}				public function reParent(newParent:InterfaceComponent):void {						var childId:Number;			for (var i:Number = 0; i<parentComponent.getComponents().length; i++) {				if (parentComponent.getSub(i) == this) {					childId = i;					break;				}			}						parentComponent.releaseComponent(newParent, childId);		}						public function releaseComponent(newParent:InterfaceComponent, childId:Number):void {						// create positioning offset			var positionOffset:Pointdata = getGlobalLocation(null);						// remove			var transferComponent:InterfaceComponent = getSub(childId);			subComponents.splice(childId, 1);						// remove view			view.removeView(transferComponent.getView());						// assign to the new parent			newParent.acceptComponent(transferComponent, positionOffset);		}				public function acceptComponent(transferComponent, positionOffset) {						// set the items parent to this component			transferComponent.setParent(this);			transferComponent.updatePosition(-getGlobalLocation(null).X+positionOffset.X, -getGlobalLocation(null).Y+positionOffset.Y);						// insert view			view.insertView(transferComponent.getView());						transferComponent.display();			subComponents.push(transferComponent.getId());		}				//  =====================================================================================================		//	Parameters		//				public function setParameters(globalParameters:IParameters):void {}				public function extendParameters():void {}					public function getContainedItems():Number {			var containedCount = 0;			for (var i:Number = 0; i<subComponents.length; i++) {				containedCount += getSub(i).getContainedItems();				containedCount++;			}			return containedCount;		}		public function setToTop():void {						var subviewCount:Number = parentComponent.getView().getSubview().numChildren;						//Debug.output(this, "Setting "+getId()+" to top of "+subviewCount+" items in "+parentComponent.getId());						parentComponent.getView().getSubview().setChildIndex(view, subviewCount-1);					}		public function setToBottom():void {						var subviewCount:Number = parentComponent.getView().getSubview().numChildren;						//Debug.output(this, "Setting "+getId()+" to top of "+subviewCount+" items in "+parentComponent.getId());						parentComponent.getView().getSubview().setChildIndex(view, 0);				}					//  =====================================================================================================		//  Interaction		//				public function startDragging() {			updateMouseState("drag");			var xOffset:Number = getParameters().getLocation().X-Main.instance().mouseX;			var yOffset:Number = getParameters().getLocation().Y-Main.instance().mouseY;			clickOffset = new Pointdata(xOffset, yOffset);		}				public override function isDragging(event:MouseEvent):void {			var updateLoc:Pointdata = new Pointdata( 		Main.instance().mouseX-getParameters().getLocation().X+clickOffset.X,															Main.instance().mouseY-getParameters().getLocation().Y+clickOffset.Y);																	if(!exceedsStage(updateLoc)) {													updatePosition(updateLoc.X, updateLoc.Y);			} else {				//			}		}				public function exceedsStage(updateLoc:Pointdata):Boolean {			var exceeds:Boolean = false;			var self:Rectangle = new Rectangle(	getParameters().getLocation().X+updateLoc.X, 												getParameters().getLocation().Y+updateLoc.Y, 												getParameters().getSize().X, 												getParameters().getSize().Y);															var stager:Rectangle = new Rectangle(0,0,Main._stage.stageWidth, Main._stage.stageHeight);						if(!(stager.containsRect(self))) {				exceeds = true;			}			return(exceeds);		}				public function stopDragging() {			updateMouseState("stopdrag");		}						//  =====================================================================================================		//  Display		//		//  Initial display =======================================================================================				public function displayComponents() {						for (var i:Number = 0; i<subComponents.length; i++) {								switch (getSub(i).getType()) {					case "ScrollBar" :						getSub(i).setToTop();						break;					case "TitleBar" :						getSub(i).setToTop();						break;				}								//  If the component is set as initially hidden, set all subcomponent InterfaceComponent isVisible value				//  to false for initial rendering.								if (!getParameters().getVisible() || !isVisible) {					getSub(i).isVisible = false;				}								getSub(i).display();							}		}				// Main render methods  =======================================================================================				public function update():void {			updateDraw();			updateDrawComponents();		}				public function updateDrawComponents():void {			for (var i:Number = 0; i<subComponents.length; i++) {				getSub(i).updateDraw();			}			for (var j:Number = 0;j<subComponents.length; j++) {				getSub(j).updateDrawComponents();			}			}				public function updateDraw():void {			view.setCoordinates(getParameters().getLocation());			}				public function getGlobalLocation(basePoint:Pointdata):Pointdata {			var loc:Pointdata;			if (basePoint == null) {				basePoint = getParameters().getLocation();			}			if (parentComponent == null) {				return basePoint;			} else {				loc = new Pointdata(	basePoint.X+parentComponent.getParameters().getLocation().X, 										basePoint.Y+parentComponent.getParameters().getLocation().Y);														return (parentComponent.getGlobalLocation(loc));			}		}		public function calculateContentSize():void {			var minX:Number = 0;			var minY:Number = 0;			var maxX:Number = 0;			var maxY:Number = 0;			for (var i:Number = 0; i<subComponents.length; i++) {				if (getSub(i) != null) {					if (!getSub(i).getParameters().getFixedPosition()) {												var componentParameters = getSub(i).getParameters();												if (componentParameters.getLocation().X < minX) {							minX = componentParameters.getLocation().X;						}						if (componentParameters.getLocation().Y < minY) {							minY = componentParameters.getLocation().Y;						}						if ((componentParameters.getLocation().X+componentParameters.getSize().X) > maxX) {							maxX = componentParameters.getLocation().X+componentParameters.getSize().X;						}						if ((componentParameters.getLocation().Y+componentParameters.getSize().Y) > maxY) {							maxY = componentParameters.getLocation().Y+componentParameters.getSize().Y;						}					}				} else {					Debug.output(this, "Error : Null component");				}			}			var sizeX = maxX-minX;			var sizeY = maxY-minY;			contentSize.X = sizeX;			contentSize.Y = sizeY;		}				public function getContentSize():Pointdata {			return contentSize;		}			// Color and Outline Color =======================================================================================				public function updateColor(c:uint):void {			getParameters().setColor(c);			view.changeColor(c);		}				public function updateOutlineColor(c:uint):void {			getParameters().setOutlineColor(c);			view.changeOutlineColor(c);		}				// Reszing and repositioning =======================================================================================				public function resize(W:Number,H:Number):void {			Debug.output(this, "W/H: " + W + "/" + H);			currentSize = new Pointdata(W,H);			getParameters().setScaledSize(new Pointdata(W,H));			view.scale(new Pointdata(W,H));					}				public function getCurrentSize():Pointdata {			var size:Pointdata;						if(currentSize) {				size = currentSize;			} else {				size = getParameters().getSize();			}						return(size);		}		public function position():Pointdata {			return(getParameters().getLocation());		}				public function setDefaultPosition(W:Number, H:Number):void {			initPosition = new Pointdata(W,H);		}		public function restoreSize():void {			resize(getParameters().getSize().X, getParameters().getSize().Y);		}		public function rebuild(p:IParameters):void {			view.removeContainer();			Debug.output(this, "REBUILD : "+getId()+" size="+p.getSize());			setParameters(p);			displayExists = false;			display();		}		public function setNewPosition(X:Number, Y:Number):void {			getParameters().getLocation().X = X;			getParameters().getLocation().Y = Y;			update();		}		public function restorePosition():void {			setNewPosition(initPosition.X, initPosition.Y);		}		public function updatePosition(X:Number, Y:Number):void {			getParameters().getLocation().X += X;			getParameters().getLocation().Y += Y;			update();		}				// Visibility =======================================================================================				public function hide():void {						// Tells the ComponentView to hide, and sets InterfaceParameters "visible" to false.			// Subcomponents will have their ComponentView hidden, but their parameters will not be altered.			// This allows us to hide, for example, a window and everything inside it, while preserving the			// internal state of the items inside the window for the next time we open it.						hideView();			isVisible = false;			getParameters().setVisible(false);						if(allowSubcomponents) {				hideComponents();			}		}		public function show():void {						// Tells the ComponentView to show, and sets InterfaceParameters "visible" to true.			// Subcomponents will have their ComponentView shown only if their InterfaceParameters "visble" is also true.			// This allows us to show a component with some items inside of it remaining hidden.						showView();			isVisible = true;			getParameters().setVisible(true);						if(allowSubcomponents) {				showComponents();			}		}		public function hideView():void {			view.hideView();		}		public function showView():void {			view.showView();		}		public function showComponents():void {			for (var i:Number = 0; i<subComponents.length; i++) {				if(getSub(i).getParameters().getVisible()) {					getSub(i).showView();				}			}		}		public function hideComponents():void {			for (var i:Number = 0; i<subComponents.length; i++) {				getSub(i).hideView();			}		}		//  DisplayObject management  =======================================================================================				public function getView():ComponentView {			return view;		}		public function display():void {						if(!displayExists) {								initPosition = new Pointdata(getParameters().getLocation().X, getParameters().getLocation().Y);				isVisible = getParameters().getVisible();								view.drawView(	getParameters().getLocation(),								getParameters().getSize(),								getParameters().getColor(),								getParameters().getBackgroundImage(),								getParameters().getVisible(),								getParameters().getBackgroundScaleType());				view.drawOutline(getParameters().getOutline(), getParameters().getSize(), getParameters().getOutlineColor());								mouseEvents = new MouseEventCapture(this);				mouseEvents.startCapture(view);								// Top level UI does not need hand cursor				/*				if(id == "User_Interface") {					view.useHandCursor = false;					view.buttonMode = false;				}				*/				if(getParameters().getUseTint()) {					view.applyGlobalTint();				}				if (getParameters().getDropShadow()) {					view.drawShadow();				}				displayExists = true;								displayComponent();							}						if(subComponents) {				if(subComponents.length > 0) {					displayComponents();				}			}								}						//  displayComponent() gets called after display(), and is intended for any component-custom display		//  routines, such as loading an image or drawing graphics.  Override this method to implement.				public function displayComponent():void {}				//  =====================================================================================================		//  Information		//				public function getType():String {			return componentType;		}		public override function getId():String {			return id;		}		public function setId(id):void {			this.id = id;		}		public function getComponents():Array {			return subComponents;		}		public function getParameters():InterfaceParameters {			return (InterfaceParameters(globalParameters));		}		public function containsMouse():Boolean {						var contains:Boolean = false;						var left:Number = getGlobalLocation(null).X;			var right:Number = getGlobalLocation(null).X+getParameters().getSize().X;			var top:Number = getGlobalLocation(null).Y;			var bottom:Number = getGlobalLocation(null).Y+getParameters().getSize().Y;						var x = Main.instance().mouseX;			var y = Main.instance().mouseY;						if((x>left) && (x<right) && (y>top) && (y<bottom)) {				contains = true;				// Debug.output(this, "[Contains Mouse] "+getId());			}						return(contains);					}				//  =====================================================================================================		//  External Events		//				//  A component may have external responses to multiple components and/or itself.		//  Each component this one is listening to gets an array of UIControl items to call.				public function addResponderTo(reporter:Reporter, interfaceResponse:UIControl):void {			if(respondsTo[reporter.getId()] == null) {				respondsTo[reporter.getId()] = new Array();			}			respondsTo[reporter.getId()].push(interfaceResponse);		}		public function hasResponderTo(reporter:InterfaceComponent):Boolean {			if (respondsTo[reporter.getId()] != null) {				return true;			} else {				return false;			}		}				//  =====================================================================================================		//  Internal Events		//				//  Creates an event based on a string ID and bubbles it up the heirarchy				public function bubbleEvent(eventType:String):void {			sendReport(UIEventManager.instance().createUIEvent(id, componentType, eventType));		}				//  Sends a report to the parent component and to any responders this component has to itself				public function sendReport(interfaceEvent:UIEvent):void {						parentComponent.registerReport(this, interfaceEvent);			registerExternal(this, interfaceEvent);		}				//  This is the "standard" implementation of [registerReport].		//  It handles events sent from the basic subcomponents in a traditional GUI manner.		//		//  For example, mouse events on a textfield within a button, are sent up to the button		//  to handle, as if those events occured on the button itself.		//		//  If you are using a custom component to listen to events, override this method within		//  that component to design custom behavior.		//		//  [registerInternal] is defined in extension methods which require local state variables		//  without having to override the default behavior.		//		//  [registerExternal] sends events to any Application responders to this UI component.		//				public function registerInternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void{}				public function registerExternal(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {			if (hasResponderTo(reporter)) {				for(var r:Number = 0; r<respondsTo[reporter.getId()].length; r++) {					respondsTo[reporter.getId()][r].interfaceCall(Reporter(reporter).makeEvent(interfaceEvent.info.eventType));					if(traceEvents) {						Debug.output(this, "[InterfaceCall] --> "+respondsTo[reporter.getId()][r]+" "+reporter.getId()+" "+interfaceEvent.info.eventType);					}				}			} 		}				public function registerReport(reporter:InterfaceComponent, interfaceEvent:UIEvent):void {						//if(this.id == "window") {			if(traceEvents) {				Debug.output(this, "[UI EVENT] Component '"+this.id+"' Registering event from "+reporter.getId());				Debug.output(this, "  --> Event from : "+interfaceEvent.info.componentType);				Debug.output(this, "  --> Event : "+interfaceEvent.info.eventType);			}						// Handle event reports based on reporter type						switch (interfaceEvent.info.componentType) {				case "Window" :					if(WindowParameters(InterfaceWindow(reporter).getParameters()).getStack()) {						switch(interfaceEvent.info.eventType) {							case UIEventType.WINDOW_PRESS :								reporter.setToTop();								break;							default :								break;						}					}					break;				case "Icon" :					if (interfaceEvent.info.eventType == UIEventType.ICON_CLICK) {						reporter.setToTop();						break;					} else if (interfaceEvent.info.eventType == UIEventType.ICON_DROP) {						reporter.setToBottom();						//bubbleEvent(UIEventType.WINDOW_DROPPED_ON);						break;					} else {						break;					}					break;				default :					// Debug.output(this, "  --> No default action specified for events from this component.");					break;			}						// Handle external events by the event type						registerExternal(reporter, interfaceEvent);						// Run any component-specific additions to event reporting						registerInternal(reporter, interfaceEvent);				}			}}