﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.extensions.framework {		import flash.events.MouseEvent;	import flash.events.KeyboardEvent;	import flash.display.Sprite;		import bubbletools.util.Pointdata;	import bubbletools.ui.interfaces.Reporter;		import bubbletools.ui.interfaces.IParameters;	import bubbletools.ui.eventing.*	import bubbletools.ui.framework.*	import bubbletools.ui.parameters.*	import bubbletools.extensions.framework.*	import bubbletools.extensions.parameters.*;		import bubble3d.main.Bubble3D;	public class BTDisplay3D extends BTComponent implements Reporter {		private var parameters:Display3DParameters;		private var tmpSprite:Sprite;		private var view3D:Bubble3D;				public function BTDisplay3D(parentComponent:BTComponent) {			super(parentComponent);			componentType = "Display3D";			allowSubcomponents = false;		}				//  =====================================================================================================		//  Reporter Implementation		//		public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return(newEvent);		}				//  =====================================================================================================		//  Required Override Methods		//			public override function setParameters(newParameters:IParameters):void {						globalParameters = newParameters;			parameters = Display3DParameters(newParameters);						tmpSprite = new Sprite();			view3D = new Bubble3D(getParameters().getSize().X, getParameters().getSize().Y, tmpSprite);			view3D.addReadyListener(this);			Main._stage.addEventListener(KeyboardEvent.KEY_DOWN, view3D.captureKeyEvent);			view3D.model(parameters.getFile());				}				public override function displayComponent():void {			view.setContents(tmpSprite);			view3D.run();		}			public override function handleMouseEvent(clickType:String):void {			switch (clickType) {			case "press" :				bubbleEvent(UIEventType.WINDOW_PRESS);				if (getParameters().getDraggable()) {					//startDragging();				}				break;			case "release" :				bubbleEvent(UIEventType.WINDOW_RELEASE);				if (getParameters().getDraggable()) {					stopDragging();				}				break;			case "release_outside" :				if (getParameters().getDraggable()) {					stopDragging();				}				break;			}		}				//  =====================================================================================================		//	Additional Overrides		//				public override function hideView():void{			view3D.engineOff();			view.hideView();					}		public override function showView():void {			view3D.engineOn();			view.showView();		}				//  =====================================================================================================		//  Custom Methods		//				public function update3D(file:String):void {			restart();			parameters.setFile(file);			view3D.model(parameters.getFile());			view3D.run();			view3D.engineOn();		}		public function add3D(file:String):void {					}		public function modelName():String {			return(view3D.lastModel());		}		public function restart():void {			view3D.reset();		}		public function reload():void {			view3D.reloadCurrentModels();		}		public function view3dReady():void {			bubbleEvent(UIEventType.READY_3D);		}	}}