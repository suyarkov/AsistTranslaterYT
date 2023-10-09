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
    procedure BTranslaterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

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

  // заголовки
  vCountLanguages := 0;
  fLanguages.LanguagesGrid.Cells[0, 0] := 'Id';
  fLanguages.LanguagesGrid.Cells[1, 0] := 'Код';
  fLanguages.LanguagesGrid.Cells[2, 0] := 'Для ввода';
  fLanguages.LanguagesGrid.Cells[3, 0] := 'Для чтения';
  // наполняем StringGrid значениями
  for i := 1 to 1000 do
  begin
    // пустые уже не добавляем а опусташаю
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
