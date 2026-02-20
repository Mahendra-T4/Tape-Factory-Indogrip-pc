[Setup]
AppName=IndoGrip
AppVersion=1.0.0
DefaultDirName={pf}\IndoGrip
DefaultGroupName=IndoGrip
OutputDir=installer
OutputBaseFilename=IndoGrip_Installer
Compression=lzma
SolidCompression=yes
SignTool=signtool sign /fd SHA256 /sha1 FF0BF3948354CACB45D5C37143A5C2410DCD16EE $f

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\IndoGrip"; Filename: "{app}\indogrip.exe"

[Run]
Filename: "{app}\indogrip.exe"; Description: "Launch IndoGrip"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
begin
  // Check for VC++ Redist
  if not RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64') then
  begin
    MsgBox('Microsoft Visual C++ Redistributable is required. Please install it from https://aka.ms/vs/17/release/vc_redist.x64.exe', mbInformation, MB_OK);
    Result := False;
  end
  else
    Result := True;
end;