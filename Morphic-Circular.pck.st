'From Cuis 5.0 [latest update: #4895] on 3 October 2021 at 4:59:49 pm'!
'Description '!
!provides: 'Morphic-Circular' 1 34!
!requires: 'VectorGraphics' 1 183 nil!
!requires: 'Collections-CompactArrays' 1 13 nil!
SystemOrganization addCategory: 'Morphic-Circular'!


!classDefinition: #ChevronMorph category: 'Morphic-Circular'!
MovableMorph subclass: #ChevronMorph
	instanceVariableNames: 'isPressed mouseIsOver color icon model aperture innerRadius radius center vertices actionSelector stateSelector argument'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'ChevronMorph class' category: 'Morphic-Circular'!
ChevronMorph class
	instanceVariableNames: ''!

!classDefinition: #DropDownChevronMorph category: 'Morphic-Circular'!
ChevronMorph subclass: #DropDownChevronMorph
	instanceVariableNames: 'activated chevron toolbar height gap'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'DropDownChevronMorph class' category: 'Morphic-Circular'!
DropDownChevronMorph class
	instanceVariableNames: ''!

!classDefinition: #CircularToolbarMorph category: 'Morphic-Circular'!
MovableMorph subclass: #CircularToolbarMorph
	instanceVariableNames: 'buttonSize aperture innerRadius dropDownHeight dropDownGap extent color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'CircularToolbarMorph class' category: 'Morphic-Circular'!
CircularToolbarMorph class
	instanceVariableNames: ''!

!classDefinition: #CircularSubToolbarMorph category: 'Morphic-Circular'!
CircularToolbarMorph subclass: #CircularSubToolbarMorph
	instanceVariableNames: 'dropDown'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Morphic-Circular'!
!classDefinition: 'CircularSubToolbarMorph class' category: 'Morphic-Circular'!
CircularSubToolbarMorph class
	instanceVariableNames: ''!


!ChevronMorph commentStamp: '<historical>' prior: 0!
I am a button for a circular morph. I look like a truncated section of a circle, I am nammed chevron as a shorter name.
I  am inserted in a cicular toolbar of the given radius.

- model I request action or state to
- actionSelector message to the model for action
- stateSelector message to the model for state
- argument optional argument for the model state

- aperture is the angle (radian) between the two straight lines of the chevron
- shift is the rotation angle (radian) of the chevron starting from the vertical centered position. With shift == 0, the chevron is centered at the top of the circular toolbar. The angle is clock-wise oriented. A shift value of pi/2 put the chevron at the right of the circular toolbar.
- corners: points 1 to 4 are the four corners of the chevron. The points 5, 6 and 7 are computed to ensure a better bounding box. The point 8 contains the decoration center if any.
- center: center of the shape in local coordinates for positionning, ie icon, owner position!

!DropDownChevronMorph commentStamp: '<historical>' prior: 0!
I am a small drop down chevron. The user clicks me to open a sub toolbar.
- activated: true when I have been clicked, those a sub circular toolbar should show up
- chevron: the chevron I am positionned close to
- height: drop down chevron height
- gap: the gap between my chevron and me!

!CircularToolbarMorph commentStamp: '<historical>' prior: 0!
- buttonSize: computed extent from the icon size (square)
- aperture: the chevron angle as seen from the toolbar center
- innerRadisu: interior size of the toolbar
- subToolbar: is it a toolbar open from a drop down chevron
- shift: shifted angle for the first button in the toolbar (0 top center, pi/2, right center)
- extent: an integer representing the extent of our encompassing square. This square encompasses the inner circle, the chevrons and the drop drown chevrons

I am circular toolbar. I can be a subToolbar too, then I render and behave a bit differently.

| tools |
Feature require: 'VectorGraphics'.
tools := CircularToolbarMorph new buttonSize: 20; extent: 150.
tools color: (Color orange alpha: 0.8);
	addButton: Theme current newIcon;
	addButton: Theme current openIcon;
	addButton: Theme current saveIcon;
	addButton: Theme current copyIcon ;
	addButton: Theme current pasteIcon ;
	addButton: Theme current undoIcon;
	addButton: Theme current redoIcon ;
	addButton: Theme current closeIcon ;
	addButton: Theme current quitIcon.
tools openInWorld.!

