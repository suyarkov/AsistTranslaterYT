unit ChannelPanel;

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TMyPanel = class(TPanel)
//    ChImage: TImage;
    ChName: TLabel;
    ChLang: TLabel;
    ButtonDel: TButton;
    chId  : TLabel;
    chToken  : TLabel;
  public
    constructor Create(AOwner: TComponent); overload; override;
    // constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pPos, pN: integer;
                pChId, pChToken, pChName, pChLang : string); reintroduce;
      overload; virtual;
  end;

implementation

constructor TMyPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Parent := AOwner;
//  ControlStyle := ControlStyle + [csReplicatable];
  Width := 585;
  Height := 105;
  Left := 8;
//  ParentColor := false;
//  StyleElements := [seFont,seBorder];
//  BevelOuter :=  bvNone;
  //Top := 8;
end;

constructor TMyPanel.Create(AOwner: TComponent;  pPos, pN: integer;
      pChId, pChToken, pChName, pChLang : string);
begin
  Create(AOwner);
  Self.Top := 8 + pPos;
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
    Left := 500;
    Top := 10;
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
    Top:=  25;
    Height :=  21;
    left := 120;
    Font.Size := 12;
    //Font.Style := [fsBold];
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
    Left := 120;
    Top := 64;
    Width := 449;
    Font.Size := 10;
    Tag :=  pN;
    Visible := True;
  end;
  {
  ChImage := TImage.Create(Self);
  with ChImage do
  begin
    Parent := Self;
    Height := 88;
    Left := 8;
    Top := 8;
    Width := 88;
    Tag :=  pN;
    ChImage.Picture.LoadFromFile('d:/tete.jpg');
    Visible := True;
  end;
  }
end;

end.
