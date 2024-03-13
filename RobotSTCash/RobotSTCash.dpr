program RobotSTCash;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {ScenarioEditForm},
  uContact in 'uContact.pas' {ContactForm},
  uScheduler in 'uScheduler.pas' {FormScheduler},
  uStartForm in 'uStartForm.pas' {StartForm},
  uScenarioFrame in 'uScenarioFrame.pas' {ScenarioFrame: TFrame},
  uStopStart in 'uStopStart.pas' {FormStopStart},
  uWork in 'uWork.pas',
  uTypes in 'uTypes.pas',
  uSettings in 'uSettings.pas' {FormSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TStartForm, StartForm);
  Application.Run;
end.
