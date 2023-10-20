unit FmMainChannel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  FMX.Layouts;

type
  TFrameMainChannel = class(TFrame)
    LabelNameChannel: TLabel;
    ImageChannel: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BoxVideos: TVertScrollBox;
    ButtonAddNextVideo: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang(pLabelNameChannel, pButtonAddNextVideo: string);
  end;

implementation

{$R *.fmx}

procedure TFrameMainChannel.SetLang(pLabelNameChannel, pButtonAddNextVideo: string);
begin
  if pLabelNameChannel <> '' then
    LabelNameChannel.Text := pLabelNameChannel;
  if pButtonAddNextVideo <> '' then
    ButtonAddNextVideo.Text := pButtonAddNextVideo;
end;

end.
