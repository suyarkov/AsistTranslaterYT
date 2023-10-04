unit PnLanguage;

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
//  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
//  FMX.Controls.Presentation, FMX.Objects, System.ImageList, FMX.ImgList;
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
//  TChannelPanel = class(TPanel)
  TLanguagePanel = class(TPanel)
    ChImage: TImage;
    ChName: TLabel;
    ChLang: TLabel;
    ButtonOnOff: TButton;
    chId  : TLabel;
    chToken  : TLabel;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pPosX, pPosY, pN, pSelected: integer;
                pChId, pChToken, pChName, pChLang : string;  ABitmap : TBitmap
    ); reintroduce;
      overload; virtual;
//    procedure DinButtonDeleteChannelClick(Sender: TObject);
  end;

implementation

constructor TLanguagePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Parent := AOwner;
//  ControlStyle := ControlStyle + [csReplicatable];
  Width := 236;
  Height := 46;
  Left := 8;
//  ParentColor := false;
//  StyleElements := [seFont,seBorder];
//  BevelOuter :=  bvNone;
  //Top := 8;
end;

constructor TLanguagePanel.Create(AOwner: TComponent; pPosX, pPosY, pN, pSelected: integer;
      pChId, pChToken, pChName, pChLang : string  ; ABitmap : TBitmap
      );
begin
  Create(AOwner);
  Self.Position.x :=  pPosX;
  Self.Position.y :=  pPosY;
  //Self.Name := 'P' + IntToStr(pN);
  Self.tag :=  pN; // а это номер в таблице объектов

  ButtonOnOff := TButton.Create(Self);
  with ButtonOnOff do
  begin
    Parent := Self;
    Text := pChName;//'Delete';
    name := 'B' + IntToStr(pN);
    Position.x := 1;
    Position.y := 1;
    Width := 236;
    Height := 46;
//    Position.x := 2;
//    Position.y := 2;
//    Width := Self.Position.Width - 4;
//    Height := Self.Position.Height - 4;
//    if pSelected = 1 then
      TextSettings.Font.Style := [TFontStyle.fsBold];
    Visible := True;
    Tag :=  pN;
  end;

  ChId := TLabel.Create(Self); // это ID номер в порядке справочника
  with ChId do
  begin
    Parent := Self;
    Text := pChId;
    Visible := false;
    tag :=  pN;
  end;

  chToken := TLabel.Create(Self); // это не ясно, что за оно, можно и удалить
  with chToken do
  begin
    Parent := Self;
    Text := pChToken;
    Visible := false;
    tag :=  pN;
  end;

  ChName := TLabel.Create(Self); // наименование которое на кнопке видно
  with ChName do
  begin
    Parent := Self;
    Text := pChName;
    Name := 'N' + IntToStr(pN);
    Width := 30;
    Position.y:=  25;
    Height :=  21;
    Position.x := 120;
    Font.Size := 12;
    Font.Style := [TFontStyle.fsBold];
    Tag :=  pN;
    Visible := false;//True;
  end;

  ChLang := TLabel.Create(Self); // символьный код
  with ChLang do
  begin
    Parent := Self;
    Text := pChLang;
    Name := 'L' + IntToStr(pN);
    Height := 17;
    Position.x := 120;
    Position.y := 64;
    Width := 30;
    Font.Size := 10;
    Tag :=  pN;
    Visible := false;//True;
  end;

  ChImage := TImage.Create(Self); // картинка, которая обозначает выбран данный язык или нет
  with ChImage do
  begin
    Parent := Self;
    Position.x := 8;
    Position.y := 16;
    Height := 16;
    Width := 16;
    Tag :=  pN;
    try
    ChImage.Bitmap := ABitmap;
    except
       null;
    end;
    if pSelected = 1 then
      Visible := True
    else 
      Visible := False;

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
