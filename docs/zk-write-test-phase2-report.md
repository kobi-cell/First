# דוח בדיקת כתיבה מפוקחת — שער פאזה 2

**תאריך:** 2026-08-06
**מבצע:** קובי — נוכח פיזית ליד הדלת לאורך כל הבדיקה
**שרת:** 192.168.128.50 (שרת ZKAccess)
**בקר:** C400 N18 W3 — 192.168.128.249
**דלת נבדקת:** `C400 N18 W3-4` (יציאה 4) = משרד 47
**צ'יפ בדיקה:** 0008075371 — צ'יפ רזרבי שאינו משויך לאיש
**כלי:** `zk-write-test.ps1`

---

## תוצאה: ✅ עבר במלואו

הבקר חזר בדיוק למצב שבו נמצא. מוני הרשומות בביקורת הסופית זהים לבסיס:
**55 משתמשים / 57 הרשאות.**

המעגל נסגר במלואו: כתבנו ← הבקר אכף פיזית ← מחקנו ← האכיפה בוטלה ← לא נשאר זבל.

---

## פרטי הבקר

| שדה | ערך |
|---|---|
| מספר סידורי | DGD0330010080710176 |
| קושחה | AC Ver 4.3.4 Apr 27 2017 |
| מספר דלתות | 4 (`LockCount=4`) |
| שדות משתמש | `CardNo,Pin,Password,Group,StartTime,EndTime,SuperAuthorize` |
| אזור זמן 1 | קיים (מעבר חופשי 24 שעות) |
| קישוריות | TCP 4370 פתוח מ-192.168.128.50 |

**בסיס לפני הבדיקה:** 55 משתמשים, 57 הרשאות, 3 אזורי זמן.

---

## מהלך הבדיקה ותוצאות

| # | פעולה | תוצאה |
|---|---|---|
| 1 | `info` | ✅ 55 / 57 / 3 — אזור זמן 1 קיים |
| 2 | `open -Door 4` | ✅ מנעול משרד 47 שוחרר ל-5 שניות (`ret=0`) |
| 3 | `add -Door 4 -TestCard 8075371` | ✅ נכתבו רשומת משתמש ורשומת הרשאה |
| 3א | הצמדת הצ'יפ — משרד 47 | ✅ **הדלת נפתחה** |
| 3ב | הצמדת הצ'יפ — משרד 48 | ✅ **סורב** |
| 4 | `verify` | ✅ שתי הרשומות נקראו חזרה מהבקר |
| 5 | `remove -Door 4` | ✅ נמחק, קריאה חוזרת נקייה |
| 5א | הצמדת הצ'יפ — משרד 47 | ✅ **סורב** |
| 6 | `audit` | ✅ 55 / 57 — זהה לבסיס |

שלב 3ב הוא הראיה שההרשאה מתוחמת ליציאה בודדת ולא נפתחת לרוחב הבקר.
שלב 5א הוא הראיה שהמחיקה נאכפת בחומרה, לא רק ברמת הנתונים — אותו צ'יפ פתח את
הדלת דקה קודם לכן.

**רשומות כפי שהבקר החזיק אותן (`verify`):**

```
user header:  CardNo,Pin,Password,Group,StartTime,EndTime,SuperAuthorize
user row:     8075371,9990001,,0,0,0,0
auth header:  Pin,AuthorizeTimezoneId,AuthorizeDoorId
auth row:     9990001,1,8
```

---

## ממצאים לשלב הבא (רישום כרטיסים אמיתיים)

### 1. `AuthorizeDoorId` היא מסכת ביטים, לא מספר דלת

ביקשנו דלת 4 והבקר שמר **8**. הקידוד הוא `2^(door-1)`:

| דלת | ערך בשדה |
|---|---|
| 1 | 1 |
| 2 | 2 |
| 3 | 4 |
| 4 | 8 |

כמה דלתות ברשומה אחת = OR בין הביטים (דלתות 1 ו-4 יחד = 9).

