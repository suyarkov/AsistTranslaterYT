program AsistYou;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmMain in 'FrmMain.pas' {fMain},
  FmFirst in 'FmFirst.pas' {FrameFirst: TFrame},
  FmChannels in 'FmChannels.pas' {FrameChannels: TFrame},
  FrmDataSQLite in 'FrmDataSQLite.pas' {SQLiteModule: TDataModule},
  PnChannel in 'PnChannel.pas',
  FmProgressBar in 'FmProgressBar.pas' {FrameProgressBar: TFrame},
  FmProgressEndLess in 'FmProgressEndLess.pas' {FrameProgressEndLess: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TSQLiteModule, SQLiteModule);
  Application.Run;
end.
