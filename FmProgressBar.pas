unit FmProgressBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFrameProgressBar = class(TFrame)
    ProgressBar: TProgressBar;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBarThread = class(TThread)
  private
    Progress: integer;
    procedure SetActualFrame;
  protected
    procedure Execute; override;
  end;

implementation

{$R *.fmx}

procedure TFrameProgressBar.Button1Click(Sender: TObject);
var
  NewThread: TBarThread;
begin
  NewThread := TBarThread.Create(true);
  NewThread.FreeOnTerminate := true;
  NewThread.Priority := tpLower;
  NewThread.Resume;
end;

// процедура другого потока, пока не выполнится ни чего об ней не знаем
// она в цикле дергает актуализацию.
procedure TBarThread.Execute;
var
  i: integer;
begin
  for i := 0 to 100 do
  begin
    Progress := i;
    Synchronize(SetActualFrame);
  end;
end;

// процедура дергаящаяся из другого потока на этот фрейм
procedure TBarThread.SetActualFrame;
var
  vLeftBorderFrame, vStepSize, vLeftBorderFrame2: integer;
begin
//  TFrameProgressBar.ProgressBar.Progress := 100 * Current div Count;
end;

end.