**זה הממצא הקריטי ביותר.** קוד שיתייחס לשדה כאינדקס דלת יעניק הרשאות שגויות
באופן שקט — ערך 4 יפתח את דלת 3 במקום את דלת 4. שווה כיסוי בבדיקה אוטומטית.

### 2. הבקר מנרמל מספרי כרטיס ומוריד אפסי פתיחה

כתבנו `0008075371`, והבקר החזיר בקריאה `8075371`. הנרמול מתבצע בצד הבקר — לא
ב-PowerShell ולא בסקריפט. כל השוואת מספרי כרטיס בקוד חייבת לנרמל את שני הצדדים
לפני ההשוואה, אחרת רשומות זהות ייראו שונות.

### 3. מספר הכרטיס המודפס אינו בהכרח מה שהבקר מחזיק

צירוף שני הדברים — טעות הקלדה בספרה אחת פלוס נרמול האפסים — הפך שגיאה של תו
אחד לשני מסלולי כישלון נפרדים. שווה שהמערכת תציג בממשק את המספר **כפי שהבקר
מחזיק אותו**, לא כפי שהוזן.

---

## באגים ב-`zk-write-test.ps1`

> **סטטוס:** כל הבאגים למטה תוקנו. הגרסה המתוקנת נמצאת ב-`scripts/doors/zk-write-test.ps1`
> באותו PR. התיקונים לא נבדקו מול בקר אמיתי — אין גישה לחומרה מסביבת הפיתוח —
> ולכן יש להריץ `info` ואז מחזור `add`/`verify`/`remove`/`audit` מלא לפני שסומכים עליהם.

### באג 1 — הגנת הבעלות ב-`remove` משווה מחרוזות בלי לנרמל

הסקריפט כתב `000807537`, הבקר שמר `807537`, ואז הסקריפט סירב למחוק את הרשומה
שהוא עצמו יצר שניות קודם לכן:

```
[FAIL] Pin 9990001 on the panel carries card '807537', not our test card
       '000807537' - REFUSING to delete (this may be a real person)
```

זו עצירה מלאה באמצע הבדיקה. ההגנה עצמה נכונה ורצויה — רק ההשוואה שגויה.
**תיקון:** לנרמל את שני הצדדים לפני ההשוואה (למשל `.TrimStart('0')` או המרה
למספר), במקום להשוות מחרוזות גולמיות.

### באג 2 — הסקריפט משנה את תיקיית העבודה ולא מחזיר אותה

אחרי כל ריצה ה-prompt נשאר ב-`C:\zk-bridge\sdk`, ולכן הפקודה הבאה בצורת
`.\zk-write-test.ps1` נכשלת ב-`CommandNotFoundException`. זה בדיוק מה שהמדריך
מנחה להקליד, אז זה יקרה לכל מי שיריץ אותו.
**תיקון:** `Push-Location`/`Pop-Location` סביב טעינת ה-SDK, או עדיף
`SetDllDirectory` כדי לא לגעת בתיקיית העבודה כלל.

### באג 3 — אותו באג נרמול בהגנת ה-`add`, והפעם הוא חור בטיחות

השורה שבדקה אם הכרטיס כבר קיים על הבקר סרקה בביטוי רגולרי את **כל שורת ה-CSV**
אחרי המחרוזת הגולמית:

```powershell
$cardHits = @($all.Rows | Where-Object { $_ -match ("(^|,)" + [regex]::Escape($TestCard) + "(,|$)") })
```

שתי בעיות. ראשית, אותו כשל נרמול: כרטיס שנשמר בבקר כ-`8075371` לא יזוהה כשמזינים
`0008075371`, ולכן **ההגנה תאשר רישום כרטיס שכבר משויך לעובד אמיתי**. שנית,
החיפוש רץ על כל העמודות ולא על `CardNo` בלבד, כך שערך זהה בעמודה אחרת ייצור
התאמת שווא.

זו החמורה מבין השלוש — היא לא עוצרת את המפעיל כמו באג 1, אלא מוותרת בשקט על
הגנה שכל התהליך נשען עליה.