!CircularSubToolbarMorph commentStamp: 'hlsf 1/7/2021 21:35:33' prior: 0!
I am circular sub-toolbar. I am trigerred from a drop down chevron attached to a parent circular toolbar (the main one)
- dropDown : the drop down chevron I was opened from

| tools icons someIcons |
Feature require: 'VectorGraphics'.
tools := CircularToolbarMorph new buttonSize: 30; dropDownHeight: 10; dropDownGap: 3.
tools color: (Color orange alpha: 0.8).
someIcons := {Theme current newIcon. Theme current openIcon .Theme current saveIcon. Theme current copyIcon.}.
icons := {Theme current newIcon. Theme current openIcon .Theme current saveIcon. Theme current copyIcon. Theme current pasteIcon. Theme current undoIcon. Theme current redoIcon. Theme current closeIcon. Theme current quitIcon}.
icons do: [:icon | | button drop |
	drop := (button := tools addButton: icon) addDropDown.
	button setBalloonText: 'test'.
	someIcons do: [: icn | (drop toolbar addButton: icn) setBalloonText: 'I''am a button in a circular sub toolbar']
	].
tools openInWorld.!

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 9/29/2021 16:36:22'!
drawMyShapeOn: canvas with: background
	canvas strokeWidth: 2 color: color muchDarker fillColor: background  do: [: engine |
		engine moveTo: (self vertices floatAt: 1) @ (vertices floatAt: 2);
	 		lineTo: (vertices floatAt: 3) @ (vertices floatAt: 4);
			arcTo: (vertices floatAt: 5) @ (vertices floatAt: 6) 
				radius: radius  angleOfXAxis: aperture largeFlag: false sweepFlag: false;
			lineTo: (vertices floatAt: 7) @ (vertices floatAt: 8);
			arcTo: (vertices floatAt: 1) @ (vertices floatAt: 2) 
				radius: innerRadius angleOfXAxis: aperture largeFlag: false sweepFlag: true]! !

!ChevronMorph methodsFor: 'drawing' stamp: 'hlsf 10/3/2021 16:18:36'!
drawOn: canvas
	mouseIsOver | self getState 
		ifTrue:  [self drawMyShapeOn: canvas with: (Color white alpha: color alpha)]
		ifFalse: [self drawMyShapeOn: canvas with: color].
	icon ifNotNil: [canvas imageUnrotated: icon at: self center - (icon extent // 2)]! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/1/2021 11:21:03'!
action: aSymbol
	actionSelector _ aSymbol ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/3/2021 16:20:02'!
argument: aSymbol
	argument _ aSymbol ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/1/2021 10:11:14'!
color: aColor
	color _ aColor! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 12/31/2020 12:59:19'!
dropDown
"Do I have any associated drop down chevron?"
	^ owner ifNotNil: [
		owner submorphs 
			detect: [:morph | morph isDropDownChevron and: [morph chevron == self]]
			ifNone: [nil]]! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/3/2021 16:52:43'!
getState
	^ stateSelector 
		ifNil: [false]
		ifNotNil: [
			model perform: stateSelector withPossiblyWrongSizedArguments: {argument}]! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/1/2021 10:14:39'!
icon: aForm
	icon _ aForm ! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/3/2021 16:02:26'!
model: anObject
	model ifNotNil: [model removeDependent: self].
	anObject ifNotNil: [anObject addDependent: self].
	model _ anObject! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:16:36'!
radius: number
	radius _ number! !

!ChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/3/2021 16:08:31'!
state: aSymbol
	stateSelector _ aSymbol ! !

!ChevronMorph methodsFor: 'initialization' stamp: 'hlsf 1/7/2021 21:31:44'!
addDropDown
"Decorate me with a drop down chevron"
| newDropDown |
	newDropDown _ DropDownChevronMorph
		aperture: aperture 
		shift: self rotation 
		radius: radius + owner dropDownGap + owner dropDownHeight 
		innerRadius: radius + owner dropDownGap. 
	newDropDown color: color; 		chevron: self.
	self owner addMorphBack: newDropDown.
	^ newDropDown 
	! !

!ChevronMorph methodsFor: 'initialization' stamp: 'hlsf 1/7/2021 21:31:53'!
aperture: float1 shift: float2 radius: integer1 innerRadius: integer2 
	vertices _ center _ nil.
	aperture _ float1.
	radius _ integer1.
	innerRadius _ integer2.
	self rotation: float2.
	self dropDown ifNotNil: [:dropDown | 
		dropDown 
			aperture: float1 
			shift: float2 
			radius: radius + owner dropDownGap + owner dropDownHeight 
			innerRadius: radius + owner dropDownGap ]! !

!ChevronMorph methodsFor: 'initialization' stamp: 'hlsf 10/3/2021 15:47:58'!
initialize
	super initialize.
	mouseIsOver _ isPressed _ false.
	" Handle mouse down events "
	self setProperty: #handlesMouseDown toValue: true.
	self setProperty: #'mouseButton1Down:localPosition:'  toValue: [:event :localPosition |
		isPressed _ true.
		self redrawNeeded].
	self setProperty: #mouseButton1Up:localPosition:  toValue: [:event :localPosition |
		isPressed _ false.
		(self coversPixel: event eventPosition) ifTrue: [self performAction].
		self redrawNeeded ].
	" Handle mouse over event "	
	self setProperty: #handlesMouseOver: toValue: true.
	self setProperty: #mouseEnter: toValue: [:event |
		mouseIsOver _ true.
		self redrawNeeded].
	self setProperty: #mouseLeave:  toValue: [:event |
		mouseIsOver _ false.
		self redrawNeeded]! !

