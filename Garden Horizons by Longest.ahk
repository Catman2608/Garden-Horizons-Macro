; ============================================================
; Garden Horizons Macro V1.0
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

; === Load settings when script starts ===
LoadSettings()

; The GUI section below uses 0xRRGGBB instead of 0xBBGGRR unlike the other sections

Gui, +Resize +MinSize
Gui, Color, 0x1D1D1D
Gui, Font, s9 cFFFFFF, Segoe UI
Gui, Add, Tab2, w660 h630, Seeds|Gears|Event|Settings|About

; === Screen Coordinates ===
ClickX := A_ScreenWidth / 1920
ClickY := A_ScreenHeight / 1080
TooltipX := A_ScreenWidth * 0.15
Tooltip1 := A_ScreenHeight * 0.25

; === Item Arrays ===
seedItems := ["Carrot Seed", "Corn Seed", "Onion Seed", "Strawberry Seed", "Mushroom Seed", "Beetroot Seed", "Tomato Seed", "Apple Seed", "Rose Seed", "Wheat Seed", "Banana Seed", "Plum Seed", "Potato Seed", "Cabbage Seed", "Cherry Seed"]

gearItems := ["Watering Can", "Basic Sprinkler", "Harvest Bell", "Turbo Sprinkler", "Favorite Tool", "Super Sprinkler"]

