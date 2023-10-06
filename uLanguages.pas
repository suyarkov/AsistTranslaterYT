unit uLanguages;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  System.JSON, System.Net.HTTPClient,
  System.NetEncoding,
  Character, FrmDataSQLite,
  uTranslate;

// загрузка из базы списка языков
function LoadListLanguages(): TListLanguages;
// перевод списка языков на язык интерфейса
procedure TranslateListLanguages(cLang: String; var pListLanguages:TListLanguages);

function GetLnCode(pNameRead: String): String;
// function GetLnCodeFromList(pNameRead: String;
//  pListLanguages: TListLanguages): String;
function GetNextLnCodeForEnter(pLastLnCode: String;
  pListLanguages: TListLanguages): String;
function GetNameEnterOnLnCodeFromList(pLnCode: String;
  pListLanguages: TListLanguages): String;

implementation

// Приводит первые буквы к верхнему регистру во всех словах переданного предложения
procedure UpperFirstLetterAllWord(var pSentence:String);
var
  i, IsPrevSpace: integer;
  vResult : string;
begin
  if Length(pSentence) > 0 then
  begin
    IsPrevSpace := 0;
    vResult := AnsiUpperCase(pSentence[1]);
    if Length(pSentence) > 1 then
      for i:= 2 to Length(pSentence) do
        begin
          if IsPrevSpace = 1 then
          begin
             vResult :=  vResult + AnsiUpperCase(pSentence[i]);
             IsPrevSpace := 0;
          end
          else vResult := vResult + pSentence[i];;
          if pSentence[i] = ' ' then IsPrevSpace := 1;
        end;
  end;
  pSentence := vResult;
end;

// Перевод списка языков на локальный  выбранный пользователем
procedure TranslateListLanguages(cLang: String; var pListLanguages:TListLanguages);
var
  i: integer;
begin
  i := 1;
  repeat
    if cLang = 'en' then
      pListLanguages[i].NameLocal :=  pListLanguages[i].NameEnglish
    else
      // перевод на требуемый язык названий языков
      pListLanguages[i].NameLocal := GoogleTranslate(pListLanguages[i].NameEnglish,
      'en', cLang);
      UpperFirstLetterAllWord(pListLanguages[i].NameLocal);
    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;

