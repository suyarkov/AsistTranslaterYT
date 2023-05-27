unit FmProgressBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFrameProgressBar = class(TFrame)
    Layout1: TLayout;
    Pie1: TPie;
    Circle1: TCircle;
    Text1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetProgress(const APos: integer);
  end;

implementation

{$R *.fmx}

procedure TFrameProgressBar.SetProgress(const APos: integer);
  var vSin : integer;
begin
  vSin := APos mod (100);
  Pie1.EndAngle := ( 360 * vSin / 100 ) - 90;
  Text1.Text := IntToStr(vSin);
end;

end.
