unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, uScenarioFrame;

type
  TScenarioEditForm = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    FScenario: TScenarioFrame;
  public
    { Public declarations }
  end;

var
  ScenarioEditForm: TScenarioEditForm;

implementation

{$R *.fmx}

procedure TScenarioEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FScenario.FDQuery.Active := false;
  FScenario.FDConnection.Connected := false;
  FScenario.FDExe.Active := false;
  FScenario.Free;
end;

procedure TScenarioEditForm.FormCreate(Sender: TObject);
begin
  FScenario := TScenarioFrame.Create(nil);
  FScenario.Parent := Self;
end;

end.
