unit uStopStart;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, System.ImageList,
  FMX.ImgList, uScenarioFrame, windows, Messages, VCL.Menus, uScheduler;

type
  TFormStopStart = class(TForm)
    Layout2: TLayout;
    btnStart: TSpeedButton;
    ImageBtn: TImage;
    ImageList: TImageList;
    Circle1: TCircle;
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FForm: TObject;
    FWnd: THANDLE;
    HotKey: integer;
    procedure WindowProc(var AMsg: TMessage);
    { Private declarations }
  public
    { Public declarations }
    property AForm: TObject read FForm write FForm;
  end;

var
  FormStopStart: TFormStopStart;

implementation

{$R *.fmx}

procedure TFormStopStart.btnStartClick(Sender: TObject);
begin
  Self.Visible := false;
  if AForm is TScenarioFrame then
    (AForm as TScenarioFrame).StartStopTest
  else

    if AForm is TFormScheduler then
    (AForm as TFormScheduler).Stop;
end;

procedure TFormStopStart.FormCreate(Sender: TObject);
begin
  Self.FormStyle := TFormStyle.StayOnTop;
  FWnd := AllocateHWnd(WindowProc);
  HotKey := vk_f1;
  RegisterHotkey(FWnd, HotKey, mod_control, HotKey);
end;

procedure TFormStopStart.FormDestroy(Sender: TObject);
begin
  try
    UnregisterHotkey(FWnd, HotKey);
  finally
  end;
end;

procedure TFormStopStart.WindowProc(var AMsg: TMessage);
begin
  case AMsg.Msg of
    WM_HOTKEY:
      if TWMHotKey(AMsg).HotKey = HotKey then
      begin
        btnStartClick(nil);
      end;
  end;
end;

end.
