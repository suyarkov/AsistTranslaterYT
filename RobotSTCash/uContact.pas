unit uContact;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TContactForm = class(TForm)
    Label7: TLabel;
    labCopyright: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ContactForm: TContactForm;

implementation

{$R *.fmx}

procedure TContactForm.FormCreate(Sender: TObject);
var
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Create;
  fs.ShortDateFormat := 'yyyy';

  labCopyright.Text := Format(labCopyright.Text, [DateToStr(Now(), fs)]);
end;

end.
