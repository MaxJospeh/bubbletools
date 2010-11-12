﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import bubbletools.ui.eventing.*;	import bubbletools.ui.framework.*;	import bubbletools.ui.interfaces.Reporter;	import bubbletools.ui.parameters.*;	import bubbletools.util.Debug;	import bubbletools.util.MouseEventCapture;	import bubbletools.util.Pointdata;	import flash.display.Sprite;	import flash.events.TimerEvent;	import flash.utils.Timer;	public class BTVideoSeek extends BTSlideControl implements Reporter {		private var extendedParameters:VideoSeekParameters;		private var videoTimer:Timer;		private var video:BTVideoDisplay;		private var activated:Boolean = false;		private var enabledForContent:Boolean = true;		private var suspendedForUserInteraction:Boolean = false;		public function BTVideoSeek(parentComponent:BTComponent) {			super(parentComponent);			componentType = "VideoSeek";			allowSubcomponents = true;		}		//  =====================================================================================================		//  Reporter Implementation		//		public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return (newEvent);		}		//  =====================================================================================================		//  Required Override Methods		//		// Main parameterization handled in BTSlideControl which this class extends		public override function extendParameters():void {			extendedParameters = VideoSeekParameters(parameters);			video = extendedParameters.getVideoDisplay();		}		public override function registerInternal(reporter:BTComponent, interfaceEvent:UIEvent):void {			switch (interfaceEvent.info.componentType) {				case "Button":					switch (interfaceEvent.info.eventType) {						case UIEventType.BUTTON_PRESS:							Debug.output(this, "suspendTimer");							suspendedForUserInteraction = true;							suspendTimer();							break;						case UIEventType.BUTTON_RELEASE:							seekVideo();							suspendedForUserInteraction = false;							break;						default:							break;					}					break;				default:					break;			}		}		//  =====================================================================================================		//  Custom Methods		//		public override function controlEventInit():void {			Debug.output(this, "[VideoSeek] controlEventInit");			bubbleEvent(UIEventType.VIDEO_SEEK);			suspendTimer();		}		public override function controlEventComplete():void {			Debug.output(this, "[VideoSeek] controlEventComplete");			seekVideo();		}		public override function resize(W:Number, H:Number):void {			Debug.output(this, "[VideoSeek] resize");			currentSize = new Pointdata(W, H);			getParameters().setScaledSize(new Pointdata(W, H));			view.scale(new Pointdata(W, H));			if (parameters.getControlDirection() == "vertical") {				ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0, 0));				ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(0, getParameters().getScaledSize().Y - parameters.getSliderSize()));			} else if (parameters.getControlDirection() == "horizontal") {				ButtonParameters(controlSlider.getParameters()).setDragPointTopLeft(new Pointdata(0, 0));				ButtonParameters(controlSlider.getParameters()).setDragPointBottomRight(new Pointdata(getParameters().getScaledSize().X - parameters.getSliderSize(), 0));			}		}		public function resetSeekTimer():void {			rewind();			if (activated) {				videoTimer.removeEventListener("timer", updateSeekPosition);				videoTimer = null;				activated = false;			}		}		public function enable():void {			Debug.output(this, "enable called");			controlSlider.show();			if (activated == false) {				videoTimer = new Timer(100, 0);				videoTimer.addEventListener("timer", updateSeekPosition);				activated = true;			}			videoTimer.start();			if (enabledForContent) {				resumeMouseEvents();			}		}		public function enableForContent():void {			enabledForContent = true;		}		public function disableForContent():void {			enabledForContent = false;		}		public function suspendTimer():void {			if (videoTimer) {				Debug.output(this, "stopping video seek timer");				videoTimer.stop();			}		}		public function resumeTimer():void {			if (!suspendedForUserInteraction) {				Debug.output(this, "resumeTimer");				if (videoTimer != null) {					if (!videoTimer.running) {						Debug.output(this, "resuming timer");						videoTimer.start();					} else {						Debug.output(this, "[WARNING] attempted to restart seek timer but it was already running.");					}				} else {					Debug.output(this, "[WARNING] video timer was null");				}			} else {				Debug.output(this, "attempted to resume timer but user is still holding slider");			}		}		public function rewind():void {			setToRatio(0);			suspendTimer();			controlSlider.hide();			disableMouseEvents();			enableForContent();		}		public function updateSeekPosition(event:TimerEvent):void {			try {				var seekRatio:Number = video.currentTime() / video.totalTime();				setToRatio(seekRatio);			} catch (error:Error) {				Debug.output(this, "[WARNING] video time information was not available, stopping seek.");				videoTimer.stop();				controlSlider.hide();			}		}		public function seekVideo():void {			if (extendedParameters.getControlDirection() == "horizontal") {				controlRange = getParameters().getScaledSize().X - controlSlider.getParameters().getScaledSize().X;				controlCurrentPosition = controlSlider.getParameters().getLocation().X;				controlPercentage = controlCurrentPosition / controlRange;				Debug.output(this, "seek to % : " + Math.round(100 * controlPercentage));				var time:Number = controlPercentage * video.totalTime();				video.seek(time);			}		}	}}