// получить следюущий код добавляемого языка
function GetNextLnCodeForEnter(pLastLnCode: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
  vFlNext: integer;
begin
  vFlNext := 0; // следующий пока не ищем
  result := '';
  if pLastLnCode = '' then
  begin
    vFlNext := 1; // если пустой то берем первый подходящий
  end;

  i := 1;
  repeat
    // нашли следующий язык для ввода
    if (vFlNext = 1) and (pListLanguages[i].Activ = 1) then
    begin
      result := pListLanguages[i].LnCode;
      i := 1000;
      break;
    end;

    if pLastLnCode = pListLanguages[i].LnCode then
    begin
      vFlNext := 1; // нашли текущий, искать следующий язык для ввода
    end;

    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;

// по строке с кодом языка определяем сам язык для ввода
function GetNameEnterOnLnCodeFromList(pLnCode: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
begin
  // уберем лишние пробеллы
  result := '';
  i := 1;
  repeat
    if pLnCode = pListLanguages[i].LnCode then
    begin
      result := ToUpper(pListLanguages[i].NameRussian); // в верхнем регистре
      i := 1000;
      break;
    end;
    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;

// загрузка из базы данных списка языков
function LoadListLanguages(): TListLanguages;
var
  vList: TListLanguages;
  i: integer;
begin
  vList := SQLiteModule.LoadLanguage();
  TranslateListLanguages('en', vList);
  result := vList;
end;

// по инициализации нового списка языков
function GetLnCode(pNameRead: String): String;
var
  vList: TListLanguages;
  i: integer;
begin
  vList := LoadListLanguages();
//  result := GetLnCodeFromList(pNameRead, vList);
end;

{
// по строке с наименованием языка определяем сам язык
function GetLnCodeFromList(pNameRead: String;
  pListLanguages: TListLanguages): String;
var
  i: integer;
  vUpperName: string;
begin
  // приведем к верхнему регистру и ANSI и UTF
  vUpperName := ToUpper(pNameRead);
  // уберем лишние пробеллы
  vUpperName := StringReplace(vUpperName, ' ', '',
    [rfReplaceAll, rfIgnoreCase]);
  result := 'unknown';
  i := 1;
  repeat
    if vUpperName = pListLanguages[i].NameForRead then
    begin
      result := pListLanguages[i].LnCode;
      i := 1000;
      break;
    end;
    inc(i);
  until (i >= 300) or (pListLanguages[i].LnCode = '');
end;
}


end.


{  i := 1;
  vList[i].Id := i;
  vList[i].LnCode := 'az';
//  vList[i].Russian := 'АЗЕРБАЙДЖАНСКИЙ';
  vList[i].NameRussian := 'Азербайджанский';

  i := 2;
  vList[i].Id := i;
  vList[i].LnCode := 'ar';
//  vList[i].NameForEnter := 'АРАБСКИЙ';
  vList[i].NameRussian := 'Арабский';

  i := 3;
  vList[i].Id := i;
  vList[i].LnCode := 'hy';
//  vList[i].NameForEnter := 'АРМЯНСКИЙ';
  vList[i].NameRussian := 'Армянский';

  i := 4;
  vList[i].Id := i;
  vList[i].LnCode := 'be';
//  vList[i].NameForEnter := 'БЕЛОРУССКИЙ';
  vList[i].NameRussian := 'Белорусский';

  i := 5;
  vList[i].Id := i;
  vList[i].LnCode := 'bn';
//  vList[i].NameForEnter := 'БЕНГАЛЬСКИЙ';
  vList[i].NameRussian := 'Бенгальский';

  i := 6;
  vList[i].Id := i;
  vList[i].LnCode := 'bg';
//  vList[i].NameForEnter := 'БОЛГАРСКИЙ';
  vList[i].NameRussian := 'Болгарский';

  i := 7;
  vList[i].Id := i;
  vList[i].LnCode := 'bs';
//  vList[i].NameForEnter := 'БОСНИЙСКИЙ';
  vList[i].NameRussian := 'Боснийский';

  i := 8;
  vList[i].Id := i;
  vList[i].LnCode := 'hu';
//  vList[i].NameForEnter := 'ВЕНГЕРСКИЙ';
  vList[i].NameRussian := 'Венгерский';

  i := 9;
  vList[i].Id := i;
  vList[i].LnCode := 'el';
//  vList[i].NameForEnter := 'ГРЕЧЕСКИЙ';
  vList[i].NameRussian := 'Греческий';

  i := 10;
  vList[i].Id := i;
  vList[i].LnCode := 'ka';
//  vList[i].NameForEnter := 'ГРУЗИНСКИЙ';
  vList[i].NameRussian := 'Грузинский';

  i := 11;
  vList[i].Id := i;
  vList[i].LnCode := 'da';
//  vList[i].NameForEnter := 'ДАТСКИЙ';
  vList[i].NameRussian := 'Датский';

  i := 12;
  vList[i].Id := i;
  vList[i].LnCode := 'iw';
//  vList[i].NameForEnter := 'ИВРИТ';
  vList[i].NameRussian := 'Иврит';

  i := 13;
  vList[i].Id := i;
  vList[i].LnCode := 'ga';
//  vList[i].NameForEnter := 'ИРЛАНДСКИЙ';
  vList[i].NameRussian := 'Ирландский';

  i := 14;
  vList[i].Id := i;
  vList[i].LnCode := 'is';
//  vList[i].NameForEnter := 'ИСЛАНДСКИЙ';
  vList[i].NameRussian := 'Исландский';

  i := 15;
  vList[i].Id := i;
  vList[i].LnCode := 'es';
//  vList[i].NameForEnter := 'ИСПАНСКИЙ';
  vList[i].NameRussian := 'Испанский';

  i := 16;
  vList[i].Id := i;
  vList[i].LnCode := 'it';
//  vList[i].NameForEnter := 'ИТАЛЬЯНСКИЙ';
  vList[i].NameRussian := 'Итальянский';

  i := 17;
  vList[i].Id := i;
  vList[i].LnCode := 'kk';
//  vList[i].NameForEnter := 'КАЗАХСКИЙ';
  vList[i].NameRussian := 'Казахский';

  i := 18;
  vList[i].Id := i;
  vList[i].LnCode := 'ky';
//  vList[i].NameForEnter := 'КИРГИЗСКИЙ';
  vList[i].NameRussian := 'Киргизский';

  i := 19;
  vList[i].Id := i;
  vList[i].LnCode := 'zh-CN';
//  vList[i].NameForEnter := 'КИТАЙСКИЙ';
  vList[i].NameRussian := 'Китайский';

  i := 20;
  vList[i].Id := i;
  vList[i].LnCode := 'ko';
//  vList[i].NameForEnter := 'КОРЕЙСКИЙ';
  vList[i].NameRussian := 'Корейский';

  i := 21;
  vList[i].Id := i;
  vList[i].LnCode := 'la';
//  vList[i].NameForEnter := 'ЛАТИНСКИЙ';
  vList[i].NameRussian := 'Латинский';

  i := 22;
  vList[i].Id := i;
  vList[i].LnCode := 'lv';
//  vList[i].NameForEnter := 'ЛАТЫШСКИЙ';
  vList[i].NameRussian := 'Латышский';

  i := 23;
  vList[i].Id := i;
  vList[i].LnCode := 'lt';
//  vList[i].NameForEnter := 'ЛИТОВСКИЙ';
  vList[i].NameRussian := 'Литовский';

  i := 24;
  vList[i].Id := i;
  vList[i].LnCode := 'lb';
//  vList[i].NameForEnter := 'ЛЮКСЕМБУРСКИЙ';
  vList[i].NameRussian := 'Люксембурский';

  i := 25;
  vList[i].Id := i;
  vList[i].LnCode := 'ms';
//  vList[i].NameForEnter := 'МАЛАЙСКИЙ';
  vList[i].NameRussian := 'Малайский';

  i := 26;
  vList[i].Id := i;
  vList[i].LnCode := 'mn';
//  vList[i].NameForEnter := 'МОНГОЛЬСКИЙ';
  vList[i].NameRussian := 'Монгольский';

  i := 27;
  vList[i].Id := i;
  vList[i].LnCode := 'de';
//  vList[i].NameForEnter := 'НЕМЕЦКИЙ';
  vList[i].NameRussian := 'Немецкий';

  i := 28;
  vList[i].Id := i;
  vList[i].LnCode := 'nl';
//  vList[i].NameForEnter := 'НИДЕРЛАНДСКИЙ';
  vList[i].NameRussian := 'Нидерландский';

  i := 29;
  vList[i].Id := i;
  vList[i].LnCode := 'no';
//  vList[i].NameForEnter := 'НОРВЕЖСКИЙ';
  vList[i].NameRussian := 'Норвежский';

  i := 30;
  vList[i].Id := i;
  vList[i].LnCode := 'pl';
//  vList[i].NameForEnter := 'ПОЛЬСКИЙ';
  vList[i].NameRussian := 'Польский';

  i := 31;
  vList[i].Id := i;
  vList[i].LnCode := 'pt';
//  vList[i].NameForEnter := 'ПОРТУГАЛЬСКИЙ';
  vList[i].NameRussian := 'Португальский';

  i := 32;
  vList[i].Id := i;
  vList[i].LnCode := 'ro';
//  vList[i].NameForEnter := 'РУМЫНСКИЙ';
  vList[i].NameRussian := 'Румынский';

  i := 33;
  vList[i].Id := i;
  vList[i].LnCode := 'ru';
//  vList[i].NameForEnter := 'РУССКИЙ';
  vList[i].NameRussian := 'Русский';

  i := 34;
  vList[i].Id := i;
  vList[i].LnCode := 'sr';
//  vList[i].NameForEnter := 'СЕРБСКИЙ';
  vList[i].NameRussian := 'Сербский';

  i := 35;
  vList[i].Id := i;
  vList[i].LnCode := 'si';
//  vList[i].NameForEnter := 'СИГНАЛЬСКИЙ';
  vList[i].NameRussian := 'Сигнальский';

  i := 36;
  vList[i].Id := i;
  vList[i].LnCode := 'sk';
//  vList[i].NameForEnter := 'СЛОВАЦКИЙ';
  vList[i].NameRussian := 'Словацкий';

  i := 37;
  vList[i].Id := i;
  vList[i].LnCode := 'so';
//  vList[i].NameForEnter := 'СЛОВЕНСКИЙ';
  vList[i].NameRussian := 'Словенский';

  i := 38;
  vList[i].Id := i;
  vList[i].LnCode := 'tr';
//  vList[i].NameForEnter := 'ТУРЕЦКИЙ';
  vList[i].NameRussian := 'Турецкий';

  i := 39;
  vList[i].Id := i;
  vList[i].LnCode := 'uz';
//  vList[i].NameForEnter := 'УЗБЕКСКИЙ';
  vList[i].NameRussian := 'Узбекский';

  i := 40;
  vList[i].Id := i;
  vList[i].LnCode := 'uk';
//  vList[i].NameForEnter := 'УКРАИНСКИЙ';
  vList[i].NameRussian := 'Украинский';

  i := 41;
  vList[i].Id := i;
  vList[i].LnCode := 'ur';
//  vList[i].NameForEnter := 'УРДУ';
  vList[i].NameRussian := 'Урду';

  i := 42;
  vList[i].Id := i;
  vList[i].LnCode := 'fi';
//  vList[i].NameForEnter := 'ФИНСКИЙ';
  vList[i].NameRussian := 'Финский';

  i := 43;
  vList[i].Id := i;
  vList[i].LnCode := 'fr';
//  vList[i].NameForEnter := 'ФРАНЦУЗСКИЙ';
  vList[i].NameRussian := 'Французский';

  i := 44;
  vList[i].Id := i;
  vList[i].LnCode := 'hi';
//  vList[i].NameForEnter := 'ХИНДИ';
  vList[i].NameRussian := 'Хинди';

  i := 45;
  vList[i].Id := i;
  vList[i].LnCode := 'hr';
//  vList[i].NameForEnter := 'ХОРВАТСКИЙ';
  vList[i].NameRussian := 'Хорватский';

  i := 46;
  vList[i].Id := i;
  vList[i].LnCode := 'cs';
//  vList[i].NameForEnter := 'ЧЕШСКИЙ';
  vList[i].NameRussian := 'Чешский';

  i := 47;
  vList[i].Id := i;
  vList[i].LnCode := 'sv';
//  vList[i].NameForEnter := 'ШВЕДСКИЙ';
  vList[i].NameRussian := 'Шведский';

  i := 48;
  vList[i].Id := i;
  vList[i].LnCode := 'et';
//  vList[i].NameForEnter := 'ЭСТОНСКИЙ';
  vList[i].NameRussian := 'Эстонский';

  i := 49;
  vList[i].Id := i;
  vList[i].LnCode := 'ja';
//  vList[i].NameForEnter := 'ЯПОНСКИЙ';
  vList[i].NameRussian := 'Японский';
}
