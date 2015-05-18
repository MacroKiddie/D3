
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetFormat Float, 0.8	;increase precision from default 6 decimal points

#SingleInstance
#InstallKeybdHook
#InstallMouseHook
#UseHook

CoordMode, Mouse, Screen ;without this MouseMove will be exact only on desktop


evasFireDelay := 570
evasFireShots := 3

center := {}
center.X := A_ScreenWidth/2
center.Y := A_ScreenHeight /2  * 0.935185 ; don't use the exact half because char stands slightly above that
pi := 3.14159265358979323846
gActivateScript = 0
lMouseClicked = 0


  #IfWinActive, Diablo III
   
   ~LButton::
     lMouseClicked := 1
   
     return
   
	a::	  
	
	  if gActivateScript = 0
      {
		return
      }
	  else {
	    
	  }
	  
	  MouseClick, Right,,,,0, 
	
	  MouseGetPos, xpos, ypos	
      
	  pEnemyDirection := {}
	  pEnemyDirection.X := xpos
	  pEnemyDirection.Y := ypos
	  
	  
	  p1 := {}
	  p1.X := xpos
	  p1.Y := ypos
	  
	  newPos := Rotate(center, p1, pi) ;rotate by 180 degrees
	  
	  ; don't apply a 180 rotation but set newPos closer to the center:	  
	  newPos := ChangeRadius(center, newPos, 20)
	  
	  MouseMove, newPos.X, newPos.Y, 100
	  
	  loopsLeft := evasFireShots
	  
	  lMouseClicked := 0
	  Loop
	  {  
	    loopsLeft -= 1
		 if (loopsLeft < 1) {		  
		   break
		 }
		 
		 
		   
	  
		Sleep, evasFireDelay
		
		
		If lMouseClicked = 1
		{	
		   break
		}
		
		MouseGetPos, xpos, ypos
	  
		  pPlayerCursor := {}
		  pPlayerCursor.X := xpos
		  pPlayerCursor.Y := ypos	  
		  
		  MouseMove, pEnemyDirection.X, pEnemyDirection.Y, 100
		  
		  MouseClick, Right,pEnemyDirection.X,pEnemyDirection.Y, , 0, 
		  
		  ;ClickRight()
		  
		  MouseMove, pPlayerCursor.X, pPlayerCursor.Y, 100
	  }
	  
	  
	  
      
      
      Return
	  
	  
	  
~Insert::
KeyWait, Insert
GetKeyState, InsertState, Insert, T
If InsertState = D
{
    gActivateScript = 1

}
else
{
    gActivateScript = 0

}
return
	  
	  
	  
ClickRight() {
	;MsgBox % "click"
  ;MouseClick, right,,, 1, 0, D
  Sleep, 35
  ;MouseClick, right,,, 1, 0, U
}
	  

ATan2(x, y) { 
	Return dllcall("msvcrt\atan2","Double",x, "Double",y, "CDECL Double")
}

LogB(x, base) {
    if (x < 0) {
	  Return log(x * -1) / log(base)
	}
	Return log(x) / log(base)
}


 
 
CalculateAngle(p0, p1) { 
	xDelta := p1.X - p0.X
    yDelta := p1.Y - p0.Y	
	yDelta := yDelta * -1	
	
	angleInDegrees := ATan2(yDelta, xDelta)  

    return angleInDegrees   ; 
}

Rotate(p0, p1, angleOffset)
{
    xDelta := abs(p0.X - p1.X)
	yDelta := abs(p0.Y - p1.Y)
	
	;MsgBox % "out: " . Sqrt(960 * 960 + 500 * 500) 
	radius := Sqrt(xDelta * xDelta + yDelta * yDelta)

	p1Angle := CalculateAngle(p0, p1)
	p1NewAngle := p1Angle + angleOffset
	

	newX := radius * Cos(p1NewAngle) + p0.X
	newY := radius * Sin(p1NewAngle) + p0.Y
	
	newY := newY + (p0.Y - newY) * 2

	return {X: newX, Y: newY}
}

ChangeRadius(p0, p1, radius)
{
	angle := CalculateAngle(p0, p1)

	newX := p0.X + radius * Cos(angle)
	newY := p0.Y - radius * Sin(angle)

	return {X: newX, Y: newY}
}



