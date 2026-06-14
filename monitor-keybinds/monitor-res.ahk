#Requires AutoHotkey v2.0
#SingleInstance Force
; ---------------------------------------------------------------------------
; Monitor presets via the modern CCD API (Query/SetDisplayConfig) -- the same
; path Windows Settings uses. Required for scaled modes such as 1280x720 @ 120
; Hz (whose signal is 2560x1440 @ 120 Hz); the legacy ChangeDisplaySettings
; rejects those with DISP_CHANGE_FAILED (-2).
;
;   Ctrl+Shift+1/2/3/4/5       -> apply preset
;   Ctrl+Shift+Alt+1/2/3/4/5   -> RECORD the current full display config into preset
;
; A recorded preset is the exact path + mode arrays QueryDisplayConfig returns,
; replayed verbatim. Presets not yet recorded fall back to width/height/refresh
; via the legacy API.
; ---------------------------------------------------------------------------

global SCRIPT_DIR := A_ScriptDir
global presets := Map(
    1, {w: 3440, h: 1440, hz: 84.96,  slot: SCRIPT_DIR "\slot1.dat"},
    2, {w: 2560, h: 1080, hz: 119.88, slot: SCRIPT_DIR "\slot2.dat"},
    3, {w: 1280, h: 720,  hz: 120,    slot: SCRIPT_DIR "\slot3.dat"},
    4, {w: 2560, h: 1440, hz: 120,    slot: SCRIPT_DIR "\slot4.dat"},
    5, {w: 1920, h: 1080, hz: 120,    slot: SCRIPT_DIR "\slot5.dat"})

global QDC_ONLY_ACTIVE_PATHS := 0x2
; SDC_USE_SUPPLIED_DISPLAY_CONFIG(0x20) | SDC_APPLY(0x80) | SDC_SAVE_TO_DATABASE(0x200)
; NOTE: no SDC_ALLOW_CHANGES -- with it, Windows silently downgrades the scaled
; 720p@120 config to native 720p@85. Without it, the supplied config is applied
; exactly or the call fails cleanly.
global SDC_FLAGS  := 0x20 | 0x80 | 0x200
global PATH_SIZE  := 72   ; sizeof(DISPLAYCONFIG_PATH_INFO) on x64
global MODE_SIZE  := 64   ; sizeof(DISPLAYCONFIG_MODE_INFO) on x64

^+1::ApplyPreset(1)
^+2::ApplyPreset(2)
^+3::ApplyPreset(3)
^+4::ApplyPreset(4)
^+5::ApplyPreset(5)
^+!1::RecordPreset(1)
^+!2::RecordPreset(2)
^+!3::RecordPreset(3)
^+!4::RecordPreset(4)
^+!5::RecordPreset(5)

ApplyPreset(n) {
    global presets
    p := presets[n]
    if FileExist(p.slot)
        ApplyCcd(p.slot)
    else
        SetRes(p.w, p.h, p.hz)
}

RecordPreset(n) {
    global presets, QDC_ONLY_ACTIVE_PATHS, PATH_SIZE, MODE_SIZE
    p := presets[n]
    nPath := 0, nMode := 0
    if (DllCall("GetDisplayConfigBufferSizes", "UInt", QDC_ONLY_ACTIVE_PATHS, "UInt*", &nPath, "UInt*", &nMode, "Int") != 0) {
        Flash("Record failed: GetDisplayConfigBufferSizes")
        return
    }
    pathBuf := Buffer(nPath * PATH_SIZE, 0)
    modeBuf := Buffer(nMode * MODE_SIZE, 0)
    if (DllCall("QueryDisplayConfig", "UInt", QDC_ONLY_ACTIVE_PATHS, "UInt*", &nPath, "Ptr", pathBuf, "UInt*", &nMode, "Ptr", modeBuf, "Ptr", 0, "Int") != 0) {
        Flash("Record failed: QueryDisplayConfig")
        return
    }
    hdr := Buffer(8, 0)
    NumPut("UInt", nPath, hdr, 0)
    NumPut("UInt", nMode, hdr, 4)
    f := FileOpen(p.slot, "w")
    f.RawWrite(hdr, 8)
    f.RawWrite(pathBuf, nPath * PATH_SIZE)
    f.RawWrite(modeBuf, nMode * MODE_SIZE)
    f.Close()
    Flash("Recorded slot " n "  (" nPath " paths, " nMode " modes)")
}

