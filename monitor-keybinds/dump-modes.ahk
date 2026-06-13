#Requires AutoHotkey v2.0
; Diagnostic v2: every display device + monitor name + 720p modes (normal & raw)
out := "C:\Users\Clock\Scripts\modes.txt"
s := ""

ai := 0
Loop {
    ad := Buffer(840, 0)
    NumPut("UInt", 840, ad, 0)
    if !DllCall("EnumDisplayDevicesW", "Ptr", 0, "UInt", ai, "Ptr", ad, "UInt", 0, "Int")
        break
    ai += 1
    adName := StrGet(ad.Ptr + 4,  32,  "UTF-16")
    adStr  := StrGet(ad.Ptr + 68, 128, "UTF-16")
    state  := NumGet(ad, 324, "UInt")
    tags   := ((state & 0x1) ? "ACTIVE " : "inactive ") . ((state & 0x4) ? "PRIMARY" : "")

    mon := Buffer(840, 0)
    NumPut("UInt", 840, mon, 0)
    monName := DllCall("EnumDisplayDevicesW", "Ptr", StrPtr(adName), "UInt", 0, "Ptr", mon, "UInt", 0, "Int")
               ? StrGet(mon.Ptr + 68, 128, "UTF-16") : ""

    s .= "=== " adName "  '" adStr "'  [" tags "]  monitor='" monName "' ===`r`n"
    devPtr := StrPtr(adName)

    cur := Buffer(220, 0)
    NumPut("UShort", 220, cur, 68)
    if DllCall("EnumDisplaySettingsW", "Ptr", devPtr, "Int", -1, "Ptr", cur, "Int")
        s .= "  CURRENT: " NumGet(cur,172,"UInt") "x" NumGet(cur,176,"UInt") " @ " NumGet(cur,184,"UInt") "Hz`r`n"

    for flagName, flagVal in Map("normal", 0, "raw", 2) {
        list720 := "", listUW := ""
        i := 0
        Loop {
            dm := Buffer(220, 0)
            NumPut("UShort", 220, dm, 68)
            if !DllCall("EnumDisplaySettingsExW", "Ptr", devPtr, "UInt", i, "Ptr", dm, "UInt", flagVal, "Int")
                break
            i += 1
            w := NumGet(dm,172,"UInt"), h := NumGet(dm,176,"UInt"), hz := NumGet(dm,184,"UInt"), bpp := NumGet(dm,168,"UInt")
            if (bpp < 32)
                continue
            if (w = 1280 && h = 720)
                list720 .= " " hz
            if (w = 3440 && h = 1440)
                listUW .= " " hz
        }
        s .= "  [" flagName "] 1280x720 Hz:" (list720 = "" ? " none" : list720) "   3440x1440 Hz:" (listUW = "" ? " none" : listUW) "`r`n"
    }
    s .= "`r`n"
}
try FileDelete(out)
FileAppend(s, out, "UTF-8")
MsgBox("Wrote " out, "Mode dump v2", "Iconi")
