unit uSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, uTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, uWork;

type
  TFormSettings = class(TForm)
    layMenu: TLayout;
    btnAddScenario: TCornerButton;
    Label6: TLabel;
    edLogin: TEdit;
    Layout1: TLayout;
    gb1: TGroupBox;
    Label1: TLabel;
    edHost: TEdit;
    Label7: TLabel;
    edPort: TEdit;
    Layout3D1: TLayout3D;
    Label2: TLabel;
    edPass: TEdit;
    Label3: TLabel;
    edRecipient: TEdit;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    btnSendControl: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure SaveData(Sender: TObject);
    procedure btnAddScenarioClick(Sender: TObject);
    procedure btnSendControlClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.fmx}

procedure TFormSettings.btnAddScenarioClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormSettings.btnSendControlClick(Sender: TObject);
var
  SendText: TStringList;
begin
  SendText := TStringList.Create;
  SendText.Append('Все отлично!' + #13#13 + 'Это сообщение отправлено для проверки. Можете не отвечать на него.');
  SendMessage('Тестовое письмо от RobotCash', SendText, FDQuery);
end;

procedure TFormSettings.FormCreate(Sender: TObject);
begin
  FDConnection.Params.Database := ExtractFilePAth(paramstr(0)) + '\base.db';
  FDConnection.Connected := true;

  ExeQ(FDQuery, 'select host,port,login,password,recipient from settings', TTypeSql.tsActive);

  edHost.Text := FDQuery.FieldByName('host').AsString;
  edPort.Text := FDQuery.FieldByName('port').AsString;
  edLogin.Text := FDQuery.FieldByName('login').AsString;
  edPass.Text := FDQuery.FieldByName('password').AsString;
  edRecipient.Text := FDQuery.FieldByName('recipient').AsString;

  edHost.OnChangeTracking := SaveData;
  edPort.OnChangeTracking := SaveData;
  edLogin.OnChangeTracking := SaveData;
  edPass.OnChangeTracking := SaveData;
  edRecipient.OnChangeTracking := SaveData;
end;

procedure TFormSettings.SaveData(Sender: TObject);
begin
  if edPort.Text = '' then
    edPort.Text := '0';

  ExeQ(FDQuery, 'update settings set host = ''' + edHost.Text + ''', port=' + edPort.Text + ', login = ''' + edLogin.Text + ''', password = ''' + edPass.Text + ''', recipient=''' + edRecipient.Text +
    '''', tsExec);
end;

end.
