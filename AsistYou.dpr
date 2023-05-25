program AsistYou;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmMain in 'FrmMain.pas' {fMain},
  FmFirst in 'FmFirst.pas' {FrameFirst: TFrame},
  FmChannels in 'FmChannels.pas' {FrameChannels: TFrame},
  FrmDataSQLite in 'FrmDataSQLite.pas' {SQLiteModule: TDataModule},
  ChannelPanel in 'ChannelPanel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TSQLiteModule, SQLiteModule);
  Application.Run;
end.