### מה שהתברר כלא-באג

בגרסה הראשונה של הדוח שיערתי ש-`-Door` בברירת מחדל עלול להשאיר רשומת הרשאה
יתומה ב-`remove`. **קריאת הקוד מפריכה את זה:** `remove` מוחק לפי `Pin=$TestPin`
בשתי הטבלאות ואינו משתמש ב-`-Door` כלל. ההשערה נבעה מהפלט (`door=1` בשורת
הכותרת) ולא מהקוד. אין כאן בעיה, ואין צורך להעביר `-Door` ל-`remove`.

### חיזוקים נוספים שנכללו בתיקון

**`-TestCard` באפסים בלבד נחסם.** נובע מהתיקון עצמו: `0000` היה מתנרמל לאותו ערך
כמו `CardNo` ריק, ואז הגנת הבעלות ב-`remove` הייתה מקבלת רשומה של עובד עם PIN
בלבד וללא כרטיס כ"שלנו". הנרמול מחזיר מחרוזת ריקה עבור כרטיס ריק, וכרטיס בדיקה
חייב עכשיו להכיל לפחות ספרה אחת שאינה אפס — כך ששני המקרים לעולם לא נפגשים.

**הודעת השגיאה של 64-ביט מחזירה את כל הפרמטרים.** קודם היא הדפיסה רק `-Ip`
ו-`-Action`. מפעיל שהעתיק אותה איבד את `-SdkDir` ואת `-TestCard` ונפל מיד בשגיאה
הבאה — בדיוק מה שקרה בשטח.

### הערה 4 — `-SdkDir` נדרש על השרת הזה

ה-SDK לא היה ליד הסקריפט. הועתק אל `C:\zk-bridge\sdk` מתוך
`C:\Users\Print Server\Downloads\ZKAccess_3.5.3.15(1)\NewSDK\` — **התיקייה
המלאה**, כי `plcommpro.dll` נכשל בטעינה בלי ה-DLL-ים הנלווים
(`plcomms`, `pltcpcomm`, `plrscomm`, `rscagent`, `tcpcomm`, `commpro` ואחרים),
עם שגיאת "קובץ לא נמצא" מטעה. שווה לבדוק ב-`NewSDK` ולא בעותק הישן שתחת
`Tools\Tool for Managing Device\` (2012, 96KB מול 253KB).

---

## הכנת סביבה שנדרשה (לתיעוד — לשרת הבא)

שלוש חסימות לפני שהסקריפט רץ בכלל:

1. **מדיניות הרצה** — `Restricted`. נפתר עם
   `powershell -ExecutionPolicy Bypass -File ...`
2. **PowerShell 64-ביט** — ה-SDK הוא 32-ביט. חובה
   `C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe`
   (הסקריפט מזהה ועוצר עם הודעה נכונה)
3. **`plcommpro.dll` חסר** — ראה הערה 4 לעיל

---

## אירועים במהלך הבדיקה

**טעות במספר הכרטיס.** ההרצה הראשונה של `add` נעשתה עם `000807537` — חסרה הספרה
האחרונה. הצ'יפ נסרב בקורא (צפצוף, ללא פתיחה), מה שאישר בדרך אגב שהקורא תקין
ושהבקר הוא זה שדוחה. תוקן ל-`8075371` וההרצה השנייה עברה.

**כניסת עובד באמצע.** נדב, עובד עם הרשאה לדלת, נכנס זמן קצר אחרי פקודת `open`.
אומת שהגיע **אחרי** שהדלת כבר נפתחה מהפקודה — כלומר אישור מיפוי הדלת תקף ולא
מיוחס בטעות להצמדה שלו. רשומתו לא נגעה בשום שלב.

**נורית אדומה מהבהבת בכל הקוראים.** זוהתה כמצב המתנה רגיל ולא כתקלה — צ'יפ של
עובד וצ'יפ הבדיקה שניהם פתחו דלתות באותו זמן.

---

## פתוח לסגירה

- [ ] **לוודא שמשרד 48 יושב על אותו בקר** (C400 N18 W3). אם כן — בדיקת התיחום
      חתומה. אם הוא על בקר אחר, הסירוב מובן מאליו ולא מוכיח תיחום; יש להצמיד
      ביציאה `W3-1`, `W3-2` או `W3-3` כדי לסגור.
- [ ] **לאמת ביומן `/doors`** שאירועי ההצמדה של כרטיס `8075371` נקלטו. זו
      ההוכחה שגשר הקריאה סוגר את המעגל מקצה לקצה.

---

## המלצה

הבדיקה עברה במלואה: כתיבה, אכיפה, תיחום לדלת בודדת, מחיקה, וחזרה מדויקת למצב
ההתחלתי. **ניתן להדליק את דגל הכתיבה עבור הבקר הזה.**

לפני פיתוח רישום כרטיסים אמיתיים יש לטפל בשני ממצאי הקידוד (מסכת הביטים ונרמול
מספרי הכרטיס) — שניהם שקטים באופיים ויפגעו בהרשאות אמיתיות בלי להשמיע קול.

---

## נספח — תמליל מלא

התמליל המקומי נשמר גם ב-`%TEMP%\zk-write-test.log` על השרת.

```
PS C:\WINDOWS\system32> cd C:\zk-bridge
PS C:\zk-bridge> .\zk-write-test.ps1 -Ip 192.168.128.249 -Action info
.\zk-write-test.ps1 : File C:\zk-bridge\zk-write-test.ps1 cannot be loaded because running scripts is disabled on this
system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess

