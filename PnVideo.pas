unit PnVideo;

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TVideoPanel = class(TPanel)
    VdImage: TImage;
    VdId: TLabel;
    VdToken: TLabel;
    VdTitle: TLabel;
    VdDescription  : TLabel;
    VdLang  : TLabel;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pPosY, pN: integer;
            pVideoId, pVideoToken, pVideoTitle, pVideoDescription, pVideoLang:  string;
            pImage : TBitMap); reintroduce;
      overload; virtual;
//    procedure DinButtonDeleteVideoClick(Sender: TObject);
  end;

implementation

constructor TVideoPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Parent := AOwner;
//  ControlStyle := ControlStyle + [csReplicatable];
  Width := 305;
  Height := 105;
  Left := 8;
//  ParentColor := false;
//  StyleElements := [seFont,seBorder];
//  BevelOuter :=  bvNone;
  //Top := 8;
end;

constructor TVideoPanel.Create(AOwner: TComponent; pPosY, pN: integer;
            pVideoId, pVideoToken, pVideoTitle, pVideoDescription, pVideoLang:  string;
            pImage : TBitMap);
//            pUrlImage : string);
//AOwner: TComponent;  pPos, pN: integer;
//      pChId, pChToken, pChName, pChLang : string; ABitmap : TBitmap);
var
  vS : string;
  AAPIUrl: String;
{  FHTTPClient: THTTPClient;
  AResponce: IHTTPResponse;
  jpegimg: TJPEGImage;}
begin
  Create(AOwner);
  Self.Position.y := 8 + pPosY;
  //Self.Name := 'P' + IntToStr(pN);
  Self.tag :=  pN;

  VdId := TLabel.Create(Self);
  with VdId do
  begin
    Parent := Self;
    Text := pVideoId;
    Visible := false;
    tag :=  pN;
  end;

  VdTitle := TLabel.Create(Self);
  with VdTitle do
  begin
    Parent := Self;
    Text := pVideoTitle;
    Visible := true;
    Width := 449;
    Position.y:=  25;
    Height :=  21;
    Position.x := 120;
    Font.Size := 12;
    //Font.Style := [fsBold];
    Tag :=  pN;
    Visible := True;
  end;

  VdDescription := TLabel.Create(Self);
  with VdDescription do
  begin
    Parent := Self;
    Text := pVideoTitle;
    Name := 'T' + IntToStr(pN);
    Width := 449;
    Position.y:=  25;
    Height :=  21;
    Position.x := 120;
    Font.Size := 12;
    //Font.Style := [fsBold];
    Tag :=  pN;
    Visible := True;
  end;

  VdLang := TLabel.Create(Self);
  with VdLang do
  begin
    Parent := Self;
    Text := pVideoDescription;
    Name := 'D' + IntToStr(pN);
    Height := 17;
    Position.x := 120;
    Position.y := 64;
    Width := 449;
    Font.Size := 10;
    Tag :=  pN;
    Visible := True;
  end;

  VdImage := TImage.Create(Self);
  with VdImage do
  begin
    Parent := Self;
    Height := 90;
    Left := 8;
    Top := 8;
    Width := 120;
    Tag :=  pN;
    vdImage.Bitmap := pImage;
{      try

        vS := StringReplace(pUrlImage, #13, '', [rfReplaceAll, rfIgnoreCase]);
        AAPIUrl := StringReplace(vS, #10, '', [rfReplaceAll, rfIgnoreCase]);
        FHTTPClient := THTTPClient.Create;
        FHTTPClient.UserAgent :=
          'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
        try
          AResponce := FHTTPClient.Get(AAPIUrl);
        except
          showmessage('��� �����������');
        end;
        if Not Assigned(AResponce) then
        begin
          showmessage('�����');
        end;

        jpegimg := TJPEGImage.Create;
        jpegimg.LoadFromStream(AResponce.ContentStream);
        vdImage.Picture.Assign(jpegimg);
      except
      end;
      }
    Visible := True;
  end;
{
  ChImage := TImage.Create(Self);
  with ChImage do
  begin
    Parent := Self;
    Position.x := 8;
    Position.y := 8;
    Height := 88;
    Width := 88;
    Tag :=  pN;
    try
    ChImage.Bitmap := ABitmap;
    except
       null;
    end;
    Visible := True;

  end;
 }
//  self.ButtonDel.OnClick := DinButtonDeleteVideoClick;
end;

{
procedure TVideoPanel.DinButtonDeleteVideoClick(Sender: TObject);
// Sender : TComponent;
var
  strQuestionDelete, vIdVideo, vNameVideo: string;
  vNPanel: integer;
  i: integer;
begin
  //  lastPanel := nil;
  vNPanel := Self.tag;
  vIdVideo := Self.chId.Text;
  vNameVideo := Self.chName.Text;
  strQuestionDelete := 'Delete 2' + vNameVideo + ' ?';
  if FMX.Dialogs.MessageDlg(strQuestionDelete, TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes

  then
  begin
    // SQLiteModule.DelVideo(vIdVideo);

  end;

end;
}

end.