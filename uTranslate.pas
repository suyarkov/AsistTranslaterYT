unit uTranslate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  System.JSON, System.Net.HTTPClient,
  System.NetEncoding;

function GoogleTranslate(const AValue, SourceLang, TargetLang: String): String;

function YoutubeGet(const AValue, ConstSourceLang, ConstTargetLang
  : String): String;

implementation

// перевод чего угодно на что угодно
{
function GoogleTranslate(const AValue, ConstSourceLang, ConstTargetLang
  : String): String;
var
  AResponce: IHTTPResponse;
  FHTTPClient: THTTPClient;
  AAPIUrl: String;
  j: Integer;
begin
  if AValue <> '' then
  begin
    AAPIUrl :=
      'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' +
      ConstSourceLang + '&tl=' + ConstTargetLang + '&dt=t&q=' +
      TNetEncoding.URL.Encode(AValue);
    FHTTPClient := THTTPClient.Create;
    FHTTPClient.UserAgent :=
      'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
    result := '';
    AResponce := FHTTPClient.Get(AAPIUrl);
    if Not Assigned(AResponce) then
    begin
      result := result + 'unknow.';
      Exit;
    end;

    try
      for j := 0 to TJSONArray
        (TJSONArray(TJSONObject.ParseJSONValue(AResponce.ContentAsString))
        .Items[0]).Count - 1 do
        result := result + TJSONArray
          (TJSONArray(TJSONArray(TJSONObject.ParseJSONValue
          (AResponce.ContentAsString)).Items[0]).Items[j]).Items[0].Value;
    except
      result := '';
      Exit;
    end;
  end;
end;
}

function GoogleTranslate(const AValue, SourceLang, TargetLang: String): String;
var
  AResponce: IHTTPResponse;
  FHTTPClient: THTTPClient;
  AAPIUrl: String;
  JSONArray, InnerArray, ItemArray: TJSONArray;
  ParsedValue: TJSONValue;
  j: Integer;
begin
  Result := '';
  if AValue = '' then
    Exit;

  FHTTPClient := THTTPClient.Create;
  try
    FHTTPClient.UserAgent :=
      'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';

    AAPIUrl := 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' +
      SourceLang + '&tl=' + TargetLang + '&dt=t&q=' +
      TNetEncoding.URL.Encode(AValue);

    AResponce := FHTTPClient.Get(AAPIUrl);

    if (AResponce = nil) or (AResponce.StatusCode <> 200) then
    begin
      Result := 'HTTP error';
      Exit;
    end;

    ParsedValue := TJSONObject.ParseJSONValue(AResponce.ContentAsString);
    try
      // ѕровер€ем структуру ответа
      if (ParsedValue <> nil) and (ParsedValue is TJSONArray) then
      begin
        JSONArray := TJSONArray(ParsedValue);
        if (JSONArray.Count > 0) and (JSONArray.Items[0] is TJSONArray) then
        begin
          InnerArray := TJSONArray(JSONArray.Items[0]);
          for j := 0 to InnerArray.Count - 1 do
          begin
            ItemArray := TJSONArray(InnerArray.Items[j]);
            // «ащита от неожиданных форматов
            if (ItemArray.Count > 0) then
              Result := Result + ItemArray.Items[0].Value;
          end;
        end;
      end;
    finally
      ParsedValue.Free;
    end;
  finally
    FHTTPClient.Free;
  end;
end;

function YoutubeGet(const AValue, ConstSourceLang, ConstTargetLang
  : String): String;
var
  AResponce: IHTTPResponse;
  FHTTPClient: THTTPClient;
  AAPIUrl: String;
  j: Integer;
begin
  if AValue <> '' then
  begin
    AAPIUrl := 'https://www.googleapis.com/youtube/v3';
  //    'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' +
//      ConstSourceLang + '&tl=' + ConstTargetLang + '&dt=t&q=' +
//      TNetEncoding.URL.Encode(AValue);
    FHTTPClient := THTTPClient.Create;
    FHTTPClient.UserAgent :=
      'Mozilla/5.0 (Windows; U; Windows NT 6.1; ru-RU) Gecko/20100625 Firefox/3.6.6';
    result := '';
    AResponce := FHTTPClient.Get(AAPIUrl);
    if Not Assigned(AResponce) then
    begin
      result := result + 'unknow.';
      Exit;
    end;

    try
       result := AResponce.ContentAsString;
    {
      for j := 0 to TJSONArray
        (TJSONArray(TJSONObject.ParseJSONValue(AResponce.ContentAsString))
        .Items[0]).Count - 1 do
        result := result + TJSONArray
          (TJSONArray(TJSONArray(TJSONObject.ParseJSONValue
          (AResponce.ContentAsString)).Items[0]).Items[j]).Items[0].Value;}
    except
      result := '2';
      Exit;
    end;
  end;
end;


end.
