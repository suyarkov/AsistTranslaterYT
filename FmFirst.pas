unit FmFirst;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

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
    procedure FrameCanFocus(Sender: TObject; var ACanFocus: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
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

end.
