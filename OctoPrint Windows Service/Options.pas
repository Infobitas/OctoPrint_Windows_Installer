unit Options;

interface
uses
  Classes, Forms, SysUtils;


type


 TOptions = class
  //--- Optional ---
  ServiceName:String;
  ServicePath:String;
  ServiceParameters:String;
  WorkDir:String;

  constructor Create;
  destructor Free;
  procedure SaveSettings;
  procedure LoadSettings;
 end;


 var
  Settings: TOptions;

implementation
 uses IniFiles;

constructor TOptions.Create;
begin
 WorkDir:=ExcludeTrailingBackslash(ExtractFilePath(Application.ExeName));
end;

destructor TOptions.Free;
begin
end;

procedure TOptions.SaveSettings;
var
  MailIni: TIniFile;
begin
 {$i-}
  MailIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  with MailIni do  begin
   WriteString('SERVICE', 'ServiceName', ServiceName);
   WriteString('SERVICE', 'ServicePath', ServicePath);
   WriteString('SERVICE', 'ServiceParameters', ServiceParameters);
  end;
  MailIni.Free;
 {$i+}
end;

procedure TOptions.LoadSettings;
var
  MailIni: TIniFile;
  ATemp:String;
begin
 {$i-}
  MailIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  with MailIni do  begin
   ServiceName := ReadString('SERVICE', 'ServiceName', '');
   ServicePath := ReadString('SERVICE', 'ServicePath', '');
   ServiceParameters := ReadString('SERVICE', 'ServiceParameters', '');
  end;
  MailIni.Free;
 {$i+}
end;

end.
