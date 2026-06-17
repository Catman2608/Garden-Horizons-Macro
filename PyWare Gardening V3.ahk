; ============================================================
; PyWare Gardening V3.0
; ============================================================
#SingleInstance Force
FileEncoding, UTF-8
setkeydelay, -1
setmousedelay, -1
setbatchlines, -1
SetTitleMatchMode 2

CoordMode, Tooltip, Relative
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

if (InStr(A_ScriptDir, ".zip\") || InStr(A_ScriptDir, ".rar\") || InStr(A_ScriptDir, ".7z\")) {
	MsgBox, 0x40030, Extract Files Required, You must extract the files from the ZIP archive first!`n`nThe macro cannot save settings while running from inside a ZIP file.`n`nPlease:`n1. Right-click the ZIP file`n2. Select "Extract All"`n3. Run the macro from the extracted folder
	ExitApp
}

FileAppend, , %A_ScriptDir%\test_write.tmp
if (ErrorLevel) {
	if (InStr(A_ScriptDir, "Downloads") && (InStr(A_ScriptDir, "Compressed") || InStr(A_ScriptDir, "Temp"))) {
		MsgBox, 0x40030, Extract Files Required, It appears you're running from a compressed/temporary folder.`n`nPlease extract all files to a regular folder (like Desktop or Documents) before running the macro.`n`nCurrent location: %A_ScriptDir%
		ExitApp
	} else {
		MsgBox, 0x40030, Permission Error, Cannot write to current directory: %A_ScriptDir%`n`nTry:`n1. Moving the files to Desktop or Documents`n2. Running as Administrator`n3. Extracting from ZIP if compressed
		ExitApp
	}
} else {
	FileDelete, %A_ScriptDir%\test_write.tmp
}
; === Initialize settings file path ===
settingsFile := "settings.ini"

; The GUI section below uses 0xRRGGBB instead of 0xBBGGRR unlike the other sections

Gui, +Resize +MinSize
Gui, Color, 0x1D1D1D
Gui, Font, s9 cFFFFFF, Segoe UI  ; Reduced from s9 to s9 for better sizing
Gui, Add, Tab2, w660 h630, Seeds|Gears|Event|Settings|About ; Discord Webhooks

; === Screen Coordinates ===
ClickX := A_ScreenWidth / 1920
ClickY := A_ScreenHeight / 1080
TooltipX := A_ScreenWidth * 0.15
Tooltip1 := A_ScreenHeight * 0.25

; === Item Arrays ===
seedItems := ["Carrot", "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple", "Bamboo", "Corn", "Cactus", "Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Mango", "Dragon Fruit", "Acorn", "Cherry", "Venus Flytrap", "Pomegranate", "Poison Apple", "Moon Bloom", "Dragon's Breath"]

gearItems := ["Water Bucket", "Frost Grenade", "Banana Gun", "Frost Blower", "Carrot Launcher"]

; === Buttons ===
Gui, Tab,
Gui, Font, s9 c0xff6b6b Bold
Gui, Add, GroupBox, x30 y560 w600 h60, Macro Stopped - Ready to Start
Gui, Font, s9 cWhite Norm, Segoe UI
Gui, Add, Button, x40 y580 w100 h30 gStartClicked, 🚀 Start
Gui, Add, Button, x160 y580 w100 h30 gSaveSettings, 💾 Save
Gui, Add, Button, x280 y580 w100 h30 gLoadSettings, 📂 Load
Gui, Add, Text, x600 y600 , V1.5
Gui, Font, s9 c0xFFFFFF, Segoe UI  ; reset for normal text

; === Seeds Tab ===
Gui, Tab, Seeds
Gui, Font, s9 c0x90EE90 Bold

Gui, Add, Text, x30 y40, Check Seed Shop:
Gui, Add, Checkbox, x170 y40 vCheckSeedShop, Enable
Gui, Add, GroupBox, x30 y70 w600 h470, Seed Shop Selection
Gui, Font, s9 cWhite Norm
xPos := 50, yPos := 100, col := 0
Loop % seedItems.MaxIndex()
{
        idx := A_Index
        Gui, Add, Checkbox, x%xPos% y%yPos% vSeed_%idx%, % seedItems[idx]
        yPos += 25
        if (yPos > 500) {
                yPos := 100
                col++
                xPos := 50 + (col * 150)
        }
}
; === Gears Tab ===
Gui, Tab, Gears
Gui, Font, s9 c0x87CEEB Bold
Gui, Add, Text, x30 y40, Check Gear Shop:
Gui, Add, Checkbox, x170 y40 vCheckGearShop, Enable
Gui, Add, GroupBox, x30 y70 w600 h470, Gear Shop Selection
Gui, Font, s9 cWhite Norm
xPos := 50, yPos := 100, col := 0
Loop % gearItems.MaxIndex()
{
        idx := A_Index
        Gui, Add, Checkbox, x%xPos% y%yPos% vGear%idx%, % gearItems[idx]
        yPos += 25
        if (yPos > 550) {
                yPos := 100
                col++
                xPos := 50 + (col * 150)
        }
}