PS C:\zk-bridge> .\zk-write-test.ps1 -Ip 192.168.128.249 -Action info
[FAIL] plcommpro.dll not found - pass -SdkDir

PS C:\zk-bridge> $roots = 'C:\zk-bridge', 'C:\Program Files (x86)', "$env:USERPROFILE\Downloads", "$env:USERPROFILE\Desktop"
PS C:\zk-bridge> foreach ($r in $roots) { ... Get-ChildItem $r -Filter plcommpro.dll -Recurse ... }

FullName                                                                                          Length LastWriteTime
--------                                                                                          ------ -------------
C:\Users\Print Server\Downloads\ZKAccess_3.5.3.15(1)\NewSDK\plcommpro.dll                         253952 12/28/2017
C:\Users\Print Server\Downloads\ZKAccess_3.5.3.15(1)\Tools\Tool for Managing Device\plcommpro.dll  96256 12/27/2012

PS C:\zk-bridge> New-Item -ItemType Directory -Force -Path C:\zk-bridge\sdk | Out-Null
PS C:\zk-bridge> Copy-Item -Path "C:\Users\Print Server\Downloads\ZKAccess_3.5.3.15(1)\NewSDK\*" -Destination C:\zk-bridge\sdk -Recurse -Force
PS C:\zk-bridge> Get-ChildItem C:\zk-bridge\sdk -File | Select-Object Name, Length

Name                Length
----                ------
commpro.dll         168448
comms.dll            89600
CopyAndRegister.bat    401
Delete_SDK.bat        1184
libzklog.dll        139776
plcommpro.dll       253952
plcomms.dll          91136
plrscagent.dll      161280
plrscomm.dll        547840
pltcpcomm.dll       121344
plusbcomm.dll        55808
Register_SDK.bat       280
rscagent.dll        161792
rscomm.dll          543744
tcpcomm.dll         117760
usbcomm.dll         146944
usbstd.dll           43008
zkemkeeper.dll      788480
zkemsdk.dll         377344

