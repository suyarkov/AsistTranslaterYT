unit Classes.video.snippet;

interface

uses Classes.video.thumbnails ;

type
  Tvideo_snippet = class
  private
    FpublishedAt: string; // ���� ������� "2023-03-21T11:50:33Z"
    FchannelId: string;
    Ftitle: string;
    Fdescription: string; //5000 ��������
    Fthumbnails: Tvideo_thumbnails; // �������� ��������
    FchannelTitle: string;
    FliveBroadcastContent: string;
    FpublishTime: string; // ���� ������� "2023-03-21T11:50:33Z"
    FdefaultLanguage : string;
  public
    property publishedAt: string read FpublishedAt write FpublishedAt;
    property channelId: string read FchannelId write FchannelId;
    property title: string read Ftitle write Ftitle;
    property description: string read Fdescription write Fdescription;
    property thumbnails: Tvideo_thumbnails read Fthumbnails write Fthumbnails;
    property channelTitle: string read FchannelTitle write FchannelTitle;
    property liveBroadcastContent: string read FliveBroadcastContent write FliveBroadcastContent;
    property publishTime: string read FpublishTime write FpublishTime;
    property defaultLanguage: string read FdefaultLanguage write FdefaultLanguage;

  end;

implementation

end.