ApplyCcd(path) {
    global SDC_FLAGS, PATH_SIZE, MODE_SIZE
    f := FileOpen(path, "r")
    hdr := Buffer(8, 0)
    f.RawRead(hdr, 8)
    nPath := NumGet(hdr, 0, "UInt")
    nMode := NumGet(hdr, 4, "UInt")
    pathBuf := Buffer(nPath * PATH_SIZE, 0)
    modeBuf := Buffer(nMode * MODE_SIZE, 0)
    f.RawRead(pathBuf, nPath * PATH_SIZE)
    f.RawRead(modeBuf, nMode * MODE_SIZE)
    f.Close()
    ret := DllCall("SetDisplayConfig", "UInt", nPath, "Ptr", pathBuf, "UInt", nMode, "Ptr", modeBuf, "UInt", SDC_FLAGS, "Int")
    if (ret = 0)
        Flash("Applied preset")
    else
        Flash("CCD apply failed (err " ret ")")
}

; Legacy fallback for presets that haven't been recorded yet.
SetRes(targetW, targetH, targetHz) {
    static DEVMODE_SIZE := 220
    devPtr := PrimaryPtr()
    floorHz   := Floor(targetHz)
    haveExact := false, haveClose := false
    bestDiff  := 1.0e18
    exact := Buffer(DEVMODE_SIZE, 0)
    close := Buffer(DEVMODE_SIZE, 0)
    i := 0
    Loop {
        dm := Buffer(DEVMODE_SIZE, 0)
        NumPut("UShort", DEVMODE_SIZE, dm, 68)
        if !DllCall("EnumDisplaySettingsExW", "Ptr", devPtr, "UInt", i, "Ptr", dm, "UInt", 0x02, "Int")
            break
        i += 1
        bpp := NumGet(dm, 168, "UInt"), w := NumGet(dm, 172, "UInt"), h := NumGet(dm, 176, "UInt"), hz := NumGet(dm, 184, "UInt")
        if (w != targetW || h != targetH || bpp < 32)
            continue
        if (hz = floorHz && !haveExact) {
            DllCall("RtlMoveMemory", "Ptr", exact, "Ptr", dm, "UPtr", DEVMODE_SIZE)
            haveExact := true
        }
        diff := Abs(hz - targetHz)
        if (diff < bestDiff) {
            bestDiff := diff
            DllCall("RtlMoveMemory", "Ptr", close, "Ptr", dm, "UPtr", DEVMODE_SIZE)
            haveClose := true
        }
    }
    if !(haveExact || haveClose) {
        Flash("No " targetW "x" targetH " mode on the primary monitor")
        return
    }
    chosen := haveExact ? exact : close
    ret := DllCall("ChangeDisplaySettingsExW", "Ptr", devPtr, "Ptr", chosen, "Ptr", 0, "UInt", 0x01, "Ptr", 0, "Int")
    if (ret = 0)
        Flash(targetW "x" targetH " @ " NumGet(chosen, 184, "UInt") " Hz")
    else
        Flash("Switch failed (code " ret ")")
}

PrimaryPtr() {
    static name := ""
    name := GetPrimaryDeviceName()
    return (name = "") ? 0 : StrPtr(name)
}

GetPrimaryDeviceName() {
    i := 0
    Loop {
        dd := Buffer(840, 0)
        NumPut("UInt", 840, dd, 0)
        if !DllCall("EnumDisplayDevicesW", "Ptr", 0, "UInt", i, "Ptr", dd, "UInt", 0, "Int")
            break
        i += 1
        if (NumGet(dd, 324, "UInt") & 0x4)
            return StrGet(dd.Ptr + 4, 32, "UTF-16")
    }
    return ""
}

Flash(msg) {
    ToolTip(msg)
    SetTimer(() => ToolTip(), -1800)
}
