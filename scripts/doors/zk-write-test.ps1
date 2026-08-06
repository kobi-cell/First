# ============================================================================
#  zk-write-test.ps1 - PHASE 2 GATE: supervised single-panel WRITE test.
#  Run ON the ZKAccess server (192.168.128.50), with Kobi PHYSICALLY at the
#  target door. This is the first time AIO-side tooling writes to a panel.
#
#  Design rules (why this tool is safe):
#    * Standalone - no AIO dependency; works even if the network to AIO is down.
#      The read-bridge will pick the badge events up anyway (proof in the log tab).
#    * Test identity only - writes a FRESH Pin that must NOT exist on the panel
#      (verified before writing). Never touches an existing person's record:
#      SetDeviceData REPLACES the whole record (omitted fields are blanked), so
#      the only safe first write is a brand-new record.
#    * Every action verifies itself (read-back) and appends to a local transcript.
#    * remove restores the panel exactly; 'audit' proves nothing was left behind.
#
#  Actions (run them in this order):
#    info    read-only: connect, device params, user/userauthorize/timezone counts,
#            field discovery (GetDeviceData first CSV line), timezone id 1 check
#    open    ControlDevice remote door release (transient; no state change)
#    add     write test user (Pin+Card) + userauthorize for ONE door -> badge it
#    verify  read back the test records from the panel
#    remove  delete the test records (both tables) + read-back proves gone
#    audit   count users before/after session (run after remove; must match info)
#
#  Run (32-bit PowerShell REQUIRED - the SDK is 32-bit):
#    & "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass `
#        -File .\zk-write-test.ps1 -Ip 192.168.128.226 -Action info
#    ... -Action open   -Door 1
#    ... -Action add    -Door 1 -TestCard 12345678
#    ... -Action verify -TestCard 12345678
#    ... -Action remove -TestCard 12345678
#
#  IMPORTANT: close the ZKAccess Real-Time Monitoring window first - the panel
#  serves one TCP client at a time; Connect fails while the GUI holds it.
#  The test card must be a spare chip that belongs to NOBODY.
#
#  PANEL BEHAVIOUR learned in the field (C400, AC Ver 4.3.4, 06/08):
#    * CardNo is stored as a NUMBER - leading zeros are dropped. Write 0008075371,
#      read back 8075371. Never compare card numbers as raw strings; the panel's
#      form is the authority. See Normalize-CardNo below.
#    * AuthorizeDoorId is a BITMASK, not a door index: door N -> 2^(N-1).
#      Door 4 is stored as 8. Doors 1+4 together would be 9.
#    * If the SDK does not sit beside the script or in the ZKAccess install dirs,
#      pass -SdkDir. plcommpro.dll needs its whole sibling set (plcomms,
#      pltcpcomm, plrscomm, rscagent, tcpcomm, commpro...) in the same folder;
#      a missing sibling reports as a misleading "file not found" on plcommpro.
# ============================================================================
param(
  [Parameter(Mandatory=$true)][string]$Ip,
  [Parameter(Mandatory=$true)][ValidateSet("info","open","add","verify","remove","audit")][string]$Action,
  [int]$Door = 1,
  [string]$TestCard = "",
  [string]$TestPin = "9990001",
  [int]$OpenSeconds = 5,
  [int]$Port = 4370,
  [string]$Passwd = "",
  [string]$SdkDir = ""
)

$ErrorActionPreference = "Stop"

# --- transcript: every supervised action is appended locally (audit trail) ---
$LogFile = Join-Path $env:TEMP "zk-write-test.log"
function Log([string]$msg) {
  $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
  Add-Content -Path $LogFile -Value $line -Encoding ASCII
  Write-Host $msg
}

