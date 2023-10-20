unit FmChannels;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  FMX.Layouts;

type
  TFrameChannels = class(TFrame)
    LabelChannels: TLabel;
    ButtonAddChannel: TButton;
    ImageAddChannel: TImage;
    BoxChannels: TVertScrollBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang(pLabelChannels, pButtonAddChannel: string);
  end;

implementation

{$R *.fmx}

procedure TFrameChannels.SetLang(pLabelChannels, pButtonAddChannel: string);
begin
  if pLabelChannels <> '' then
    LabelChannels.Text := pLabelChannels;
  if pButtonAddChannel <> '' then
    ButtonAddChannel.Text := pButtonAddChannel;
end;

end.
