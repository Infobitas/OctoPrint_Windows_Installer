object AppServiceModule: TAppServiceModule
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'OctoPrint Service'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 455
  Width = 687
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 104
    Top = 176
  end
end
