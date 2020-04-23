unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.AppEvnts, Variants, TlHelp32;

type

  TAppServiceModule = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceExecute(Sender: TService);
  private
    FServiceHandle: THandle;

    procedure Log(AMessage:String; AType:Integer);
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

//(EVENTLOG_ERROR_TYPE, EVENTLOG_WARNING_TYPE, EVENTLOG_INFORMATION_TYPE);
procedure TAppServiceModule.Log(AMessage:String; AType:Integer);
begin
  with TEventLogger.Create(Settings.ServiceName) do begin
    try
      LogMessage(AMessage, AType);
    finally
      Free;
    end;
   end;
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
  AppDone: DWord;
begin

 try
  AServicePath := ExtractFilePath(Settings.ServicePath);

  if not FileExists(Settings.ServicePath) then  begin
   Log('OctoPrint is missing. Check C:\OctoPrint\venv\Scripts\octoprint.exe', EVENTLOG_ERROR_TYPE);
   exit;
  end;


  FillMemory( @pi, SizeOf( pi ), 0 );
  GetStartupInfo( si );

  CreateProcess(PWideChar(Settings.ServicePath), PWideChar(Settings.ServiceParameters), nil, nil, false, 0, nil, PWideChar(AServicePath), si, pi );
  CloseHandle(pi.hThread);
  TThread.Sleep(1000);

  while not Terminated do begin
   AppDone := WaitForSingleObject(pi.hProcess, 100);
   if AppDone <> WAIT_TIMEOUT then begin
    Log('OctoPrint Terminated, Service Terminating', EVENTLOG_ERROR_TYPE);
    break;
   end;

   ServiceThread.ProcessRequests(false);
   TThread.Sleep(1000);
  end;

  TerminateProcess(pi.hProcess, 1);
  except
   on e:exception do begin
    Log(e.Message, EVENTLOG_ERROR_TYPE);
   end;
  end;

end;

procedure TAppServiceModule.ServiceStart(Sender: TService; var Started: Boolean);
 var AServicePath:String;
begin
 Settings:= TOptions.Create;
 Settings.LoadSettings;
 Application.Title :=Settings.ServiceName;
 Log('Starting Services...', EVENTLOG_INFORMATION_TYPE);
 Started := true;
end;

procedure TAppServiceModule.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
 Log('Stopping Services...', EVENTLOG_INFORMATION_TYPE);
 Settings.Free;
 Stopped := true;
end;

end.
