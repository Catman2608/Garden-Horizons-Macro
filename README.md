# PyWare Gardening Macro by Catman2608
An AutoHotKey macro for the Roblox game "PyWare Gardening" (formerly Grow A Garden and Garden Horizons)

## 📋 Prerequisites
- **AutoHotKey v1.1** (NOT v2.0) - [Download here](https://www.autohotkey.com/)
- A **private server** is recommended for macroing
- Make sure to **unplug any controllers** from your PC as they can interfere with the macro

## ⚙️ Installation

1. **Install AutoHotKey**
   - Download and run the AutoHotKey v1.1 installer from the link above

2. **Download the Macro**
   - Scroll up and go to Code -> Download ZIP.

3. **Extract the Files**
   - Extract the downloaded ZIP file to your desired location (DO NOT run the macro from within the ZIP file)

## 🎮 Setup Instructions

Before running the macro, ensure you have completed the following steps:

- ✅ Extract the macro files to a folder on your computer
- ✅ Set Roblox to **Windowed Fullscreen** mode (NOT fullscreen)
- ✅ Enable **UI Navigation** in your Roblox settings
- ✅ Install **AutoHotKey v1.1** (not v2.0)
- ✅ Unplug any **controllers** from your PC

I'll add a helpful AI-assisted update feature to make this process much smoother for users. Here's the updated section with a new option to get AI help:

---

## 🔧 How to Add Future Seeds/Gears

### Option 1: 🤖 AI-Assisted Update using DeepSeek (Recommended)
**Let AI do the work for you!** Click the button below to open DeepSeek and make sure to upload this AHK file:

![DeepSeek](https://chat.deepseek.com/)

**What DeepSeek will help you with:**
- ✅ Format new items correctly
- ✅ Add proper commas and syntax
- ✅ Validate your changes
- ✅ Fork the repository if needed
- ✅ Submit pull requests with updates

### Option 2: 📝 Manual Update (Traditional)
If you prefer to do it manually, follow these steps:

#### Accessing the Code
1. Right-click on `PyWare Gardening V3.ahk`
2. Select **"Edit with Notepad"** (or any text editor - DO NOT use Microsoft Word)

#### Finding the Right Section
3. Scroll down to the **"item arrays"** section (around line 50-51)

#### Adding New Items

**To Add a New Seed:**
- Locate `seedItems` in the item arrays section
- Add a comma followed by `"Future Seed Name"` just before the closing square bracket `]`

**To Add a New Gear:**
- Locate `gearItems` (found under the seedItems section)
- Add a comma followed by `"Future Gear Name"` just before the closing square bracket `]`

### Example:
```autohotkey
; Before
seedItems := ["Wheat", "Corn", "Carrot"]

; After adding "Tomato"
seedItems := ["Wheat", "Corn", "Carrot", "Tomato"]
```

---

### 🔄 Fork Repository & Submit Updates
Want to contribute your new seeds/gears back to the project? Follow this guide:

#### Step-by-Step Forking Guide:

**1. Create a GitHub Account** (if you don't have one)
- Go to [GitHub.com](https://github.com)
- Click "Sign up" and follow the registration process

**2. Fork the Repository**
- Navigate to the original repository: `https://github.com/your-repo/pyware-gardening`
- Click the **"Fork"** button (top-right corner of the page)
- Select your account as the destination
- Wait a few seconds for GitHub to create your copy

**3. Clone Your Fork (Optional - for local changes)**
```bash
# Copy your fork's URL (it will look like this)
git clone https://github.com/YOUR-USERNAME/pyware-gardening.git

# Navigate to the folder
cd pyware-gardening
```

**4. Make Your Changes**
- Edit the `PyWare Gardening V3.ahk` file
- Add your new seeds/gears to the arrays
- Save the file

**5. Commit and Push Changes**
```bash
# Add your changes
git add PyWare\ Gardening\ V3.ahk

# Commit with a descriptive message
git commit -m "Added new seeds: Tomato, Pepper, Basil"

# Push to your fork
git push origin main
```

**6. Create a Pull Request**
- Go to **YOUR** forked repository on GitHub
- Click the **"Contribute"** button (next to the code button)
- Select **"Open Pull Request"**
- Add a title and description explaining your changes
- Click **"Create Pull Request"**

#### 📋 Pull Request Template:
```
## Added New Items
- **Seeds Added:** [List new seeds]
- **Gears Added:** [List new gears]

## Testing Done
- [ ] Verified syntax is correct
- [ ] Tested script runs without errors
- [ ] Confirmed new items appear in the UI

## Screenshots (if applicable)
[Add screenshots here]
```

#### 🎯 Quick Visual Guide:

```
Original Repo (upstream)
        ↓
    [FORK] ← Click this button!
        ↓
Your Copy (fork) ← You can edit this!
        ↓
[PULL REQUEST] ← Submit changes back!
```