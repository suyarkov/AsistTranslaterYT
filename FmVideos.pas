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
    LanguageCheckBox: TCheckBox;
    LanguageComboBox: TComboBox;
    ImageVideo: TImage;
    LanguageVideoLabel: TLabel;
    PanelTitle: TPanel;
    LabelTitle: TLabel;
    PanelDescription: TPanel;
    LabelDescription: TLabel;
    TitleLengthLabel: TLabel;
    BTranslater: TButton;
    LabelVideoId: TLabel;
    DescriptionLengthLabel: TLabel;
    procedure BTranslaterClick(Sender: TObject);
    procedure MemoTitleChange(Sender: TObject);
    procedure MemoTitleKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure MemoDescriptionChange(Sender: TObject);
    procedure MemoDescriptionKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLang(pLabelVideos, pLanguageCheckBox, pLabelTitle, pLabelDescription, pBTranslater: string);
  end;

implementation

{$R *.fmx}

procedure TFrameVideos.MemoDescriptionChange(Sender: TObject);
begin
if length(MemoDescription.Text)> 5000 then
begin
  MemoDescription.Text := copy(MemoDescription.Text,1,5000);
  MemoDescription.SelStart := 5000;
end;

DescriptionLengthLabel.Text := IntToStr(length(MemoDescription.Text)) +'/5000';
end;

procedure TFrameVideos.MemoDescriptionKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   MemoDescriptionChange(Sender);
end;

procedure TFrameVideos.MemoTitleChange(Sender: TObject);
begin
if length(MemoTitle.Text)> 100 then
begin
  MemoTitle.Text := copy(MemoTitle.Text,1,100);
  MemoTitle.SelStart := 100;
end;

TitleLengthLabel.Text := IntToStr(length(MemoTitle.Text)) +'/100';
end;

procedure TFrameVideos.MemoTitleKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   MemoTitleChange(Sender);
end;

procedure TFrameVideos.SetLang(pLabelVideos, pLanguageCheckBox, pLabelTitle, pLabelDescription, pBTranslater: string);
begin
  if pLabelVideos <> '' then
    LabelVideos.Text := pLabelVideos;
  if pLanguageCheckBox <> '' then
    LanguageCheckBox.Text := pLanguageCheckBox;
  if pLabelTitle <> '' then
    LabelTitle.Text := pLabelTitle;
  if pLabelDescription <> '' then
    LabelDescription.Text := pLabelDescription;
  if pBTranslater <> '' then
    BTranslater.Text := pBTranslater;
end;

procedure TFrameVideos.BTranslaterClick(Sender: TObject);
var
  i, vCountLanguages: integer;
  vRes: integer;
begin
{  fLanguages.LanguagesGrid.ColWidths[0] := 30;
  fLanguages.LanguagesGrid.ColWidths[1] := 50;
  fLanguages.LanguagesGrid.ColWidths[2] := 200;
  fLanguages.LanguagesGrid.ColWidths[3] := 200;
  fLanguages.LanguagesGrid.ColWidths[4] := 20;

  // ���������
  vCountLanguages := 0;
  fLanguages.LanguagesGrid.Cells[0, 0] := 'Id';
  fLanguages.LanguagesGrid.Cells[1, 0] := '���';
  fLanguages.LanguagesGrid.Cells[2, 0] := '��� �����';
  fLanguages.LanguagesGrid.Cells[3, 0] := '��� ������';
  // ��������� StringGrid ����������
  for i := 1 to 1000 do
  begin
    // ������ ��� �� ��������� � ���������
    if ListLanguages[i].LnCode = '' then
    begin
      fLanguages.LanguagesGrid.RowCount := vCountLanguages + 1;
      break;
    end
    else
    begin
      fLanguages.LanguagesGrid.Cells[0, i] := IntToStr(ListLanguages[i].Id);
      fLanguages.LanguagesGrid.Cells[1, i] := ListLanguages[i].LnCode;
      fLanguages.LanguagesGrid.Cells[2, i] := ListLanguages[i].NameForEnter;
      fLanguages.LanguagesGrid.Cells[3, i] := ListLanguages[i].NameForRead;
      fLanguages.LanguagesGrid.Cells[4, i] := IntToStr(ListLanguages[i].Activ);
      vCountLanguages := i;
    end;
  end;
  }
  {
  fLanguages.Create(nil);
  fLanguages.Caption := 'My Modal Dialog Box';

  // Show your dialog box and provide an anonymous method that handles the closing of your dialog box.
  fLanguages.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      // Do something.
    end
  );
  }
//  vRes := fLanguages.ShowModal; //fLanguages.
  {
  if vRes = mrOK then
  begin
    for i := 1 to vCountLanguages do
    begin
      if (fLanguages.LanguagesGrid.Cells[0, i] = IntToStr(ListLanguages[i].Id))
        and (fLanguages.LanguagesGrid.Cells[1, i] = ListLanguages[i].LnCode)
      then
      begin
        ListLanguages[i].Activ :=
          StrToInt(fLanguages.LanguagesGrid.Cells[4, i]);
      end;

    end;
    SaveListLanguages(ListLanguages);
  end;
  }
end;

end.
