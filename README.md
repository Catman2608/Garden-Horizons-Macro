# Garden Horizons Macro by Catman2608
An AutoHotKey macro for the Roblox game "Garden Horizons"

## 📋 Prerequisites
- **AutoHotKey v1.1** (NOT v2.0) - [Download here](https://www.autohotkey.com/)
- A **private server** is recommended for macroing
- Make sure to **unplug any controllers** from your PC as they can interfere with the macro

## ⚙️ Installation

1. **Install AutoHotKey**
   - Download and run the AutoHotKey v1.1 installer from the link above

2. **Download the Macro**
   - Get the latest version from: [ICF Automation Network](https://sites.google.com/view/icf-automation-network/)

3. **Extract the Files**
   - Extract the downloaded ZIP file to your desired location (DO NOT run the macro from within the ZIP file)

## 🎮 Setup Instructions

Before running the macro, ensure you have completed the following steps:

- ✅ Extract the macro files to a folder on your computer
- ✅ Set Roblox to **Windowed Fullscreen** mode (NOT fullscreen)
- ✅ Enable **UI Navigation** in your Roblox settings
- ✅ Install **AutoHotKey v1.1** (not v2.0)
- ✅ Unplug any **controllers** from your PC

## 🔧 How to Add Future Seeds/Gears

### Accessing the Code
1. Right-click on `Garden Horizons by Longest.ahk`
2. Select **"Edit with Notepad"** (or any text editor - DO NOT use Microsoft Word)

### Finding the Right Section
3. Scroll down to the **"item arrays"** section (around line 50-51)

### Adding New Items

#### To Add a New Seed:
- Locate `seedItems` in the item arrays section
- Add a comma followed by `"Future Seed Name"` just before the closing square bracket `]`

#### To Add a New Gear:
- Locate `gearItems` (found under the seedItems section)
- Add a comma followed by `"Future Gear Name"` just before the closing square bracket `]`

### Example:
```autohotkey
; Before
seedItems := ["Wheat", "Corn", "Carrot"]

; After adding "Tomato"
seedItems := ["Wheat", "Corn", "Carrot", "Tomato"]