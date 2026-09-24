# SMF Screenshot — Mobile to PC

Local Wi-Fi screenshot auto-sync from Android to Windows PC.

**Stack:** Android + FolderSync + Windows SMB2/SMB3  
**No cloud storage required.** Both devices stay on the same trusted Wi-Fi network.

## What it does

```text
Android
  Screenshot
      ↓
/Pictures/Screenshots/
      ↓
FolderSync (Instant Sync)
      ↓  Wi-Fi / SMB2-3
Windows PC
      ↓
PhoneScreenshots
      ↓
screenshots/
```

When a new screenshot is detected on the phone, FolderSync can sync it to the Windows shared folder.

## PC setup

1. Clone or download this repository.
2. Open the `windows/` folder.
3. Right-click `setup_windows_share.bat` → **Run as administrator**.
4. The script creates the `PhoneScreenshots` SMB share for this repository's `screenshots/` folder and enables the Windows File and Printer Sharing firewall rules.
5. Note the PC IP shown by the script, for example:

```
\\192.168.1.2\\PhoneScreenshots
```

The SMB share is persistent across Windows restarts. The Python HTTP receiver is not required for the FolderSync + SMB setup.

## FolderSync setup

Install **FolderSync** on Android and create an SMB2/SMB3 account.

### SMB account

```
Server:      <PC-IP>
Port:        445
Share name:  PhoneScreenshots
Username:    <Windows username>
Password:    <Windows password>
```

Do not use SMB1.

### FolderPair

```
Name:        Phone Screenshots → PC
Sync type:   To right folder

Left folder:
    Internal Storage/Pictures/Screenshots/

Right folder:
    SMB2/SMB3 → PhoneScreenshots
```

For automatic triggering:

- Enable **Instant Sync / Monitor device folder** for the FolderPair.
- Keep a fallback schedule such as **Every 1 hour**.
- Restrict sync to **Wi-Fi** if desired.
- Keep **Sync deletions OFF** unless you specifically want deletions mirrored.
- Disable Android battery optimization for FolderSync.
- Allow FolderSync notifications.
- Allow file/storage access requested by the app.

## Android background reliability

Android vendors can restrict background apps. For reliable FolderSync operation:

1. Set FolderSync battery usage to **Unrestricted / Don't optimize**.
2. Do not put FolderSync in a phone's battery-saver/auto-clean list.
3. Keep Instant Sync enabled.
4. Keep the fallback schedule enabled.

Actual transfer latency depends on Android background rules, Wi-Fi conditions, and FolderSync detection.

## Testing

1. Make sure the PC is connected to the same Wi-Fi as the phone.
2. Run the Windows setup script once.
3. In FolderSync, run the FolderPair manually once.
4. Confirm that an existing screenshot appears in:

```
screenshots/
```

5. Take a new screenshot on Android.
6. Confirm the new image appears in the same PC folder.

## Repository layout

```
.
├── README.md
├── screenshots/
│   └── .gitkeep
└── windows/
    ├── setup_windows_share.bat
    └── remove_windows_share.bat
```

The `screenshots/` directory is runtime data and is intentionally kept out of Git history except for its placeholder.

## Security

This is intended for a trusted local network.

- Do not expose SMB port 445 to the public internet.
- Use a Windows account with a password for SMB authentication.
- Keep the PC and phone on a trusted/private Wi-Fi network.
- The shared folder contains whatever screenshots you choose to sync.

## Why FolderSync?

FolderSync is the Android-side sync layer used by this project. It monitors/schedules synchronization of the phone's screenshot folder and transfers the files to the Windows SMB share.

This project therefore uses:

**FolderSync → SMB2/SMB3 → Windows → screenshots/**

rather than cloud storage or an external server.
