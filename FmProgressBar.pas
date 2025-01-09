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
    procedure SetProgressCircle(const APos: integer);
  public
    { Public declarations }
//    procedure SetProgress(const APos: integer);
    procedure SetProgress(const APos: integer; const ANum : integer);
  end;

implementation

{$R *.fmx}

procedure TFrameProgressBar.FrameResize(Sender: TObject);
begin
 { -- именно тут загрузка скачет
 showmessage('FrameResize2');
 }
end;

// кружок позиция отрисовка
procedure TFrameProgressBar.SetProgressCircle(const APos: integer);
  var vSin : integer;
      vXCenter, vYCenter, vR : Single;
      vRadius : integer;
begin
  vRadius := TRUNC(Pie1.Height/2);
  vXCenter := TRUNC(Height/2);
  vYCenter := TRUNC(Width/2);

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

procedure TFrameProgressBar.SetProgress(const APos: integer; const ANum : integer);
//    function TestScore(Sender: TObject; pCount: integer): integer;
  var vSin : integer;
      vXCenter, vYCenter, vR : Single;
begin
  vXCenter := 116+Position.X+Trunc(Height/2);
  vYCenter := 113+Position.Y+Trunc(Width/2);

//  showmessage(IntToStr(TRUNC(vXCenter)) + ' на ' + IntToStr(TRUNC(vYCenter)));
  vR := 88;

  vSin := APos mod (100);
  Pie1.EndAngle := ( 360 * vSin / 100 ) - 90;

//  Circle2.Position.X := vXCenter + vR * cos(( 360 * APos * pi/ 100/180 -90));
//  Circle2.Position.Y := vYCenter + vR * sin(( 360 * APos * pi/ 100/180 -90));
  Circle2.Visible := false;
  Text1.Text := IntToStr(ANum);
end;

end.
