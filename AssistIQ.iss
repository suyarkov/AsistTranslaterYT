[Setup]
AppName=AssistIQ
AppVersion=0.0.1.01
WizardStyle=modern
DefaultDirName={autopf}\AssistIQ
DefaultGroupName=AssistIQ
UninstallDisplayIcon={app}\AssistIQ.exe
Compression=lzma2
SolidCompression=yes
OutputDir=userdocs:Inno Setup Examples Output

[Files]
Source: "D:\Tmp\Dlf\AsistTranslaterYT\GudVersion\AssistIQ.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Tmp\Dlf\AsistTranslaterYT\GudVersion\libast32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Tmp\Dlf\AsistTranslaterYT\GudVersion\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Tmp\Dlf\AsistTranslaterYT\GudVersion\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion




[Icons]
Name: "{group}\AssistIQ"; Filename: "{app}\AssistIQ.exe"





