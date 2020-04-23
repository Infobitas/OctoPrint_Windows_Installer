object AppServiceModule: TAppServiceModule
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'OctoPrint Service'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 455
  Width = 687
end
