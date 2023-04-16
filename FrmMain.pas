unit FrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}
{$R *.Macintosh.fmx MACOS}
{$R *.Windows.fmx MSWINDOWS}

procedure TFormMain.Button1Click(Sender: TObject);
var
  I: integer;
begin
  panel2.color := clRed;
  {
  for I := TRUNC(Panel1.position.x)  downto -TRUNC
    (Panel1.position.x + Panel1.Width) do
  begin
    Panel1.position.x := TRUNC(I);
    //pause(10);
    sleep(5);
    //FormMain.Refresh;
  end;
  }

end;

end.
