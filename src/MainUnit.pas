unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    BlockLabel: TLabel;
    BlockTimer: TTimer;
    InBlockTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure BlockLabelClick(Sender: TObject);
    procedure BlockTimerTimer(Sender: TObject);
    procedure InBlockTimerTimer(Sender: TObject);
    procedure BlockLabelDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        procedure CD_Lock(Locked: Boolean; DriveLetter: string);
        procedure LockCDROMs;
        procedure UnlockCDROMs;
  end;

var
  MainForm: TMainForm;
  BeforeBlock: Integer;
  mouseX: Integer;
  mouseY: Integer;

implementation

{$R *.dfm}

procedure TMainForm.CD_Lock(Locked: Boolean; DriveLetter: string);
const
     IOCTL_STORAGE_MEDIA_REMOVAL = $002D4804;
var
   hDrive: THandle;
   Returned: DWORD;
   DisableEject: boolean;
begin
     hDrive := CreateFile(PChar('\\.\' + DriveLetter), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

     try
        DisableEject := Locked;
        DeviceIoControl(hDrive, IOCTL_STORAGE_MEDIA_REMOVAL, @DisableEject, SizeOf(DisableEject), nil, 0, Returned, nil);
     finally
            CloseHandle(hDrive);
     end;
end;

procedure TMainForm.LockCDROMs;
var
  w: dword;
  Root: string;
  DriveLetter: string;
  i: byte;
begin
     w := GetLogicalDrives;
     Root := '#:\';
     for i := 0 to 25 do
     begin
          Root[1] := Char(Ord('A') + i);

          if ((W and (1 shl i)) > 0) and (GetDriveType(PChar(Root)) = DRIVE_CDROM)
            then begin
                      DriveLetter := Copy(Root, 1, Length(Root) - 1);
                      CD_Lock(True, DriveLetter);
                 end
     end;
end;

procedure TMainForm.UnlockCDROMs;
var
  w: dword;
  Root: string;
  DriveLetter: string;
  i: byte;
begin
     w := GetLogicalDrives;
     Root := '#:\';
     for i := 0 to 25 do
     begin
          Root[1] := Char(Ord('A') + i);

          if ((W and (1 shl i)) > 0) and (GetDriveType(PChar(Root)) = DRIVE_CDROM)
            then begin
                      DriveLetter := Copy(Root, 1, Length(Root) - 1);
                      CD_Lock(False, DriveLetter);
                 end
     end;
end;

procedure TMainForm.BlockLabelClick(Sender: TObject);
begin
     if (not BlockTimer.Enabled)
       then FormCreate(nil);
end;

procedure TMainForm.BlockLabelDblClick(Sender: TObject);
begin
     BlockInput(true);
     LockCDROMs;

     BlockLabel.Caption:='CD-ROM, Keyboard and mouse are blocked';
     BlockTimer.Enabled:=false;

     mouseX:=mouse.CursorPos.X;
     mouseY:=mouse.CursorPos.Y;
     InBlockTimer.Enabled:=true;
end;

procedure TMainForm.BlockTimerTimer(Sender: TObject);
begin
     if BeforeBlock=0
       then begin
                 BlockLabelDblClick(nil);
            end
       else begin
                 BlockLabel.Caption:='Block after '+IntToStr(BeforeBlock)+' sec';
                 dec(BeforeBlock);
            end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     BeforeBlock:=5;
     BlockTimerTimer(nil);
     BlockTimer.Enabled:=true;
end;

procedure TMainForm.InBlockTimerTimer(Sender: TObject);
begin
     if (mouseX<>mouse.CursorPos.X) and (mouseY<>mouse.CursorPos.Y)
       then begin
                 UnlockCDROMs;

                 BlockLabel.Caption:='CD-ROM, Keyboard and mouse are free';
                 InBlockTimer.Enabled:=false;
            end;

     mouseX:=mouse.CursorPos.X;
     mouseY:=mouse.CursorPos.Y;
end;

end.