; === Event Tab ===
Gui, Tab, Event
Gui, Font, s9 c0xFF1493 Bold
Gui, Add, Text, x30 y40, Check Event Shop:
Gui, Add, Checkbox, x170 y40 vCheckEventShop, Enable
Gui, Add, GroupBox, x30 y70 w600 h470, Event Shop Selection
Gui, Font, s9 cWhite Norm

; === Settings Tab ===
Gui, Tab, Settings

; Basic Settings
Gui, Font, s9 c0xFFD70A Bold
Gui, Add, GroupBox, x30 y40 w600 h280, Settings
Gui, Font, s9 cWhite Norm

Gui, Add, Text, x50 y70, Macro Speed:
Gui, Add, Edit, x200 y70 w100 vMacroSpeed cBlack, 1
Gui, Add, Text, x50 y100, UI Navigation Key:
Gui, Add, Edit, x200 y100 w100 vNavigationKey cBlack, \
Gui, Add, Text, x50 y130, Auto Align:
Gui, Add, Checkbox, x200 y130 vAutoAlign, Enable

Gui, Add, Text, x50 y160, Amount of items to buy:
Gui, Add, Edit, x200 y160 w100 vNoOfItems cBlack, 20
Gui, Add, Text, x50 y190, Admin Abuse:
Gui, Add, Checkbox, x200 y190 vAdminAbuse, Enable

; Advanced Settings
Gui, Font, 129 c0xFFD70A Bold
Gui, Add, GroupBox, x30 y330 w600 h210, Other Settings
Gui, Font, 129 cWhite Norm

; === Discord Webhooks Tab ===
Gui, Tab, Discord Webhooks

Gui, Font, s9 c0xA226E1 Bold
Gui, Add, GroupBox, x30 y40 w600 h500, Discord Webhooks (broken)
Gui, Font, s9 cWhite Norm

Gui, Add, Text, x50 y70, Send Discord Messages
Gui, Add, Checkbox, x200 y70 vSendDiscordMessages, Enable
Gui, Add, Text, x50 y100, Discord User ID:
Gui, Add, Edit, x200 y100 w270 vDiscordUserID cBlack, 0
Gui, Add, Text, x50 y130, Webhook URL:
Gui, Add, Edit, x200 y130 w270 vWebhookURL cBlack, 0
Gui, Add, Button, x50 y160 w100 h30 gTestWebhooks, 🧪Test

; === About Tab ===
Gui, Tab, About

; About section
Gui, Font, s9 cFFFFFF Bold
Gui, Add, GroupBox, x30 y40 w600 h160, About this macro
Gui, Font, s9 cFFFFFF Norm

Gui, Add, Picture, x50 y60 w48 h48, % mainDir "Images\\PyWareGardening.png"
Gui, Font, s9 cFFD700 Bold
Gui, Add, Text, x110 y60 w350, Catman2608
Gui, Font, s9 cFFC0CB Bold
Gui, Add, Text, x110 y80 w350, PyWare Gardening V3.0
Gui, Font, s9 cFFFFFF Norm

; Disclaimer section
Gui, Font, s9 cFF4444 Bold
Gui, Add, Text, x50 y120 w550, IMPORTANT DISCLAIMER: 
Gui, Font, s9 cFFFFFF Norm
Gui, Add, Text, x50 y140 w550, Any person claiming to be part of this project or its development, other than Catman2608
Gui, Add, Text, x50 y160 w550, is most likely lying. Be cautious of fake contributors or impersonators.

; Resources section
Gui, Font, s9 cFFFFFF Bold
Gui, Add, GroupBox, x30 y220 w600 h180, Resources
Gui, Font, s9 cFFFFFF Norm