if ([Environment]::Is64BitProcess) {
  # echo back EVERY argument that was passed - a hint that silently drops -SdkDir or
  # -TestCard sends the operator into the next failure (field finding 06/08)
  $again = "-Ip $Ip -Action $Action -Door $Door"
  if ($TestCard)          { $again += " -TestCard `"$TestCard`"" }
  if ($SdkDir)            { $again += " -SdkDir `"$SdkDir`"" }
  if ($TestPin -ne "9990001") { $again += " -TestPin `"$TestPin`"" }
  if ($OpenSeconds -ne 5) { $again += " -OpenSeconds $OpenSeconds" }
  if ($Port -ne 4370)     { $again += " -Port $Port" }
  Write-Host "[FAIL] 64-bit PowerShell - the SDK needs a 32-bit process. Run via:" -ForegroundColor Red
  Write-Host "       C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" $again"
  exit 1
}
if ($Door -lt 1 -or $Door -gt 4) { Write-Host "[FAIL] -Door must be 1-4" -ForegroundColor Red; exit 1 }
if ($OpenSeconds -lt 1 -or $OpenSeconds -gt 10) { Write-Host "[FAIL] -OpenSeconds must be 1-10 (safety cap)" -ForegroundColor Red; exit 1 }
if (($Action -in @("add","verify","remove")) -and -not $TestCard) {
  Write-Host "[FAIL] -TestCard is mandatory for add/verify/remove (use a spare chip that belongs to NOBODY)" -ForegroundColor Red; exit 1
}
if ($TestCard -and ($TestCard -notmatch '^[0-9]{4,12}$')) { Write-Host "[FAIL] -TestCard must be 4-12 digits" -ForegroundColor Red; exit 1 }
# an all-zeros card would normalize to the same value as a blank CardNo, and the remove
# ownership check would then accept a PIN-only employee's record as ours
if ($TestCard -and ($TestCard -notmatch '[1-9]')) { Write-Host "[FAIL] -TestCard cannot be all zeros" -ForegroundColor Red; exit 1 }
if ($TestPin -notmatch '^[0-9]{4,9}$') { Write-Host "[FAIL] -TestPin must be 4-9 digits" -ForegroundColor Red; exit 1 }

# --- locate the SDK (same candidates as the proven probe) ---
$candidates = @()
if ($SdkDir) { $candidates += $SdkDir }
$candidates += @("C:\ZKTeco\ZKAccess3.5", "C:\Program Files (x86)\ZKTeco\ZKAccess3.5", "C:\Program Files\ZKTeco\ZKAccess3.5", $PSScriptRoot)
$dir = $null
foreach ($d in $candidates) { if ($d -and (Test-Path (Join-Path $d "plcommpro.dll"))) { $dir = $d; break } }
if (-not $dir) { Write-Host "[FAIL] plcommpro.dll not found - pass -SdkDir" -ForegroundColor Red; exit 1 }
# plcommpro loads sibling DLLs (plcomms/pltcpcomm) from the current dir, so we must cd there -
# but remember where we came from and put it back on every exit path, otherwise the operator's
# next '.\zk-write-test.ps1' fails with CommandNotFound (field finding 06/08)
$OrigLocation = Get-Location
Set-Location $dir

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class PullSDK2 {
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern IntPtr Connect(string parameters);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall)]
  public static extern void Disconnect(IntPtr h);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall)]
  public static extern int PullLastError();
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int GetDeviceParam(IntPtr h, byte[] buffer, int bufferSize, string items);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int ControlDevice(IntPtr h, int operationId, int p1, int p2, int p3, int p4, string options);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int SetDeviceData(IntPtr h, string tableName, string data, string options);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int GetDeviceData(IntPtr h, byte[] buffer, int bufferSize, string tableName, string fieldNames, string filter, string options);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int DeleteDeviceData(IntPtr h, string tableName, string data, string options);
  [DllImport("plcommpro.dll", CallingConvention=CallingConvention.StdCall, CharSet=CharSet.Ansi)]
  public static extern int GetDeviceDataCount(IntPtr h, string tableName, string filter, string options);
}
"@

function Read-Table([IntPtr]$h, [string]$table, [string]$filter) {
  # returns @{ Header = "..."; Rows = @("csv","csv") } ; throws on SDK error
  $buf = New-Object byte[] (4 * 1024 * 1024)
  $n = [PullSDK2]::GetDeviceData($h, $buf, $buf.Length, $table, "*", $filter, "")
  if ($n -lt 0) { throw "GetDeviceData($table) failed ret=$n err=$([PullSDK2]::PullLastError())" }
  $txt = [System.Text.Encoding]::ASCII.GetString($buf).TrimEnd([char]0)
  $lines = @($txt -split "`r`n" | Where-Object { $_ -ne "" })
  if ($lines.Count -eq 0) { return @{ Header = ""; Rows = @() } }
  return @{ Header = $lines[0]; Rows = @($lines | Select-Object -Skip 1) }
}

function Normalize-CardNo([string]$c) {
  # The PANEL stores CardNo as a decimal number and drops leading zeros: write 0008075371,
  # read back 8075371 (field finding 06/08). Every card comparison must normalize BOTH sides
  # or identical cards look different - which broke the remove ownership check and, worse,
  # let the 'add' duplicate-card guard miss a card that is already on the panel.
  # A blank CardNo (PIN-only user) normalizes to "" and must never equal a real test card -
  # -TestCard is separately forbidden from being all zeros, so no valid card maps to "".
  if ([string]::IsNullOrWhiteSpace($c)) { return "" }
  $t = $c.Trim().TrimStart('0')
  if ($t -eq "") { $t = "0" }
  return $t
}

function Get-ColumnIndex([string]$header, [string]$column) {
  return [array]::IndexOf(($header -split ","), $column)
}

function Count-Table([IntPtr]$h, [string]$table) {
  $c = [PullSDK2]::GetDeviceDataCount($h, $table, "", "")
  if ($c -lt 0) { throw "GetDeviceDataCount($table) failed ret=$c err=$([PullSDK2]::PullLastError())" }
  return $c
}

Log "=== zk-write-test: action=$Action panel=$Ip door=$Door pin=$TestPin card=$TestCard ==="
$connstr = "protocol=TCP,ipaddress=$Ip,port=$Port,timeout=4000,passwd=$Passwd"
$h = [PullSDK2]::Connect($connstr)
if ($h -eq [IntPtr]::Zero) {
  Log "[FAIL] Connect failed (PullLastError=$([PullSDK2]::PullLastError())). Is the ZKAccess Real-Time Monitoring window open? Close it and retry."
  Set-Location $OrigLocation
  exit 2
}
Log "[OK] Connected to $Ip (handle=$h)"

try {
  switch ($Action) {

    "info" {
      # return value is a STATUS (0=ok/<0=fail), not a byte length (review finding 06/08) -
      # decode the whole zero-initialized buffer and trim, like Read-Table does
      $buf = New-Object byte[] 4096
      $n = [PullSDK2]::GetDeviceParam($h, $buf, $buf.Length, "~SerialNumber,FirmVer,LockCount")
      if ($n -ge 0) { Log ("[OK] Params: " + [System.Text.Encoding]::ASCII.GetString($buf).TrimEnd([char]0)) }
      Log ("[i] user records:           " + (Count-Table $h "user"))
      Log ("[i] userauthorize records:  " + (Count-Table $h "userauthorize"))
      Log ("[i] timezone records:       " + (Count-Table $h "timezone"))
      $uf = Read-Table $h "user" ""
      Log ("[i] user fields on THIS panel: " + $uf.Header)
      $tz = Read-Table $h "timezone" "TimezoneId=1"
      if ($tz.Rows.Count -ge 1) { Log "[OK] timezone id 1 exists (the default 24h pass) - userauthorize can use it" }
      else { Log "[WARN] timezone id 1 NOT found - do NOT run 'add' before checking the timezone table" }
      Log "[DONE] info - panel is readable; note the user count for the final audit"
    }

    "open" {
      Log "[i] Remote-opening door $Door for $OpenSeconds seconds (transient - no state change)..."
      $r = [PullSDK2]::ControlDevice($h, 1, $Door, 1, $OpenSeconds, 0, "")
      if ($r -lt 0) { Log "[FAIL] ControlDevice ret=$r err=$([PullSDK2]::PullLastError())"; exit 3 }
      Log "[OK] ControlDevice accepted (ret=$r). Kobi: did the lock click open? Note it."
      Log "[DONE] open"
    }

    "add" {
      # SAFETY: refuse if the test Pin or the test card already exist on the panel
      $existingPin = Read-Table $h "user" "Pin=$TestPin"
      if ($existingPin.Rows.Count -gt 0) { Log "[FAIL] Pin $TestPin already exists on the panel - pick another -TestPin"; exit 3 }
      $all = Read-Table $h "user" ""
      if ($all.Rows.Count -gt 0) {
        # match on the CardNo COLUMN and on NORMALIZED values. The old check regex-scanned the
        # whole CSV row for the raw string, so '0008075371' never matched a panel-stored
        # '8075371' - the guard would wave through a card already issued to a real person.
        $cardIdx = Get-ColumnIndex $all.Header "CardNo"
        if ($cardIdx -lt 0) { Log "[FAIL] cannot locate CardNo column in: $($all.Header) - refusing to write blind"; exit 3 }
        $wantCard = Normalize-CardNo $TestCard
        $cardHits = @($all.Rows | Where-Object { (Normalize-CardNo (($_ -split ",")[$cardIdx])) -eq $wantCard })
        if ($cardHits.Count -gt 0) {
          $storedAs = ($cardHits[0] -split ",")[$cardIdx]
          Log "[FAIL] Card $TestCard already exists on the panel (stored as '$storedAs') - use a spare chip that belongs to NOBODY"
          exit 3
        }
      }

      $mask = 1 -shl ($Door - 1)   # door bitmask: door1=1 door2=2 door3=4 door4=8
      $userRec = "CardNo=$TestCard`tPin=$TestPin`tPassword=`tStartTime=0`tEndTime=0`r`n"
      $authRec = "Pin=$TestPin`tAuthorizeTimezoneId=1`tAuthorizeDoorId=$mask`r`n"

      $r1 = [PullSDK2]::SetDeviceData($h, "user", $userRec, "")
      if ($r1 -lt 0) { Log "[FAIL] SetDeviceData(user) ret=$r1 err=$([PullSDK2]::PullLastError())"; exit 3 }
      Log "[OK] user record written (Pin=$TestPin Card=$TestCard)"
      $r2 = [PullSDK2]::SetDeviceData($h, "userauthorize", $authRec, "")
      if ($r2 -lt 0) {
        Log "[FAIL] SetDeviceData(userauthorize) ret=$r2 err=$([PullSDK2]::PullLastError()) - rolling back the user record"
        $rb = [PullSDK2]::DeleteDeviceData($h, "user", "Pin=$TestPin", "")
        Log ("[i] rollback DeleteDeviceData(user) ret=" + $rb)
        exit 3
      }
      Log "[OK] userauthorize written (door $Door, timezone 1)"
      Log ">>> Kobi: badge the TEST card on door $Door NOW. It must open."
      Log ">>> Then badge it on a DIFFERENT door of this panel. It must NOT open."
      Log "[DONE] add - run -Action verify next"
    }

    "verify" {
      $u = Read-Table $h "user" "Pin=$TestPin"
      $a = Read-Table $h "userauthorize" "Pin=$TestPin"
      Log ("[i] user header:    " + $u.Header)
      foreach ($row in $u.Rows) { Log ("[i] user row:       " + $row) }
      Log ("[i] auth header:    " + $a.Header)
      foreach ($row in $a.Rows) { Log ("[i] auth row:       " + $row) }
      if ($u.Rows.Count -eq 1 -and $a.Rows.Count -ge 1) { Log "[OK] both records present on the panel" }
      else { Log "[WARN] expected 1 user + 1 authorize record - got $($u.Rows.Count)/$($a.Rows.Count)" }
      Log "[DONE] verify"
    }

    "remove" {
      # OWNERSHIP CHECK (review finding 06/08): delete ONLY if the Pin's record carries OUR
      # test card. A mistyped -TestPin matching a real employee must never be deletable here.
      $u0 = Read-Table $h "user" "Pin=$TestPin"
      if ($u0.Rows.Count -eq 0) {
        $a0 = Read-Table $h "userauthorize" "Pin=$TestPin"
        if ($a0.Rows.Count -eq 0) { Log "[OK] nothing to remove - Pin $TestPin has no records on this panel"; break }
        Log "[i] user record already gone; removing the leftover authorize record for Pin $TestPin"
      } else {
        $cardIdx = Get-ColumnIndex $u0.Header "CardNo"
        if ($cardIdx -lt 0) { Log "[FAIL] cannot locate CardNo column in: $($u0.Header) - refusing to delete blind"; exit 3 }
        $rowCard = ($u0.Rows[0] -split ",")[$cardIdx]
        # compare NORMALIZED - the panel drops leading zeros, so a raw compare made this guard
        # refuse to delete the very record this script had written seconds earlier. The guard
        # itself stays exactly as strict: two genuinely different cards still fail to match.
        if ((Normalize-CardNo $rowCard) -ne (Normalize-CardNo $TestCard)) {
          Log "[FAIL] Pin $TestPin on the panel carries card '$rowCard', not our test card '$TestCard' - REFUSING to delete (this may be a real person)"
          exit 3
        }
        Log "[OK] ownership verified: Pin $TestPin carries our test card $TestCard (panel stores it as '$rowCard')"
      }
      $r1 = [PullSDK2]::DeleteDeviceData($h, "userauthorize", "Pin=$TestPin", "")
      Log ("[i] DeleteDeviceData(userauthorize) ret=" + $r1)
      $r2 = [PullSDK2]::DeleteDeviceData($h, "user", "Pin=$TestPin", "")
      Log ("[i] DeleteDeviceData(user) ret=" + $r2)
      if ($r1 -lt 0 -or $r2 -lt 0) { Log "[FAIL] delete failed err=$([PullSDK2]::PullLastError()) - DO NOT leave the panel like this; retry"; exit 3 }
      $u = Read-Table $h "user" "Pin=$TestPin"
      $a = Read-Table $h "userauthorize" "Pin=$TestPin"
      if ($u.Rows.Count -eq 0 -and $a.Rows.Count -eq 0) { Log "[OK] read-back clean - the test identity is fully gone" }
      else { Log "[FAIL] read-back still finds $($u.Rows.Count) user / $($a.Rows.Count) auth rows - retry remove"; exit 3 }
      Log ">>> Kobi: badge the TEST card again. It must be DENIED now."
      Log "[DONE] remove"
    }

    "audit" {
      Log ("[i] user records:          " + (Count-Table $h "user"))
      Log ("[i] userauthorize records: " + (Count-Table $h "userauthorize"))
      Log "[i] Compare with the counts from -Action info. Identical = the panel is exactly as we found it."
      Log "[DONE] audit"
    }
  }
} finally {
  [PullSDK2]::Disconnect($h)
  Log "[i] Disconnected. Transcript: $LogFile"
  Set-Location $OrigLocation
}
