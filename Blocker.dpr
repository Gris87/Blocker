program Blocker;

uses
  Windows,
  Forms,
  MainUnit in 'src\MainUnit.pas' {MainForm};

{$R *.res}

var
   MutexHandle: THandle;

begin
  MutexHandle:=0;
  MutexHandle:=CREATEMUTEX(nil, TRUE, 'Blocker');

  if GetLastError<>0
    then begin
              if MutexHandle<>0
                then CLOSEHANDLE(MutexHandle);

              exit;
         end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

  if MutexHandle<>0
    then CLOSEHANDLE(MutexHandle);
end.