; Links with proper spacing
Gui, Add, Link, x50 y250 w560, <a href="https://discord.com/invite/aMZY8yrF8r">Official PyWare Discord Server</a>
Gui, Add, Link, x50 y280 w560, <a href="https://sites.google.com/view/icf-automation-network/?tab=t.0">Official PyWare Website</a>
Gui, Add, Link, x50 y310 w560, <a href="https://docs.google.com/document/d/1WwWWMR-eN-R-GO42IioToHpWTgiXkLoiNE_4NeE-GsU/edit?tab=t.0">Upcoming Features</a>

; Automatically Load Settings
LoadSettings()

; Show Window
Gui, Show
return

; ===============================
; Save Settings (Updated)
; ===============================
SaveSettings:
{
                global settingsFile
                global seedItems, gearItems

                if FileExist(settingsFile)
        FileDelete, %settingsFile%

        ; Save main checkboxes
        GuiControlGet, CheckSeedShop
        GuiControlGet, CheckGearShop
        GuiControlGet, CheckEventShop
	GuiControlGet, AutoBrainrotInvasion
        GuiControlGet, AutoAlign
        GuiControlGet, NoOfItems
        GuiControlGet, PurchaseDelay
        GuiControlGet, MacroSpeed
        GuiControlGet, PrivateServerLink

        GuiControlGet, AdminAbuse
        GuiControlGet, AutoCollectCash
        GuiControlGet, NavigationKey
        GuiControlGet, BackpackKey

        GuiControlGet, SendDiscordMessages
        GuiControlGet, DiscordUserID
        GuiControlGet, WebhookURL

        IniWrite, %CheckSeedShop%, %settingsFile%, Settings, CheckSeedShop
        IniWrite, %CheckGearShop%, %settingsFile%, Settings, CheckGearShop
        IniWrite, %CheckEventShop%, %settingsFile%, Settings, CheckEventShop
        IniWrite, %AutoBrainrotInvasion%, %settingsFile%, Settings, AutoBrainrotInvasion
        IniWrite, %AutoAlign%, %settingsFile%, Settings, AutoAlign
        IniWrite, %NoOfItems%, %settingsFile%, Settings, NoOfItems
        IniWrite, %PurchaseDelay%, %settingsFile%, Settings, PurchaseDelay
        IniWrite, %MacroSpeed%, %settingsFile%, Settings, MacroSpeed
        IniWrite, %PrivateServerLink%, %settingsFile%, Settings, PrivateServerLink

        IniWrite, %AdminAbuse%, %settingsFile%, Settings, AdminAbuse
        IniWrite, %AutoCollectCash%, %settingsFile%, Settings, AutoCollectCash
        IniWrite, %NavigationKey%, %settingsFile%, Settings, NavigationKey
        IniWrite, %BackpackKey%, %settingsFile%, Settings, BackpackKey

	IniWrite, %SendDiscordMessages%, %settingsFile%, Discord Webhooks, SendDiscordMessages
	IniWrite, %DiscordUserID%, %settingsFile%, Discord Webhooks, DiscordUserID
	IniWrite, %WebhookURL%, %settingsFile%, Discord Webhooks, WebhookURL

        ; Save seeds
        Loop % seedItems.MaxIndex()
        {
                idx := A_Index
                GuiControlGet, isChecked,, Seed_%idx%
                IniWrite, %isChecked%, %settingsFile%, Seeds, Seed_%idx%
        }

        ; Save gears
        Loop % gearItems.MaxIndex()
        {
                idx := A_Index
                GuiControlGet, isChecked,, Gear%idx%
                IniWrite, %isChecked%, %settingsFile%, Gears, Gear%idx%
        }
        return
}

