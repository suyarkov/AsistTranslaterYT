unit FmVideos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList,
  FMX.Memo.Types, FMX.ListBox, FMX.ScrollBox, FMX.Memo;

type
  TFrameVideos = class(TFrame)
    LabelVideos: TLabel;
    MemoTitle: TMemo;
    MemoDescription: TMemo;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ImageVideo: TImage;
    procedure ImageAddVideoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameVideos.ImageAddVideoClick(Sender: TObject);
begin
//   ImageAddVideo.
end;

end.
