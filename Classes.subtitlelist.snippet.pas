unit Classes.subtitlelist.snippet;

interface

uses Classes.video.thumbnails ;

type
  Tsubtitlelist_snippet = class
  private
    FvideoId: string;
    FlastUpdated: string; // дата формата "2023-10-04T18:52:43.594702Z"
    FtrackKind: string;
    Flanguage: string;
    Fname: string;
    FaudioTrackType: string;
    FisCC: boolean;
    FisLarge: boolean;
    FisEasyReader: boolean;
    FisDraft: boolean;
    FisAutoSynced: boolean;
    Fstatus: string;
    FfailureReason: string;
  public
    property videoId: string read FvideoId write FvideoId;
    property lastUpdated: string read FlastUpdated write FlastUpdated;
    property trackKind: string read FtrackKind write FtrackKind;
    property language: string read Flanguage write Flanguage;
    property name: string read Fname write Fname;
    property audioTrackType: string read FaudioTrackType write FaudioTrackType;
    property isCC: boolean read FisCC write FisCC;
    property isLarge: boolean read FisLarge write FisLarge;
    property isEasyReader: boolean read FisEasyReader write FisEasyReader;
    property isDraft: boolean read FisDraft write FisDraft;
    property isAutoSynced: boolean read FisAutoSynced write FisAutoSynced;
    property status: string read Fstatus write Fstatus;
    property failureReason: string read FfailureReason write FfailureReason;
  end;

implementation

end.