; ===============================
; Load Settings (Updated)
; ===============================
LoadSettings() {
        global settingsFile
        global seedItems, gearItems

        if !FileExist(settingsFile)
                return

        ; Load main checkboxes
        IniRead, CheckSeedShop, %settingsFile%, Settings, CheckSeedShop, 0
        IniRead, CheckGearShop, %settingsFile%, Settings, CheckGearShop, 0
        IniRead, CheckEventShop, %settingsFile%, Settings, CheckEventShop, 0
        IniRead, AutoBrainrotInvasion, %settingsFile%, Settings, AutoBrainrotInvasion, 0
        IniRead, AutoAlign, %settingsFile%, Settings, AutoAlign, 0
        IniRead, NoOfItems, %settingsFile%, Settings, NoOfItems, 5
        IniRead, PurchaseDelay, %settingsFile%, Settings, PurchaseDelay, 5
        IniRead, MacroSpeed, %settingsFile%, Settings, MacroSpeed, 5
        IniRead, PrivateServerLink, %settingsFile%, Settings, PrivateServerLink, 5

        IniRead, AdminAbuse, %settingsFile%, Settings, AdminAbuse, 0
        IniRead, AutoCollectCash, %settingsFile%, Settings, AutoCollectCash, 0
        IniRead, NavigationKey, %settingsFile%, Settings, NavigationKey, \
        IniRead, BackpackKey, %settingsFile%, Settings, BackpackKey, %BackpackKey%

	IniRead, SendDiscordMessages, %settingsFile%, Discord Webhooks, SendDiscordMessages, 0
	IniRead, DiscordUserID, %settingsFile%, Discord Webhooks, DiscordUserID, 0
	IniRead, WebhookURL, %settingsFile%, Discord Webhooks, WebhookURL, 0

        ; Update GUI controls 
        GuiControl,, CheckSeedShop, %CheckSeedShop%
        GuiControl,, CheckGearShop, %CheckGearShop%
        GuiControl,, CheckEventShop, %CheckEventShop%
        GuiControl,, AutoBrainrotInvasion, %AutoBrainrotInvasion%
        GuiControl,, AutoAlign, %AutoAlign%
        GuiControl,, NoOfItems, %NoOfItems%
        GuiControl,, PurchaseDelay, %PurchaseDelay%
        GuiControl,, MacroSpeed, %MacroSpeed%
        GuiControl,, PrivateServerLink, %PrivateServerLink%

        GuiControl,, AdminAbuse, %AdminAbuse%
        GuiControl,, AutoCollectCash, %AutoCollectCash%
        GuiControl,, NavigationKey, %NavigationKey%
        GuiControl,, BackpackKey, %BackpackKey%

        GuiControl,, SendDiscordMessages, %SendDiscordMessages%
        GuiControl,, DiscordUserID, %DiscordUserID%
        GuiControl,, WebhookURL, %WebhookURL%

        ; Load seeds
        Loop % seedItems.MaxIndex()
        {
                idx := A_Index
                IniRead, isChecked, %settingsFile%, Seeds, Seed_%idx%, 0
                GuiControl,, Seed_%idx%, %isChecked%
        }

        ; Load gears
        Loop % gearItems.MaxIndex()
        {
                idx := A_Index
                IniRead, isChecked, %settingsFile%, Gears, Gear%idx%, 0
                GuiControl,, Gear%idx%, %isChecked%
        }
        return
}
; Start Button Handler
StartClicked:
Gui, Submit, NoHide
Gui, Hide
Calculations()

ToolTip, Press F5 to start, %TooltipX%, %Tooltip3%, 3
ToolTip, Press F6 to reload, %TooltipX%, %Tooltip4%, 4
ToolTip, Press F7 to stop, %TooltipX%, %Tooltip5%, 5
return

; Exit and Hotkeys
GuiClose:
ExitApp

macroRunning := false

; --- Calculations Function ---
Calculations() {
    global TooltipX, Tooltip1, Tooltip2, Tooltip3, Tooltip4, Tooltip5, Tooltip6, Tooltip7, Tooltip8, Tooltip9, LookDownX, LookDownY, 

    LookDownX := A_ScreenWidth // 2
    LookDownY := A_ScreenHeight // 2
    TooltipX := A_ScreenWidth / 10
    Tooltip1 := (A_ScreenHeight / 2) - (20 * 8)
    Tooltip2 := (A_ScreenHeight / 2) - (20 * 7)
    Tooltip3 := (A_ScreenHeight / 2) - (20 * 6)
    Tooltip4 := (A_ScreenHeight / 2) - (20 * 5)
    Tooltip5 := (A_ScreenHeight / 2) - (20 * 4)
    Tooltip6 := (A_ScreenHeight / 2) - (20 * 3)
    Tooltip7 := (A_ScreenHeight / 2) - (20 * 2)
    Tooltip8 := (A_ScreenHeight / 2) - (20 * 1)
    Tooltip9 := (A_ScreenHeight / 2)
}

