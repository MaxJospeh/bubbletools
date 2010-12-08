﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import flash.events.MouseEvent;	import flash.events.Event;	import flash.display.Sprite;	import bubbletools.util.Pointdata;	import bubbletools.ui.interfaces.Reporter;	import bubbletools.ui.interfaces.IParameters;	import bubbletools.ui.interfaces.IContainer;	import bubbletools.ui.eventing.*	import bubbletools.ui.framework.*	import bubbletools.ui.parameters.*	import bubbletools.util.Debug;	import bubbletools.core.eventing.EventType;	public class BTWindow extends BTComponent implements Reporter, IContainer {		private var parameters:WindowParameters;		private var contentOffset:Pointdata;		private var verticalScrollBar:BTScrollBar;		private var horizontalScrollBar:BTScrollBar;		private var v:ScrollBarParameters;		private var h:ScrollBarParameters;		private var titleBar:BTTitleBar;		private var titleBarOffset:Number = 0;		private var t:TitleBarParameters;		private var lastDropped:BTIcon;		public function BTWindow(parentComponent:BTComponent) {			super(parentComponent);			componentType = "Window";			handCursorMode = false;			allowSubcomponents = true;			contentOffset = new Pointdata(0, 0);		}		//  =====================================================================================================		//  Reporter Implementation		//		public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return (newEvent);		}		//  =====================================================================================================		//  Required Override Methods		//		public override function setParameters(newParameters:IParameters):void {			globalParameters = newParameters;			parameters = WindowParameters(newParameters);			checkId();			if (parameters.getTitleBar()) {				titleBarOffset = parameters.getTitleBarSize();			}			// Create Scroll Bars			if (parameters.getScrollVertical()) {				v = new ScrollBarParameters();				v.setId(getId() + "_scroll_vertical");				v.setControlDirection("vertical");				v.setScrollTarget(this);				v.setSize(new Pointdata(parameters.getScrollBarSize(), getParameters().getSize().Y - titleBarOffset));				v.setLocation(new Pointdata(getParameters().getSize().X - parameters.getScrollBarSize(), titleBarOffset));				v.setSliderSize(parameters.getScrollBarSliderSize());				v.setOutline(parameters.getScrollBarOutline());				v.setSliderOutline(parameters.getScrollBarSliderOutline());				if (parameters.getScrollBarImage() != null) {					v.setImage(parameters.getScrollBarImage());				}				if (parameters.getScrollBarSliderImage() != null) {					v.setSliderImage(parameters.getScrollBarSliderImage());				}				if (parameters.getScrollBarArrows()) {					v.setArrows(true);					v.setArrowsClustered(parameters.getScrollBarArrowsClustered());					v.setArrowMaxDefault(parameters.getScrollBarArrowMaxDefault());					v.setArrowMaxOver(parameters.getScrollBarArrowMaxOver());					v.setArrowMaxDown(parameters.getScrollBarArrowMaxDown());					v.setArrowMinDefault(parameters.getScrollBarArrowMinDefault());					v.setArrowMinOver(parameters.getScrollBarArrowMinOver());					v.setArrowMinDown(parameters.getScrollBarArrowMinDown());				}				verticalScrollBar = BTScrollBar(this.addComponent("ScrollBar", v));			}			if (parameters.getScrollHorizontal()) {				h = new ScrollBarParameters();				v.setId(getId() + "_scroll_horizontal");				h.setControlDirection("horizontal");				h.setScrollTarget(this);				h.setSize(new Pointdata(getParameters().getSize().X, parameters.getScrollBarSize()));				h.setLocation(new Pointdata(0, getParameters().getSize().Y - parameters.getScrollBarSize()));				h.setOutline(parameters.getScrollBarOutline());				h.setSliderOutline(parameters.getScrollBarSliderOutline());				if (parameters.getScrollBarArrows()) {					h.setArrows(true);					h.setArrowsClustered(parameters.getScrollBarArrowsClustered());					h.setArrowMaxDefault(parameters.getScrollBarArrowMaxDefault());					h.setArrowMaxOver(parameters.getScrollBarArrowMaxOver());					h.setArrowMaxDown(parameters.getScrollBarArrowMaxDown());					h.setArrowMinDefault(parameters.getScrollBarArrowMinDefault());					h.setArrowMinOver(parameters.getScrollBarArrowMinOver());					h.setArrowMinDown(parameters.getScrollBarArrowMinDown());				}				horizontalScrollBar = BTScrollBar(this.addComponent("ScrollBar", h));			}			// Create Title Bar			if (parameters.getTitleBar()) {				t = new TitleBarParameters();				t.setText(parameters.getTitleText());				t.setTextColor(parameters.getTitleTextColor());				t.setTitleTextFont(parameters.getTitleTextFont());				t.setTitleTextFontSize(parameters.getTitleTextFontSize());				// t.setTileBackground(true);				t.setSize(new Pointdata(getParameters().getSize().X, parameters.getTitleBarSize()));				t.setCloseButton(parameters.getCloseButton());				t.setCloseButtonImage(parameters.getCloseButtonImage());				t.setLocation(new Pointdata(0, 0));				t.setDraggable(getParameters().getDraggable());				t.setId(parameters.getId() + "_" + "title_bar");				t.setOutline(parameters.getOutline());				t.setOutlineColor(parameters.getOutlineColor());				if (parameters.getTitleBarBackground() != null) {					t.setImage(parameters.getTitleBarBackground());				}				titleBar = BTTitleBar(this.addComponent("TitleBar", t));			}		}		public override function registerInternal(reporter:BTComponent, interfaceEvent:UIEvent):void {			switch (interfaceEvent.info.eventType) {				case UIEventType.ICON_DROP:					Debug.output(this, "item dropped on a window");					lastDropped = BTIcon(reporter);					bubbleEvent(UIEventType.WINDOW_DROPPED_ON);					break;				case UIEventType.TEXT_PRESS:					bubbleEvent(UIEventType.WINDOW_PRESS);					break;				case UIEventType.TEXT_CHANGED:					BTWindow(this).windowContentsChanged();					break;				case UIEventType.CLOSE_BUTTON_RELEASE:					hide();					break;				default:					break;			}		}		public override function handleMouseEvent(clickType:String):void {			switch (clickType) {				case "press":					bubbleEvent(UIEventType.WINDOW_PRESS);					if (getParameters().getDraggable()) {						if (parameters.getDirectDrag()) {							// Make sure the window is allowed to be dragged from any handle							if (eligibleForDrag()) {								// Make sure we are not dragging an internal item first    								startDragging();							}						}					}					break;				case "release":					bubbleEvent(UIEventType.WINDOW_RELEASE);					if (getParameters().getDraggable()) {						stopDragging();					}					break;				case "release_outside":					if (getParameters().getDraggable()) {						stopDragging();					}					break;				case "over":					bubbleEvent(UIEventType.WINDOW_OVER);					break;				case "out":					bubbleEvent(UIEventType.WINDOW_OUT);					break;				case "move":					bubbleEvent(UIEventType.WINDOW_MOVE);					break;			}		}		//  =====================================================================================================		//  Custom Methods		//		public override function resize(W:Number, H:Number):void {			currentSize = new Pointdata(W, H);			getParameters().setScaledSize(new Pointdata(W, H));			view.scale(new Pointdata(W, H));			propagateResize(W, H);			if (parameters.getTitleBar()) {				titleBar.resize(W, parameters.getTitleBarSize());			}			if (parameters.getScrollVertical()) {				verticalScrollBar.setNewPosition(getParameters().getScaledSize().X - parameters.getScrollBarSize(), titleBarOffset);				verticalScrollBar.resize(parameters.getScrollBarSize(), getParameters().getScaledSize().Y - titleBarOffset);			}			if (parameters.getScrollHorizontal()) {				horizontalScrollBar.resize(getParameters().getSize().X, parameters.getScrollBarSize());			}		}		public function setContentOffset(contentOffset:Pointdata):void {			this.contentOffset = contentOffset;		}		public function getContentOffset():Pointdata {			return (contentOffset);		}		public function getLastDropped():BTIcon {			return lastDropped;		}		public function windowContentsChanged():void {			if (parameters.getScrollVertical()) {				verticalScrollBar.scrollTargetContents();			}		}		public function fadeWindowIn(seconds:Number):void {			if (seconds > 0) {				view.addEventListener(EventType.SPRITE_FADEIN_COMPLETE, fadeWindowInComplete);			}			view.fadeIn(seconds);		}		public function fadeWindowOut(seconds:Number):void {			if (seconds > 0) {				view.addEventListener(EventType.SPRITE_FADEOUT_COMPLETE, fadeWindowOutComplete);			}			view.fadeOut(seconds);		}		private function fadeWindowInComplete(e:Event):void {			bubbleEvent(UIEventType.WINDOW_FADEIN_COMPLETE);			view.removeEventListener(EventType.SPRITE_FADEIN_COMPLETE, fadeWindowInComplete);		}		private function fadeWindowOutComplete(e:Event):void {			bubbleEvent(UIEventType.WINDOW_FADEOUT_COMPLETE);			view.removeEventListener(EventType.SPRITE_FADEOUT_COMPLETE, fadeWindowOutComplete);		}	}}