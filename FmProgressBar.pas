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
    Circle2: TCircle;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetProgress(const APos: integer);
  end;

implementation

{$R *.fmx}

procedure TFrameProgressBar.FrameResize(Sender: TObject);
begin
 showmessage('FrameResize');
end;

procedure TFrameProgressBar.SetProgress(const APos: integer);
  var vSin : integer;
      vXCenter, vYCenter, vR : Single;
begin
  vXCenter := TRUNC(Pie1.Position.X);
  vYCenter := TRUNC(Pie1.Position.Y);
  vR := Pie1.Size.Height / 2;
  vSin := APos mod (100);
  Pie1.EndAngle := ( 360 * vSin / 100 ) - 90;
  //showmessage('FrameResize');
//  Circle2.Position.X := vXCenter + vR * cos(( 360 * vSin / 100 ) - 90);
//  Circle2.Position.Y := vYCenter + vR * sin(( 360 * vSin / 100 ) - 90);
  Circle2.Position.X := vXCenter;
  Circle2.Position.Y := vYCenter;
  Text1.Text := IntToStr(vSin);
end;

end.