; --- Hotkeys ---
F5::
if (!macroRunning) {
    macroRunning := true

    ; Run calculations
    Calculations()

    ; Then start macro
    SetTimer, RunMacro, 10

    ; Tooltips
    ToolTip, Press F5 to start, %TooltipX%, %Tooltip3%, 3
    ToolTip, Press F6 to reload, %TooltipX%, %Tooltip4%, 4
    ToolTip, Press F7 to stop, %TooltipX%, %Tooltip5%, 5
}
return

F6::
macroRunning := false
SetTimer, RunMacro, Off
ToolTip
Reload
return

F7::
macroRunning := false
SetTimer, RunMacro, Off
ToolTip
ExitApp
return

CloseFailsafe:
PixelSearch, FoundX, FoundY, 1182, 208, 1255, 278, 0x0707F8, 0, Fast
if (ErrorLevel = 0) {
    Click, 1223, 243
}
return

RunMacro:
; === Macro logic ===

ToolTip, Beginning Alignment, %TooltipX%, %Tooltip1%, 1
MediumSleepAmount := 350 / MacroSpeed
SmallSleepAmount := 150 / MacroSpeed
TinySleepAmount := 80 / MacroSpeed
if (!macroRunning)
    return

Loop, 20 {
    Send, {wheelup}
    Sleep, %SmallSleepAmount%
}
Loop, 10 {
    Send, {wheeldown}
    Sleep, %SmallSleepAmount%
}

if (AutoAlign == true)
{
        Send, {Esc}
        Sleep, 1450
        Send, {Tab}
        Sleep, 400
	Loop, 18 {
        	Send, {Down}
        	Sleep, %TinySleepAmount%
	}
	Sleep, 100
        Loop, 2 {
                Send, D
                Sleep, %TinySleepAmount%
        }
        Send, {Esc}
        Sleep, 1450
        Send, %NavigationKey%
        Sleep, 250
        
        ; align camera to Steven's position
        AutoAlignNavigation()

        Loop, 2 {
                Send, {enter}
                Sleep, %MediumSleepAmount%
                CurrentLocation := "SeedShop"
                Loop, 2 {
                        Send, {Right}
                        Sleep, 200
                }
                Send, {enter}
                Sleep, %MediumSleepAmount%
                CurrentLocation := "SellShop"
                Loop, 2 {
                        Send, {Left}
                        Sleep, 200
                }
        }
        Send, %NavigationKey%
        Sleep, %MediumSleepAmount%

        Send, {Esc}
        Sleep, %MediumSleepAmount%0
        Send, {Tab}
        Sleep, 400
	Loop, 18 {
        	Send, {Down}
        	Sleep, %TinySleepAmount%
	}
	Sleep, 100
        Loop, 2 {
                Send, D
                Sleep, %TinySleepAmount%
        }
        Send, {Esc}
        Sleep, 1450
        Send, %NavigationKey%
        Sleep, %MediumSleepAmount%
        AutoAlignNavigation()
        Send, {Enter}
        Sleep, 500
}
Send, %NavigationKey%
Sleep, 500
if (CheckSeedShop) {
        CurrentLocation := "SeedShop"
        ; Check seed shop
        Send, {E}
        Sleep, 1450
	Message := "Seed Stock Update"
	SendDiscordWebhook(WebhookURL, Message)
        Send, %NavigationKey%
        Sleep, 500
	ToolTip, Seed Stock Opened, %TooltipX%, %Tooltip1%, 1
	Loop, 2 {
		Send, {Down}
		Sleep, %SmallSleepAmount%
	}
	ToolTip, Current Location: Seed Shop, %TooltipX%, %Tooltip1%, 1
        ; Buy only checked seeds
        Loop % seedItems.MaxIndex() {
                idx := A_Index
                GuiControlGet, isChecked,, Seed_%idx%
                Sleep, %SmallSleepAmount%
                
                if (isChecked) {
                        ; Show tooltip for current fruit being purchased
			seedName := seedItems[idx]
                        Tooltip, Seed_%idx%, %TooltipX%, %Tooltip1%, 1
                        Sleep, %SmallSleepAmount%
        		Send, {Enter}
        		Sleep, %SmallSleepAmount%
			Send, {Down}
			Sleep, %SmallSleepAmount%
			Loop, %NoOfItems% {
				Send, {Enter}
				Sleep, %SmallSleepAmount%
			}
                        Send, {Down}
                        Sleep, %MediumSleepAmount%
                } else {
                        Send, {Down} ; Move to next seed
                	Sleep, %SmallSleepAmount%
                }
        }

        ; Reset position
        Loop % seedItems.MaxIndex() {
                Send, {Up}
                Sleep, %SmallSleepAmount%
        }
        Sleep, %MediumSleepAmount%
        ; Close shop
        Send, {Up}
        Sleep, %SmallSleepAmount%
        Send, {Up}
        Sleep, %SmallSleepAmount%
        Send, {Right}
        Sleep, %SmallSleepAmount%
        Send, {Enter}
        Sleep, %SmallSleepAmount%
        ToolTip, Seed Shop Closed, %TooltipX%, %Tooltip1%, 1
        Sleep, %SmallSleepAmount%
        Send, %NavigationKey%
}
; If not in gear shop then teleport to gear shop else press e
if (CheckGearShop) {
	Send, {S down}
	Sleep, 1000
	Send, {S up}
} else {
        Sleep, %SmallSleepAmount%
}

