unit PnChannel;

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
//  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
//  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList;
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
//  TChannelPanel = class(TPanel)
  TChannelPanel = class(TPanel)
    ChImage: TImage;
    ChName: TLabel;
    ChLang: TLabel;
    ChSelLang: TLabel;
    ButtonDel: TButton;
    chId  : TLabel;
    chToken  : TLabel;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pPos, pN: integer;
                pChId, pChToken, pChName, pChLang, pChSelLang : string;
                ABitmap : TBitmap); reintroduce;
      overload; virtual;
//    procedure DinButtonDeleteChannelClick(Sender: TObject);
  end;

implementation

constructor TChannelPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Parent := AOwner;
//  ControlStyle := ControlStyle + [csReplicatable];
  Width := 685;
  Height := 105;
  Left := 8;
//  ParentColor := false;
//  StyleElements := [seFont,seBorder];
//  BevelOuter :=  bvNone;
  //Top := 8;
end;

constructor TChannelPanel.Create(AOwner: TComponent;  pPos, pN: integer;
      pChId, pChToken, pChName, pChLang, pChSelLang : string; ABitmap : TBitmap);
begin
  Create(AOwner);
  Self.Position.y := 8 + pPos;
  //Self.Name := 'P' + IntToStr(pN);
  Self.tag :=  pN;

  ChId := TLabel.Create(Self);
  with ChId do
  begin
    Parent := Self;
    Text := pChId;
    Visible := false;
    tag :=  pN;
  end;

  chToken := TLabel.Create(Self);
  with chToken do
  begin
    Parent := Self;
    Text := pChToken;
    Visible := false;
    tag :=  pN;
  end;

  ButtonDel := TButton.Create(Self);
  with ButtonDel do
  begin
    Parent := Self;
    Text := 'Delete';
    name := 'D' + IntToStr(pN);
    Position.x := 400;
    Position.y := 10;
    Width := 60;
    Visible := True;
    Tag :=  pN;
  end;

  ChName := TLabel.Create(Self);
  with ChName do
  begin
    Parent := Self;
    Text := pChName;
    Name := 'N' + IntToStr(pN);
    Width := 449;
    Position.y:=  25;
    Height :=  21;
    Position.x := 120;
    Font.Size := 12;
    Font.Style := [TFontStyle.fsBold];
    Tag :=  pN;
    Visible := True;
  end;

  ChLang := TLabel.Create(Self);
  with ChLang do
  begin
    Parent := Self;
    Text := pChLang;
    Name := 'L' + IntToStr(pN);
    Height := 17;
    Position.x := 120;
    Position.y := 64;
    Width := 449;
    Font.Size := 10;
    Tag :=  pN;
    Visible := True;
  end;

  ChSelLang := TLabel.Create(Self);
  with ChSelLang do
  begin
    Parent := Self;
    Text := pChSelLang;
    Name := 'SL' + IntToStr(pN);
    Height := 17;
    Position.x := 1;
    Position.y := 1;
    Width := 500;
    Font.Size := 10;
    Tag :=  pN;
    Visible := false;
  end;

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

//  self.ButtonDel.OnClick := DinButtonDeleteChannelClick;
end;

{
procedure TChannelPanel.DinButtonDeleteChannelClick(Sender: TObject);
// Sender : TComponent;
var
  strQuestionDelete, vIdChannel, vNameChannel: string;
  vNPanel: integer;
  i: integer;
begin
  //  lastPanel := nil;
  vNPanel := Self.tag;
  vIdChannel := Self.chId.Text;
  vNameChannel := Self.chName.Text;
  strQuestionDelete := 'Delete 2' + vNameChannel + ' ?';
  if FMX.Dialogs.MessageDlg(strQuestionDelete, TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo) = mrYes

  then
  begin
    // SQLiteModule.DelChannel(vIdChannel);

  end;

end;
}

end.
