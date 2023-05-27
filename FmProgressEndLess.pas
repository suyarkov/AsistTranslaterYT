unit FmProgressEndLess;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TFrameProgressEndLess = class(TFrame)
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

procedure TFrameProgressEndLess.SetProgress(const APos: integer);
  var vSin : integer;
begin
  vSin := APos mod (200);
  if vSin>100 then
  begin
  Pie1.StartAngle := ( 360 * (vSin - 100) / 100 ) - 90;
  Pie1.EndAngle := +270;
  end
  else
  begin
  Pie1.StartAngle := - 90;
  Pie1.EndAngle := ( 360 * (vSin) / 100 ) - 90;
  end;
  text1.Text := inttoStr(vSin);
end;

end.
