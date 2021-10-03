# cuis-xp
Experimental bits on Cuis-Smalltalk

## What is this ?
* This is **DrGeo** package to be run into CuisSmalltalk.
* **DrGeo** that lets you do interactive 2D geometry with or without Smalltalk code.
* TODO, put 2 screen shots here, one 

## How do I run it ?
* This package can be loaded in the usual way you load a *Cuis* package, that is
 * You clone the repository into the directory containing *Cuis-Smalltalk-Dev*
 * You Run Cuis-Smalltalk
 * From Cuis Workspace you give these commands and you are ready to go
 ```smalltalk
"this imports DrGeo"
Feature require: 'DrGeo'. 
"???, i put it, i don't know why, Hilaire told me"
DrGeoSystem beDevelopment . 
"this starts a new sketch which is ready for interactions: code or point & click"
s _ DrGeoSketch new. 
 ```






