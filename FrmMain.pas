unit FrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FmFirst;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    FrameFirst1: TFrameFirst;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TNewThread = class(TThread)
  private
    Progress: integer;
    procedure SetProgress;
  protected
    procedure Execute; override;
  end;

var
  fMain: TfMain;
  vEventMove: integer; // 10 - обратно, 11- вправо. первую форму

implementation

{$R *.fmx}

procedure TfMain.Button1Click(Sender: TObject);
var
  NewThread: TNewThread;
begin
  vEventMove := 11;

  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
  {
    while FrameFirst1.Position.X < width do
    begin
    //    sleep(1);
    FrameFirst1.Position.X := FrameFirst1.Position.X + 5;
    end;
    // close;
  }
end;

procedure TNewThread.Execute;
var
  i: integer;
begin
  for i := 0 to fMain.width do
  begin
    // sleep(1);
    Progress := i;
    Synchronize(SetProgress);
  end;
end;

procedure TNewThread.SetProgress;
begin
  // Form1.ProgressBar1.Position:=Progress;
  // Form1.Label1.Caption := UnitRead.Read('22_') + IntToStr(Progress);
  // fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + 5;
  if vEventMove = 11 then
    If fMain.FrameFirst1.Position.X < fMain.width then
    begin
      fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X + 10;
    end;

  if vEventMove = 10 then
    If fMain.FrameFirst1.Position.X > 15 then
    begin
      if fMain.FrameFirst1.Position.X - 15 > 10 then
        fMain.FrameFirst1.Position.X := fMain.FrameFirst1.Position.X - 10
      else
        fMain.FrameFirst1.Position.X := 15;
    end;

  // fMain.

end;

procedure TfMain.Button2Click(Sender: TObject);
var
  NewThread: TNewThread;
begin
  vEventMove := 10;

  NewThread := TNewThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

end.