!ChevronMorph methodsFor: 'geometry' stamp: 'hlsf 1/3/2021 13:00:29'!
center
"Position to center an icon"
	^ center ifNil: [ 
		center _ Point rho: radius + innerRadius // 2 theta: Float halfPi negated]! !

!ChevronMorph methodsFor: 'geometry' stamp: 'hlsf 1/3/2021 13:11:02'!
vertices
	| angle |
	"Vertices are computed relatatively to the center of the circular toolbar (0;0). 
	The default oriention, when not rotated, is centered at the top"
	vertices ifNotNil: [^ vertices ].
	vertices _ Float32PointArray new: 4.
	angle _ Float halfPi negated + (aperture / 2). "(oy) reversed direction"
	vertices
		at: 1 put: (Point rho: innerRadius theta: angle) ;
		at: 2 put: (Point rho: radius theta: angle) .
	angle _ angle - aperture. "(oy) reversed direction"
	vertices
		at: 3 put: (Point rho: radius theta: angle);
		at: 4 put: (Point rho: innerRadius theta: angle).
	^ vertices
	! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:32:45'!
isChevron
	^ true! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:32:57'!
isDropDownChevron
	^ false! !

!ChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/15/2020 21:50:36'!
isOnSubToolbar
	^ owner isSubToolbar ! !

!ChevronMorph methodsFor: 'action' stamp: 'hlsf 10/3/2021 16:22:01'!
performAction
	"Am I a chevron on sub toolbar? 
	If so I become the chevron my sub toolbar was attached too"
	actionSelector ifNotNil: [
		model perform: actionSelector].
	self isOnSubToolbar ifTrue: [ | target |
		"Not a complete replacement, so do it by hand"
		target _ owner dropDown chevron.
		target icon: icon;
			model: model;
			action: actionSelector;
			state: stateSelector;
			argument: argument .
		self valueOfProperty: #balloonText ifPresentDo: [:txt | target setBalloonText: txt].
		owner owner redrawNeeded.
		"Simulate a clic on the drop down so I close the subtoolbar"
		owner dropDown closeSubToolbar ].! !

!ChevronMorph class methodsFor: 'instance creation' stamp: 'hlsf 1/3/2021 16:50:11'!
aperture: float1 shift: float2 radius: integer1 innerRadius: integer2 
	^ self new 
		aperture: float1 shift: float2 radius: integer1 innerRadius: integer2;
		yourself
! !

!ChevronMorph class methodsFor: 'new-morph participation' stamp: 'hlsf 1/10/2021 09:55:42'!
includeInNewMorphMenu
	^ false! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:55:38'!
chevron
	^ chevron! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:55:49'!
chevron: aChevron
	chevron _ aChevron ! !

!DropDownChevronMorph methodsFor: 'accessing' stamp: 'hlsf 10/2/2021 11:38:19'!
toolbar
	^ toolbar ifNil: [
		toolbar _ CircularSubToolbarMorph new
			color: owner color muchLighter;
			dropDown: self;
			extent: (owner extent / 2 + owner buttonSize + (owner dropDownGap * 2) + owner dropDownHeight) * 2;
			rotation: self rotation;
			privateButtonSize: owner buttonSize.
		toolbar ]! !

!DropDownChevronMorph methodsFor: 'action' stamp: 'hlsf 10/1/2021 11:17:29'!
performAction
	activated
		ifTrue: [ self closeSubToolbar ]
		ifFalse: [ self openSubToolbar ].! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 9/29/2021 16:37:47'!
drawMyShapeOn: canvas with: background
	canvas strokeWidth: 2 color: color muchDarker fillColor: background  do: [: engine |
		engine moveTo: (self vertices floatAt: 1) @ (vertices floatAt: 2);
			arcTo: (vertices floatAt: 3) @ (vertices floatAt: 4) 
				radius: innerRadius angleOfXAxis: aperture largeFlag: false sweepFlag: true;
			lineTo: (vertices floatAt: 5) @ (vertices floatAt: 6);
			lineTo: (vertices floatAt: 1) @ (vertices floatAt: 2)]	! !

!DropDownChevronMorph methodsFor: 'drawing' stamp: 'hlsf 1/3/2021 12:56:08'!
drawOn: canvas
	activated 
		ifTrue: [self drawMyShapeOn: canvas with: (Color white alpha: color alpha)]
		ifFalse: [super drawOn: canvas]! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 1/3/2021 13:11:42'!
closeSubToolbar
	self toolbar delete.
	activated _ false! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 1/3/2021 17:17:27'!
dropDownClicked
	activated
		ifTrue: [ self closeSubToolbar ]
		ifFalse: [ self openSubToolbar ].! !

!DropDownChevronMorph methodsFor: 'events' stamp: 'hlsf 1/3/2021 16:06:45'!
openSubToolbar
	owner closeAllSubToolbars.
	owner addMorphBack: self toolbar.
	activated _ true.! !

!DropDownChevronMorph methodsFor: 'geometry' stamp: 'hlsf 1/4/2021 11:46:00'!
center
	self shouldNotHappen ! !

!DropDownChevronMorph methodsFor: 'geometry' stamp: 'hlsf 1/3/2021 13:22:10'!
vertices
	| angle |
	vertices ifNotNil: [^ vertices].
	vertices _ Float32PointArray new: 3.
	angle _ Float halfPi negated.
	vertices at: 3 put: (Point rho: radius theta: angle).
	angle _ angle + (aperture / 2).
	vertices at: 2 put: (Point rho: innerRadius theta: angle).
	angle _ angle - aperture.
	vertices at: 1 put: (Point rho: innerRadius theta: angle).
	^ vertices! !

!DropDownChevronMorph methodsFor: 'initialization' stamp: 'hlsf 10/1/2021 10:28:12'!
initialize
	super initialize.
	activated _ false.
	self model: self! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 14:58:03'!
isActivated
	^ activated ! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:33:06'!
isChevron
	^ false! !

!DropDownChevronMorph methodsFor: 'testing' stamp: 'hlsf 6/7/2020 13:33:14'!
isDropDownChevron
	^ true! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 10/2/2021 10:33:46'!
addButton: icon
"To add a button to a circular toolbar takes some work, let the toolbar compute the math internally,
then return the button to adjust the model and action" 
	| button |
	button _ ChevronMorph 
		aperture: self aperture 
		shift: self chevronCount * (self aperture + self gap) 
		radius: extent // 2 
		innerRadius: self innerRadius.
	button color: color;
		icon: icon.
	self addMorphBack: button.
	^ button! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 5/26/2020 16:51:54'!
aperture
"a very clever computation..."
	^ aperture ifNil: [aperture _ ((buttonSize / 2.0) arcTan: self innerRadius) * 2]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 18:14:42'!
buttonSize
	^ buttonSize! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:03:40'!
buttonSize: integer
	buttonSize _ integer * 1.4. "We need some gap to fit in the icon on the chevron area"
 	aperture _ nil! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:39:59'!
chevronCount
	^ self chevrons size! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 13:36:42'!
chevrons
	^ self submorphsSatisfying: [:each | each isChevron]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 10/2/2021 11:37:33'!
color
	^ color! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 9/30/2021 17:52:10'!
color: aColor
	color _ aColor.
	self submorphsDo: [:each | each color: aColor]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/8/2020 19:27:09'!
dropDownChevronsDo: aBlock
	self submorphs 
		select: [:each | each isDropDownChevron ] 
		thenDo: [:aDropDownChevron | aBlock value: aDropDownChevron ]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:30:46'!
dropDownGap
	^ dropDownGap! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:31:00'!
dropDownGap: number
	dropDownGap _ number ! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:30:36'!
dropDownHeight
	^ dropDownHeight! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 1/7/2021 21:31:12'!
dropDownHeight: number
	dropDownHeight _ number ! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 9/30/2021 17:58:33'!
extent
	^extent! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 9/30/2021 17:51:53'!
extent: aSmallInteger 
	extent _ aSmallInteger! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 11:53:20'!
gap
"Angle gap between the chevron button"
	^ `5 degreesToRadians`! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 12/31/2020 16:42:11'!
innerRadius
	^ innerRadius ifNil: [innerRadius _ extent // 2 - buttonSize]! !

!CircularToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/7/2020 18:15:42'!
privateButtonSize: anInteger
	buttonSize _ anInteger! !

!CircularToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:53'!
isSubToolbar
	^ false! !

!CircularToolbarMorph methodsFor: 'drawing' stamp: 'hlsf 12/31/2020 18:48:34'!
drawOn: aCanvas
	aCanvas ellipseCenterX: 0 y: 0 rx: self innerRadius ry: self innerRadius 
		borderWidth: 0 borderColor: color  fillColor: (color muchLighter alpha: 0.5)! !

!CircularToolbarMorph methodsFor: 'initialization' stamp: 'hlsf 6/15/2020 22:24:14'!
closeAllSubToolbars
	self dropDownChevronsDo: [:dropDown | 
		dropDown isActivated ifTrue: [dropDown closeSubToolbar ]]! !

!CircularToolbarMorph methodsFor: 'initialization' stamp: 'hlsf 10/2/2021 12:15:16'!
initialize
	super initialize.
	extent _ 300.
	dropDownHeight _ 15.
	dropDownGap _ 5.
	self buttonSize: 30.
	color _ Color green darker alpha: 0.8! !

!CircularToolbarMorph methodsFor: 'initialization' stamp: 'hlsf 10/2/2021 12:16:46'!
openInWorld: aWorld
	super openInWorld: aWorld.
	self startStepping: #comeToFront stepTime: 10.! !

!CircularToolbarMorph methodsFor: 'change reporting' stamp: 'hlsf 1/4/2021 11:39:31'!
addedMorph: aMorph
	self redrawNeeded ! !

!CircularToolbarMorph class methodsFor: 'as yet unclassified' stamp: 'hlsf 9/30/2021 17:51:35'!
DoIt


| tools |
Feature require: 'VectorGraphics'.
tools := CircularToolbarMorph new buttonSize: 20; extent: 150.
tools color: (Color orange alpha: 0.8);
	addButton: Theme current newIcon;
	addButton: Theme current openIcon;
	addButton: Theme current saveIcon;
	addButton: Theme current copyIcon ;
	addButton: Theme current pasteIcon ;
	addButton: Theme current undoIcon;
	addButton: Theme current redoIcon ;
	addButton: Theme current closeIcon ;
	addButton: Theme current quitIcon.
tools openInWorld.! !

!CircularToolbarMorph class methodsFor: 'as yet unclassified' stamp: 'hlsf 1/10/2021 09:55:33'!
includeInNewMorphMenu
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:31'!
isChevron
"sub toolbar are added too to toolbar so we need to sort out"
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:02:38'!
isDropDownChevron
"sub toolbar are added too to toolbar so we need to sort out"
	^ false! !

!CircularSubToolbarMorph methodsFor: 'testing' stamp: 'hlsf 6/12/2020 12:03:13'!
isSubToolbar
	^ true! !

!CircularSubToolbarMorph methodsFor: 'drawing' stamp: 'hlsf 6/12/2020 11:52:13'!
drawOn: aCanvas
"We don't draw anything, not inner central disc for circular sub toolbar"! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 12:10:11'!
dropDown
	^ dropDown! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 12:08:10'!
dropDown: aDropDownChevron
	dropDown _ aDropDownChevron ! !

!CircularSubToolbarMorph methodsFor: 'accessing' stamp: 'hlsf 6/12/2020 11:53:08'!
gap
	^ `1 degreesToRadians`! !
