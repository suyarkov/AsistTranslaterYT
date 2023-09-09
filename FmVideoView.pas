unit FmVideoView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList;

type
  TFrameVideoView = class(TFrame)
    LabelVideoView: TLabel;
    procedure ImageAddVideoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameVideoView.ImageAddVideoClick(Sender: TObject);
begin
//   ImageAddVideo.
end;

end.
