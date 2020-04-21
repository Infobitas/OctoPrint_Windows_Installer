unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.AppEvnts, Variants;

type
  TLogType = (ltInfo, ltError);

  TAppServiceModule = class(TService)
    ApplicationEvents: TApplicationEvents;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    FServiceHandle: THandle;
    FLog:TStringList;

    procedure Log(AMessage:String; AType:TLogType);
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  AppServiceModule: TAppServiceModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
 uses Options;
{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
 AppServiceModule.Controller(CtrlCode);
end;

procedure TAppServiceModule.Log(AMessage:String; AType:TLogType);
begin
 FLog.Add(AMessage);
 if AType = ltError then
 try
  FLog.SaveToFile(Settings.WorkDir+'\Log.txt');
 finally
 end;
end;


procedure TAppServiceModule.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
 Log(e.Message, ltError);
end;

function TAppServiceModule.GetServiceController: TServiceController;
begin
 Result := ServiceController;
end;

procedure TAppServiceModule.ServiceExecute(Sender: TService);
 var
  si : TStartupInfo;
  pi : TProcessInformation;
  AServicePath:String;
begin

 try
  AServicePath := ExtractFilePath(Settings.ServicePath);
  FillMemory( @pi, SizeOf( pi ), 0 );
  GetStartupInfo( si );

  CreateProcess(PWideChar(Settings.ServicePath), PWideChar(Settings.ServiceParameters), nil, nil, false, 0, nil, PWideChar(AServicePath), si, pi );
  CloseHandle(pi.hThread);

  while not Terminated do begin
   ServiceThread.ProcessRequests(false);
   TThread.Sleep(1000);
  end;

  TerminateProcess(pi.hProcess, 1);
  except
   on e:exception do begin
    Log(e.Message, ltError);
   end;
  end;

end;

procedure TAppServiceModule.ServiceStart(Sender: TService; var Started: Boolean);
 var AServicePath:String;
begin
 FLog:=TStringList.Create;
 Log('Reading Settings...', ltInfo);
 Settings:= TOptions.Create;
 Settings.LoadSettings;
 Application.Title :=Settings.ServiceName;
 Log('Starting Services...', ltInfo);
 Started := true;
end;

procedure TAppServiceModule.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
 Log('Stopping Services...', ltInfo);
 //FLog.SaveToFile(Settings.WorkDir+'\Log.txt');
 FLog.Free;
 Settings.Free;
 Stopped := true;
end;

end.
