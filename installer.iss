; =====================================================================
; Inno Setup Script for "دواجن الشمس" (Elshams Poultry) Desktop App
; =====================================================================

#define MyAppName "دواجن الشمس"
#define MyAppNameEn "Elshams Poultry"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Yousef Sallam"
#define MyAppExeName "elshams.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
AppId={{A82F4102-1254-4C79-8802-985A48F796C1}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\Elshams
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; 64-bit architecture configuration (Flutter Windows is 64-bit only)
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

; Output settings
OutputDir=C:\Users\Yousef\Desktop\App\work\elshams\installer
OutputBaseFilename=Elshams_Setup_v{#MyAppVersion}_x64
SetupIconFile=windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

; Modern styling and maximum compression
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern

; Privileges required for Program Files installation
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Main application files and bundled assets from the Release build
Source: "build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
