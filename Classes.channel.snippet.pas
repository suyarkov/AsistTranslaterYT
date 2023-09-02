unit Classes.channel.snippet;

interface

uses Classes.shearche.thumbnails;

type
  Tchannel_snippet = class
  private
    Ftitle: string;
    Fdescription: string; //5000 символов
    FcustomUrl: string;
    FpublishedAt: string; // дата формата "2023-03-21T11:50:33Z"
    Fthumbnails: Tshearche_thumbnails; // описание картинок
    FdefaultLanguage: string;
    Fcountry: string;
  public
    property title: string read Ftitle write Ftitle;
    property customUrl: string read FcustomUrl write FcustomUrl;
    property description: string read Fdescription write Fdescription;
    property publishedAt: string read FpublishedAt write FpublishedAt;
    property thumbnails: Tshearche_thumbnails read Fthumbnails write Fthumbnails;
    property defaultLanguage: string read FdefaultLanguage write FdefaultLanguage;
    property country: string read Fcountry write Fcountry;
//    "localized": {
//                    "title": "Friendly Recipes",
//                    "description": "Hello everyone! \n\nWe moved to live in Poland.\nand for this I started a new channel\nhttps:\/\/www.youtube.com\/channel\/UCta8Fu2bQ9uVNr4VzARiwLA\n, please go to it.\nCamille\n\n\/*\nWe are Camille and Kristopher.\nWe love to cook!\nThere is little time for this, so we are preparing quick recipes.\nCamille loves vegetarian food, Christopher loves meat!\nWe both love sweets!\n\nWe decided to start this cooking channel to share our favorite recipes in a simple and easy to follow videos.\nHere you will see how to make easy and simple recipes every week.\nAnyone can cook it!\nIs our channel right for you?\nPlease subscribe to our channel and write to us whether you can cook according to our recipes.\n\nTell us your favorite recipes and we will try to cook them for ourselves.\n\nWe will be grateful to you. Thanks a lot!\n*\/\n"
  end;

implementation

end.