Sleep, %MediumSleepAmount%0
if (CheckGearShop) {
        CurrentLocation := "GearShop"
        ; Check gear shop
        Send, {E}
        Sleep, 1450
        Send, %NavigationKey%
        Sleep, %SmallSleepAmount%

        ToolTip, Gear Shop Opened, %TooltipX%, %Tooltip1%, 1
	Loop, 2 {
		Send, {Down}
		Sleep, %SmallSleepAmount%
	}
        ToolTip, Current Location: Gear Shop, %TooltipX%, %Tooltip1%, 1
        ; Buy only checked gears
        Loop % gearItems.MaxIndex() {
                idx := A_Index
                GuiControlGet, isChecked,, Gear%idx%
                Sleep, %SmallSleepAmount%
                
                if (isChecked) {
                        ; Show tooltip for current fruit being purchased
			gearName := gearItems[idx]
                        Tooltip, Seed_%idx%, %TooltipX%, %Tooltip1%, 1
                        Sleep, %SmallSleepAmount%
        		Send, {Enter}
        		Sleep, %SmallSleepAmount%
			Send, {Down}
			Sleep, %SmallSleepAmount%
			Loop, %NoOfItems% {
				Send, {Enter}
				Sleep, %SmallSleepAmount%
			}
                        Send, {Down}
                        Sleep, %SmallSleepAmount%
                } else {
                        Send, {Down} ; Move to next seed
                	Sleep, %SmallSleepAmount%
                }
        }

        ; Reset position
        Loop % gearItems.MaxIndex() {
                Send, {Up}
                Sleep, %SmallSleepAmount%
        }
        Sleep, %MediumSleepAmount%
        ; Close shop
        Send, {Up}
        Sleep, %SmallSleepAmount%
        Send, {Up}
        Sleep, %SmallSleepAmount%
        Send, {Right}
        Sleep, %SmallSleepAmount%
        Send, {Enter}
        Sleep, %SmallSleepAmount%
        ToolTip, Gear Shop Closed, %TooltipX%, %Tooltip1%, 1
        Sleep, %SmallSleepAmount%
        Send, %NavigationKey%
}
if (AdminAbuse == false) {
        Loop
        {
                FormatTime, CurrentMin,, m                ; Get current minute (00–59)
                if (Mod(CurrentMin, 5) = 0)   ; Check if divisible by 5
                break
                Sleep, %MediumSleepAmount%0   ; wait 1 second before checking again
                Sleep, %SmallSleepAmount%
        }
        ; Use ID 7 for waiting tooltip
        ToolTip, Waiting for next stock, %TooltipX%, %Tooltip7%, 7
}
return

AutoAlignNavigation() {
	Send, {Up}
	Sleep, %SmallSleepAmount%
	Loop, 10 {
		Send, {Left}
		Sleep, %SmallSleepAmount%
	}
	Send, {Up}
	Sleep, %SmallSleepAmount%
	Loop, 4 {
		Send, {Right}
		Sleep, %SmallSleepAmount%
	}
}
TestWebhooks:
Message := "Stock bot is working"
status := SendDiscordWebhook(WebhookURL, Message)
MsgBox, Webhook returned status: %status%
return
SendDiscordWebhook(url, message) {
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("POST", url, false)
        whr.SetRequestHeader("Content-Type", "application/json")

        json := "{""content"": """ . message . """}"

        whr.Send(json)
        return whr.Status
    } catch e {
        ToolTip, % "Webhook Error: " e.Message, %TooltipX%, %Tooltip9%, 9
        return 0
    }
}