#NoEnv  ;recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance
#InstallKeybdHook
#InstallMouseHook
#UseHook


SendMode Input  ;recommended for new scripts due to its superior speed and reliability.
SetFormat Float, 0.8  ;increase precision from default 6 decimal points
CoordMode, Mouse, Screen ;make MouseMove exact not only when on desktop
;SetWorkingDir %A_ScriptDir%


; ///////////////////////////////////////////////////////////////////////////
;   _____             __ _                       _   _
;  / ____|           / _(_)                     | | (_)
; | |     ___  _ __ | |_ _  __ _ _   _ _ __ __ _| |_ _  ___  _ __
; | |    / _ \| '_ \|  _| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \
; | |___| (_) | | | | | | | (_| | |_| | | | (_| | |_| | (_) | | | \
;  \_____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
;                           __/ |
;                          |___/

StrafeKey = 1 ;usually one of 1 2 3 4 LButton RButton
EvasFireKey = RButton
StopMacroTriggerKey = LButton
EvasFireDelay := 570
EvasFireShots := 3

; ///////////////////////////////////////////////////////////////////////////


Center := {}
Center.X := A_ScreenWidth/2
Center.Y := A_ScreenHeight /2  * 0.935185 ;don't use the exact half because char stands slightly above that
Pi := 3.14159265358979323846
IsRequestedStop := 0
IsHeldStrafeKey := 0


#IfWinActive, Diablo III


Hotkey, $%StrafeKey%, StrafeLabel
Hotkey, ~%StopMacroTriggerKey%, StopLabel
Hotkey, ~$%EvasFireKey%, EvasiveFireLabel
return


; --== Suspend ==--
~Insert::Suspend
  KeyWait, Insert
  GetKeyState, InsertState, Insert, T
  if InsertState = D
  {
      Suspend, Off
  }
  else
  {
      Suspend, On
  }

  return
; --== ==--


; --== Stop ==--
StrafeLabel:
  if IsHeldStrafeKey
  {
    Send {%StrafeKey% up}
  }
  else
  {
    Send {%StrafeKey% down}
  }
  
  IsHeldStrafeKey := !IsHeldStrafeKey
  
  return
; --== ==--


; --== Stop ==--
StopLabel:
  IsRequestedStop := 1
  return
; --== ==--


; --== Evasive Fire ==--
EvasiveFireLabel:  
  MouseGetPos, xPos, yPos

  pEnemyDirection := {}
  pEnemyDirection.X := xPos
  pEnemyDirection.Y := yPos  

  ; Withdraw:
  withdrawPos := rotate(Center, pEnemyDirection, Pi) ;rotate by 180 degrees
  withdrawPos := changeRadius(Center, withdrawPos, 20) ;don't apply a 180 rotation but set withdrawPos closer to the Center
  MouseMove, withdrawPos.X, withdrawPos.Y

  IsRequestedStop := 0
  loopsLeft := EvasFireShots
  Loop
  {
    loopsLeft -= 1
    if (loopsLeft < 1)
    {
      break
    }

    Sleep, EvasFireDelay

    if (IsRequestedStop or !IsHeldStrafeKey)
    {
      break
    }

    MouseGetPos, xPos, yPos

    pPlayerCursor := {}
    pPlayerCursor.X := xPos
    pPlayerCursor.Y := yPos
   
    MouseMove, pEnemyDirection.X, pEnemyDirection.Y    
    Send {%EvasFireKey%}   

    MouseMove, pPlayerCursor.X, pPlayerCursor.Y
  }

  return
; --== ==--


aTan2(x, y)
{
  return dllcall("msvcrt\atan2","Double",x, "Double",y, "CDECL Double")
}


calculateAngle(p0, p1)
{
  xDelta := p1.X - p0.X
  yDelta := (p1.Y - p0.Y) * -1

  return aTan2(yDelta, xDelta)
}

rotate(p0, p1, angleOffset)
{
  xDelta := abs(p0.X - p1.X)
  yDelta := abs(p0.Y - p1.Y)

  radius := sqrt(xDelta * xDelta + yDelta * yDelta)

  p1Angle := calculateAngle(p0, p1)
  p1NewAngle := p1Angle + angleOffset

  newX := radius * Cos(p1NewAngle) + p0.X
  newY := radius * Sin(p1NewAngle) + p0.Y
  newY := newY + (p0.Y - newY) * 2

  return {X: newX, Y: newY}
}


changeRadius(p0, p1, radius)
{
  angle := calculateAngle(p0, p1)

  newX := p0.X + radius * Cos(angle)
  newY := p0.Y - radius * Sin(angle)

  return {X: newX, Y: newY}
}
