program AssistIQ;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrmMain in 'FrmMain.pas' {fMain},
  FmFirst in 'FmFirst.pas' {FrameFirst: TFrame},
  FmChannels in 'FmChannels.pas' {FrameChannels: TFrame},
  FrmDataSQLite in 'FrmDataSQLite.pas' {SQLiteModule: TDataModule},
  PnChannel in 'PnChannel.pas',
  FmProgressBar in 'FmProgressBar.pas' {FrameProgressBar: TFrame},
  FmProgressEndLess in 'FmProgressEndLess.pas' {FrameProgressEndLess: TFrame},
  OAuth2 in 'OAuth2.pas',
  Classes.channel.item in 'Classes.channel.item.pas',
  Classes.channel.items in 'Classes.channel.items.pas',
  Classes.channel in 'Classes.channel.pas',
  Classes.channel.snippet in 'Classes.channel.snippet.pas',
  Classes.channel.statistics in 'Classes.channel.statistics.pas',
  Classes.shearche.id in 'Classes.shearche.id.pas',
  Classes.shearche.image in 'Classes.shearche.image.pas',
  Classes.shearche.item in 'Classes.shearche.item.pas',
  Classes.shearche.items in 'Classes.shearche.items.pas',
  Classes.shearche.pageInfo in 'Classes.shearche.pageInfo.pas',
  Classes.shearche in 'Classes.shearche.pas',
  Classes.shearche.snippet in 'Classes.shearche.snippet.pas',
  Classes.shearche.thumbnails in 'Classes.shearche.thumbnails.pas',
  Classes.video.item in 'Classes.video.item.pas',
  Classes.video in 'Classes.video.pas',
  Classes.video.snippet in 'Classes.video.snippet.pas',
  Classes.video.thumbnails in 'Classes.video.thumbnails.pas',
  uEmailSend in 'uEmailSend.pas',
  uTranslate in 'uTranslate.pas',
  uQ in 'uQ.pas',
  FmVideos in 'FmVideos.pas' {FrameVideos: TFrame},
  PnVideo in 'PnVideo.pas',
  FmMainChannel in 'FmMainChannel.pas' {FrameMainChannel: TFrame},
  Classes.videoinfo in 'Classes.videoinfo.pas',
  Classes.videoInfo.itemInfo in 'Classes.videoInfo.itemInfo.pas',
  uLanguages in 'uLanguages.pas',
  FmLanguages in 'FmLanguages.pas' {FrameLanguages: TFrame},
  PnLanguage in 'PnLanguage.pas',
  FmAsk in 'FmAsk.pas' {FrameAsk: TFrame},
  FmInfo in 'FmInfo.pas' {FrameInfo: TFrame},
  Classes.subtitlelist.item in 'Classes.subtitlelist.item.pas',
  Classes.subtitlelist in 'Classes.subtitlelist.pas',
  Classes.subtitlelist.snippet in 'Classes.subtitlelist.snippet.pas',
  FmAddUser in 'FmAddUser.pas' {FrameAddUser: TFrame},
  FmTextInput in 'FmTextInput.pas' {FrameTextInput: TFrame},
  FmHelp in 'FmHelp.pas' {FrameHelp: TFrame},
  FmAddMoney in 'FmAddMoney.pas' {FrameAddMoney: TFrame},
  Classes.title in 'Classes.title.pas',
  Classes.snippet in 'Classes.snippet.pas',
  Classes.snippetInsert in 'Classes.snippetInsert.pas',
  System.Net.Mime in 'System.Net.Mime.pas',
  uWinHardwareInfo in 'uWinHardwareInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TSQLiteModule, SQLiteModule);
  Application.Run;
end.
