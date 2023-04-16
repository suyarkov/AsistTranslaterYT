program AsistTranslater;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmMain in 'FrmMain.pas' {FormMaon};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMaon, FormMaon);
  Application.Run;
end.