PS C:\zk-bridge> Unblock-File C:\zk-bridge\sdk\*
PS C:\zk-bridge> .\zk-write-test.ps1 -Ip 192.168.128.249 -Action info -SdkDir "C:\zk-bridge\sdk"
=== zk-write-test: action=info panel=192.168.128.249 door=1 pin=9990001 card= ===
[OK] Connected to 192.168.128.249 (handle=159809656)
[OK] Params: ~SerialNumber=DGD0330010080710176,FirmVer=AC Ver 4.3.4 Apr 27 2017,LockCount=4
[i] user records:           55
[i] userauthorize records:  57
[i] timezone records:       3
[i] user fields on THIS panel: CardNo,Pin,Password,Group,StartTime,EndTime,SuperAuthorize
[OK] timezone id 1 exists (the default 24h pass) - userauthorize can use it
[DONE] info - panel is readable; note the user count for the final audit

PS C:\zk-bridge\sdk> Test-NetConnection 192.168.128.249 -Port 4370
ComputerName     : 192.168.128.249
RemoteAddress    : 192.168.128.249
RemotePort       : 4370
InterfaceAlias   : Ethernet 2
SourceAddress    : 192.168.128.50
TcpTestSucceeded : True

PS C:\zk-bridge\sdk> .\zk-write-test.ps1 -Ip 192.168.128.226 -Action info
.\zk-write-test.ps1 : The term '.\zk-write-test.ps1' is not recognized as the name of a cmdlet, function, script file,
or operable program.
    + CategoryInfo          : ObjectNotFound: (.\zk-write-test.ps1:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.226 -Action info -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=info panel=192.168.128.226 door=1 pin=9990001 card= ===
[OK] Connected to 192.168.128.226 (handle=159812752)
[OK] Params: ~SerialNumber=DGD9180019042010792,FirmVer=AC Ver 4.3.4 Apr 27 2017,LockCount=4
[i] user records:           106
[i] userauthorize records:  168
[i] timezone records:       3
[DONE] info - panel is readable; note the user count for the final audit

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action info -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=info panel=192.168.128.249 door=1 pin=9990001 card= ===
[OK] Connected to 192.168.128.249 (handle=159812752)
[OK] Params: ~SerialNumber=DGD0330010080710176,FirmVer=AC Ver 4.3.4 Apr 27 2017,LockCount=4
[i] user records:           55
[i] userauthorize records:  57
[i] timezone records:       3
[OK] timezone id 1 exists (the default 24h pass) - userauthorize can use it
[DONE] info - panel is readable; note the user count for the final audit

PS C:\zk-bridge\sdk> Select-String -Path C:\zk-bridge\zk-write-test.ps1 -Pattern 'ValidateSet|\[Parameter' -Context 0,4
> C:\zk-bridge\zk-write-test.ps1:38:  [Parameter(Mandatory=$true)][string]$Ip,
> C:\zk-bridge\zk-write-test.ps1:39: [Parameter(Mandatory=$true)][ValidateSet("info","open","add","verify","remove","audit")][string]$Action,
  C:\zk-bridge\zk-write-test.ps1:40:  [int]$Door = 1,
  C:\zk-bridge\zk-write-test.ps1:41:  [string]$TestCard = "",
  C:\zk-bridge\zk-write-test.ps1:42:  [string]$TestPin = "9990001",
  C:\zk-bridge\zk-write-test.ps1:43:  [int]$OpenSeconds = 5,

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action add -SdkDir C:\zk-bridge\sdk
[FAIL] -TestCard is mandatory for add/verify/remove (use a spare chip that belongs to NOBODY)

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action open -Door 4 -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=open panel=192.168.128.249 door=4 pin=9990001 card= ===
[OK] Connected to 192.168.128.249 (handle=159811720)
[i] Remote-opening door 4 for 5 seconds (transient - no state change)...
[OK] ControlDevice accepted (ret=0). Kobi: did the lock click open? Note it.
[DONE] open
  --> קובי: דלת משרד 47 נפתחה בפועל.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action add -Door 4 -TestCard "000807537" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=add panel=192.168.128.249 door=4 pin=9990001 card=000807537 ===
[OK] Connected to 192.168.128.249 (handle=159811720)
[OK] user record written (Pin=9990001 Card=000807537)
[OK] userauthorize written (door 4, timezone 1)
[DONE] add - run -Action verify next
  --> קובי: הצמדה נסרבה (צפצוף, ללא פתיחה). מספר הכרטיס שהוזן היה שגוי - חסרה ספרה.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action verify -TestCard "000807537" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=verify panel=192.168.128.249 door=1 pin=9990001 card=000807537 ===
[i] user header:    CardNo,Pin,Password,Group,StartTime,EndTime,SuperAuthorize
[i] user row:       807537,9990001,,0,0,0,0
[i] auth header:    Pin,AuthorizeTimezoneId,AuthorizeDoorId
[i] auth row:       9990001,1,8
[OK] both records present on the panel
[DONE] verify
  --> כאן נראה לראשונה שהבקר הוריד את אפסי הפתיחה: נכתב 000807537, נשמר 807537.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action remove -TestCard "000807537" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=remove panel=192.168.128.249 door=1 pin=9990001 card=000807537 ===
[FAIL] Pin 9990001 on the panel carries card '807537', not our test card '000807537' - REFUSING to delete (this may be a real person)
  --> באג 1: ההגנה סירבה למחוק רשומה שהסקריפט עצמו כתב.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action add -Door 4 -TestCard "0008075371" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=add panel=192.168.128.249 door=4 pin=9990001 card=0008075371 ===
[FAIL] Pin 9990001 already exists on the panel - pick another -TestPin

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action remove -Door 4 -TestCard "807537" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=remove panel=192.168.128.249 door=4 pin=9990001 card=807537 ===
[OK] ownership verified: Pin 9990001 carries our test card 807537
[i] DeleteDeviceData(userauthorize) ret=0
[i] DeleteDeviceData(user) ret=0
[OK] read-back clean - the test identity is fully gone
[DONE] remove

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action add -Door 4 -TestCard "8075371" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=add panel=192.168.128.249 door=4 pin=9990001 card=8075371 ===
[OK] Connected to 192.168.128.249 (handle=159952832)
[OK] user record written (Pin=9990001 Card=8075371)
[OK] userauthorize written (door 4, timezone 1)
[DONE] add - run -Action verify next
  --> קובי: דלת משרד 47 נפתחה. דלת משרד 48 סורבה.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action verify -TestCard "8075371" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=verify panel=192.168.128.249 door=1 pin=9990001 card=8075371 ===
[i] user header:    CardNo,Pin,Password,Group,StartTime,EndTime,SuperAuthorize
[i] user row:       8075371,9990001,,0,0,0,0
[i] auth header:    Pin,AuthorizeTimezoneId,AuthorizeDoorId
[i] auth row:       9990001,1,8
[OK] both records present on the panel
[DONE] verify

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action remove -Door 4 -TestCard "8075371" -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=remove panel=192.168.128.249 door=4 pin=9990001 card=8075371 ===
[OK] ownership verified: Pin 9990001 carries our test card 8075371
[i] DeleteDeviceData(userauthorize) ret=0
[i] DeleteDeviceData(user) ret=0
[OK] read-back clean - the test identity is fully gone
[DONE] remove
  --> קובי: הצמדה בדלת משרד 47 נסרבה.

PS C:\zk-bridge\sdk> C:\zk-bridge\zk-write-test.ps1 -Ip 192.168.128.249 -Action audit -SdkDir C:\zk-bridge\sdk
=== zk-write-test: action=audit panel=192.168.128.249 door=1 pin=9990001 card= ===
[OK] Connected to 192.168.128.249 (handle=159953864)
[i] user records:          55
[i] userauthorize records: 57
[i] Compare with the counts from -Action info. Identical = the panel is exactly as we found it.
[DONE] audit
  --> זהה לבסיס. הבקר בדיוק כפי שנמצא.
```

**הערה:** התמליל כולל קריאת `info` אחת לבקר 192.168.128.226 שבוצעה בטעות בתחילת
הסשן. היא קריאה בלבד — לא בוצעה שום כתיבה לבקר הזה, והוא מחוץ להיקף הבדיקה.