; === Buttons ===
Gui, Tab,
Gui, Font, s9 c0xff6b6b Bold
Gui, Add, GroupBox, x30 y560 w600 h60, Macro Stopped - Ready to Start
Gui, Font, s9 cWhite Norm, Segoe UI
Gui, Add, Button, x40 y580 w100 h30 gStartClicked, 🚀 Start
Gui, Add, Button, x160 y580 w100 h30 gSaveSettings, 💾 Save
Gui, Add, Button, x280 y580 w100 h30 gLoadSettings, 📂 Load
Gui, Add, Text, x600 y600 , V1.0
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
        if (yPos > 550) {
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
Gui, Add, GroupBox, x30 y40 w600 h280, Basic Settings
Gui, Font, s9 cWhite Norm

Gui, Add, Text, x50 y70, Macro Speed:
Gui, Add, Edit, x200 y70 w100 vMacroSpeed cBlack, 1
Gui, Add, Text, x50 y100, UI Navigation Key:
Gui, Add, Edit, x200 y100 w100 vNavigationKey cBlack, \
Gui, Add, Text, x50 y130, Backpack Key:
Gui, Add, ComboBox, x200 y130 w100 vBackpackKey, ```|~
Gui, Add, Text, x50 y160, Auto Align:
Gui, Add, Checkbox, x200 y160 vAutoAlign, Enable
Gui, Add, Text, x50 y190, Auto Collect Cash:
Gui, Add, Checkbox, x200 y190 vAutoCollectCash, Enable
Gui, Add, Text, x50 y220, Auto Brainrot Invasion:
Gui, Add, Checkbox, x200 y220 vAutoBrainrotInvasion, Enable
Gui, Add, Text, x50 y250, Private Server Link:
Gui, Add, Edit, x200 y250 w400 vPrivateServerLink cBlack, [Enter Private Server Link Here]

; Advanced Settings
Gui, Font, 129 c0xFFD70A Bold
Gui, Add, GroupBox, x30 y330 w600 h210, Advanced Settings
Gui, Font, 129 cWhite Norm

Gui, Add, Text, x50 y360, Amount of items to buy:
Gui, Add, Edit, x200 y360 w100 vNoOfItems cBlack, 20
Gui, Add, Text, x50 y390, Purchase Delay:
Gui, Add, Edit, x200 y390 w100 vPurchaseDelay cBlack, 750
Gui, Add, Text, x50 y420, Admin Abuse:
Gui, Add, Checkbox, x200 y420 vAdminAbuse, Enable

; === About Tab ===
Gui, Tab, About

; About section
Gui, Font, s9 cFFFFFF Bold
Gui, Add, GroupBox, x30 y40 w600 h160, About this macro
Gui, Font, s9 cFFFFFF Norm

Gui, Add, Picture, x50 y60 w48 h48, % mainDir "Images\\ICantGarden.png"
Gui, Font, s9 cFFD700 Bold
Gui, Add, Text, x110 y60 w350, Catman2608
Gui, Font, s9 cFFC0CB Bold
Gui, Add, Text, x110 y80 w350, Garden Horizons Macro [V1.0]
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
Gui, Add, Link, x50 y250 w560, <a href="https://discord.gg/aMZY8yrF8r">Join ICF Automation Network Discord</a>
Gui, Add, Link, x50 y280 w560, <a href="https://sites.google.com/view/icf-automation-network/">ICF Automation Network Website</a>
Gui, Add, Text, x50 y310 w560, If it’s your first time, check all boxes in Settings.
Gui, Add, Link, x50 y340 w560, <a href="https://docs.google.com/document/d/1UT3I6UCcKv6wM4szNx0ulL1otYwrXciAEWwtXm5flQ8/edit?usp=sharing">View and Fix Current Problems</a>

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
SmallSleepAmount := 150 / MacroSpeed
MediumSleepAmount := 250 / MacroSpeed
ShopDelayAmount := 2250
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
Send, {rbutton up}
Sleep, 50
mousemove, LookDownX, LookDownY
tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
Sleep, 50
Send, {rbutton down}
tooltip, Action: Hold Right Click, %TooltipX%, %Tooltip8%, 8
Sleep, 100
DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
tooltip, Action: Move Mouse Down, %TooltipX%, %Tooltip8%, 8
Sleep, 100
Send, {rbutton up}
tooltip, Action: Release Right Click, %TooltipX%, %Tooltip8%, 8
Sleep, 50
mousemove, LookDownX, LookDownY
tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
Sleep, 50
if (AutoAlign == true) {
        Send, {Esc}
        Sleep, %ShopDelayAmount%
        Send, {Tab}
        Sleep, 400
        Send, {Down}
        Sleep, %SmallSleepAmount%
        
        Loop, 2 {
                Send, D
                Sleep, %SmallSleepAmount%
        }
        Send, {Esc}
        Sleep, %ShopDelayAmount%
        Send, %NavigationKey%
        Sleep, 350
	AutoAlignNavigation()

        Loop, 2 {
		Sleep, 200
                Send, {enter}
                Sleep, 350 ; Can't change this
                CurrentLocation := "SeedShop"
                Loop, 2 {
                        Send, {Right}
                        Sleep, 100
                }
		Sleep, 200
                Send, {enter}
                Sleep, 350 ; Can't change this
                CurrentLocation := "SellShop"
                Loop, 2 {
                        Send, {Left}
                        Sleep, 100
                }
        }
        Send, %NavigationKey%
        Sleep, 350
        Send, {Esc}
        Sleep, %ShopDelayAmount%
        Send, {Tab}
        Sleep, 400
        Send, {Down}
        Sleep, %SmallSleepAmount%
        
        Loop, 2 {
                Send, D
                Sleep, %SmallSleepAmount%
        }
        Send, {Esc}
        Sleep, %ShopDelayAmount%
}
if (CheckSeedShop) {
        Send, %NavigationKey%
        Sleep, 350
        AutoAlignNavigation()
        Sleep, 350
	Send, {Enter}
	Sleep, 350
        Send, E
        ToolTip, Current Location: Seed Shop, %TooltipX%, %Tooltip1%, 1
        Sleep, %ShopDelayAmount%
        AutoAlignShop()
        Loop % seedItems.MaxIndex() {
                idx := A_Index
                GuiControlGet, isChecked,, Seed_%idx%
                Sleep, 350
                Tooltip, %seedName%, %TooltipX%, %Tooltip1%, 1
                if (isChecked) {
                        ; Show tooltip for current seed being purchased
                        seedName := seedItems[idx]
                        Sleep, 350

                        ; Select seed
                        Send, {Enter}
                        Sleep, %SmallSleepAmount%
                        Send, {Down}
                        Sleep, %SmallSleepAmount%
                        Send, {Left}
                        Sleep, %SmallSleepAmount%
                        Send, {Left}
                        Sleep, 350
                        ; Purchase multiple items
                        Loop, %NoOfItems% {
                                Send, {Enter}
                                Sleep, %SmallSleepAmount%
                        }
                        Send, {Up}
                        Sleep, %SmallSleepAmount%
                        Send, {Enter}
                        Sleep, 350
                        Send, {Down}
                        Sleep, 350
                        Send, {Down}
                        Sleep, 350
                } else {
                        ; Skip unchecked seed
                        Send, {Down}
                        Sleep, %SmallSleepAmount%
                        Send, {Down}
                        Sleep, 100
                }
        }
        Loop % seedItems.MaxIndex() {
                Send, {Up}
                Sleep, 350
                Send, {Up}
                Sleep, 350
        }
                Send, {Up}
                Sleep, 100
                Send, {Up}
                Sleep, 350
                Send, {Enter}
                Sleep, 350
		Send, %NavigationKey%
}
Send, %NavigationKey%
Sleep, 350
AutoAlignNavigation()
Sleep, 350
Send, {Enter}
Sleep, 350
Send, %NavigationKey%
Sleep, 500
Send, {S down}
Send, {D down}
Sleep, 2000
Send, {S up}
Sleep, 1250
Send, {D up}
Sleep, 500
if (CheckGearShop) {
        Send, E
        ToolTip, Current Location: Gear Shop, %TooltipX%, %Tooltip1%, 1
        Sleep, %ShopDelayAmount%
        Send, %NavigationKey%
        Sleep, 350
        AutoAlignShop()
        Loop % GearItems.MaxIndex() {
                idx := A_Index
                GuiControlGet, isChecked,, Gear_%idx%
                Sleep, 350
                Tooltip, %GearName%, %TooltipX%, %Tooltip1%, 1
                if (isChecked) {
                        ; Show tooltip for current Gear being purchased
                        GearName := GearItems[idx]
                        Sleep, 350

                        ; Select Gear
                        Send, {Enter}
                        Sleep, %SmallSleepAmount%
                        Send, {Down}
                        Sleep, %SmallSleepAmount%
                        Send, {Left}
                        Sleep, %SmallSleepAmount%
                        Send, {Left}
                        Sleep, 350
                        ; Purchase multiple items
                        Loop, %NoOfItems% {
                                Send, {Enter}
                                Sleep, %SmallSleepAmount%
                        }
                        Send, {Up}
                        Sleep, %SmallSleepAmount%
                        Send, {Enter}
                        Sleep, 350
                        Send, {Down}
                        Sleep, 350
                        Send, {Down}
                        Sleep, 350
                } else {
                        ; Skip unchecked Gear
                        Send, {Down}
                        Sleep, %SmallSleepAmount%
                        Send, {Down}
                        Sleep, 100
                }
        }
        Loop % GearItems.MaxIndex() {
                Send, {Up}
                Sleep, 350
                Send, {Up}
                Sleep, 350
        }
                Send, {Up}
                Sleep, 100
                Send, {Up}
                Sleep, 350
                Send, {Enter}
                Sleep, 350
		Send, %NavigationKey%
}
return

AutoAlignNavigation() {
	Send, {Up}
	Sleep, %SmallSleepAmount%
	Send, {Up}
	Sleep, %SmallSleepAmount%
	Send, {Right}
	Sleep, %SmallSleepAmount%
}
AutoAlignShop() {
	Send, {Right}
        Sleep, 350
	Send, {Right}
        Sleep, 350
	Send, {Down}
        Sleep, 350
	Send, {Down}
        Sleep, 350
	Send, {Enter}
        Sleep, 350
	Send, {Enter}
        Sleep, 350
}