unit FmFirst;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TFrameFirst = class(TFrame)
    LabelName: TLabel;
    LabelPas: TLabel;
    EditName: TEdit;
    EditPas: TEdit;
    ButtonReg: TButton;
    ButtonLog: TButton;
    LabelForgot: TLabel;
    LabelError: TLabel;
    Panel1: TPanel;
    Image0: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    PanelIsLang: TPanel;
    procedure FrameCanFocus(Sender: TObject; var ACanFocus: Boolean);
{    procedure Image0Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);}
  private
    { Private declarations }
  public
    { Public declarations }
    var LangCurrent : string;
  end;

implementation

{$R *.fmx}

procedure TFrameFirst.FrameCanFocus(Sender: TObject; var ACanFocus: Boolean);
var
  vRect : TRectF;
begin
  vRect.Create(1,1,100,100);
  Canvas.ExcludeClipRect(vRect);


//   PanelFm.Canvas. .Brush.Color :=  RGB(97,114,152);
//   PanelFm.Canvas.Pen.Color := FormWait.Canvas.Brush.Color;
//   Canvas.RoundRect( i*32-14, 25, i*32 + 30-14,  25+10, 6 ,6);
end;
{
procedure TFrameFirst.Image1Click(Sender: TObject);
begin
  LangCurrent  := 'de';
end;

procedure TFrameFirst.Image2Click(Sender: TObject);
begin
  LangCurrent  := 'fr';
end;

procedure TFrameFirst.Image3Click(Sender: TObject);
begin
  LangCurrent  := 'es';
end;

procedure TFrameFirst.Image4Click(Sender: TObject);
begin
  LangCurrent  := 'pt';
end;

procedure TFrameFirst.Image5Click(Sender: TObject);
begin
  LangCurrent  := 'uk';
end;

procedure TFrameFirst.Image6Click(Sender: TObject);
begin
  LangCurrent  := 'ru';
end;

procedure TFrameFirst.Image0Click(Sender: TObject);
begin
  LangCurrent  := 'en';
end;
}
end.
