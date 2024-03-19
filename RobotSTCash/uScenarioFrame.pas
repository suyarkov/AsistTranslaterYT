unit uScenarioFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, uContact,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, ShellAPI,
  FMX.TabControl, FMX.Edit, FMX.EditBox, FMX.NumberBox, Winapi.Windows, FMX.Platform, System.Threading,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, Messages, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Comp.UI,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, System.ImageList, System.RegularExpressions,
  FMX.ImgList, FMX.Objects, shlobj, FMX.SpinBox, IdIPMCastBase, IdIPMCastServer, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, Generics.Collections, uTypes, uWork,
  FMX.Effects;

type

  TScenarioFrame = class(TFrame)
    btnAdd: TSpeedButton;
    btnDel: TSpeedButton;
    PopupMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    TabControl: TTabControl;
    tabPos: TTabItem;
    tabSleep: TTabItem;
    btnTrackingStart: TSpeedButton;
    timerCheckTrack: TTimer;
    timerGetPos: TTimer;
    editPosCursor: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    btnStart: TSpeedButton;
    tabScroll: TTabItem;
    Label5: TLabel;
    numScroll: TNumberBox;
    MenuItem5: TMenuItem;
    swScroll: TSwitch;
    Label9: TLabel;
    Label10: TLabel;
    btnViewPos: TSpeedButton;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    ImageList: TImageList;
    MenuItem21: TMenuItem;
    tabSeparator: TTabItem;
    Label15: TLabel;
    edSeparator: TEdit;
    Layout1: TLayout;
    sleepTime: TSpinBox;
    Layout2: TLayout;
    Layout3: TLayout;
    layBtnTest: TLayout;
    Layout5: TLayout;
    layCenter: TLayout;
    layBtns: TLayout;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem7: TMenuItem;
    tabHotKey: TTabItem;
    cbShift: TComboBox;
    cbShiftLitter: TComboBox;
    Label3: TLabel;
    MenuItem8: TMenuItem;
    layMenuEdit: TLayout;
    btnBack: TCornerButton;
    TabControlScenario: TTabControl;
    tabList: TTabItem;
    tabEdit: TTabItem;
    ListView: TListView;
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    FDExe: TFDQuery;
    FDItems: TFDQuery;
    layEdit: TLayout;
    Rectangle1: TRectangle;
    RoundRect1: TRoundRect;
    edNameScenario: TEdit;
    Label4: TLabel;
    btnCreate: TCornerButton;
    btnCancelCreate: TCornerButton;
    btnAddScenario: TCornerButton;
    btnDelScenario: TCornerButton;
    btnEdit: TCornerButton;
    TabWaitWindow: TTabItem;
    ObjectList: TVertScrollBox;
    layDialogs: TLayout;
    Layout10: TLayout;
    btnAddDialog: TCornerButton;
    gb1: TGroupBox;
    Label6: TLabel;
    edWindow1: TEdit;
    Label7: TLabel;
    edScenario1: TEdit;
    btnScenario1: TSpeedButton;
    gb5: TGroupBox;
    Label8: TLabel;
    edWindow5: TEdit;
    Label11: TLabel;
    edScenario5: TEdit;
    btnScenario5: TSpeedButton;
    gb4: TGroupBox;
    Label12: TLabel;
    edWindow4: TEdit;
    Label13: TLabel;
    edScenario4: TEdit;
    btnScenario4: TSpeedButton;
    gb3: TGroupBox;
    Label14: TLabel;
    edWindow3: TEdit;
    Label16: TLabel;
    edScenario3: TEdit;
    btnScenario3: TSpeedButton;
    gb2: TGroupBox;
    Label17: TLabel;
    edWindow2: TEdit;
    Label18: TLabel;
    edScenario2: TEdit;
    btnScenario2: TSpeedButton;
    layChoose: TLayout;
    Rectangle2: TRectangle;
    RoundRect2: TRoundRect;
    Label19: TLabel;
    btnChosse: TCornerButton;
    btnCancelChoose: TCornerButton;
    layScenariesChoose: TLayout;
    layMenu: TLayout;
    btnDelDialog: TCornerButton;
    Layout3D1: TLayout3D;
    Layout7: TLayout;
    edNameBlockPos: TEdit;
    Label21: TLabel;
    Label20: TLabel;
    MenuItem4: TMenuItem;
    MenuItem9: TMenuItem;
    tabStop: TTabItem;
    Label23: TLabel;
    edScenario6: TEdit;
    btnAddStopScenario: TSpeedButton;
    swType1: TSwitch;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    swType2: TSwitch;
    Label26: TLabel;
    Label27: TLabel;
    swType3: TSwitch;
    Label28: TLabel;
    Label29: TLabel;
    swType4: TSwitch;
    Label30: TLabel;
    Label31: TLabel;
    swType5: TSwitch;
    Label32: TLabel;
    VertScrollBox1: TVertScrollBox;
    btnClean1: TSpeedButton;
    btnClean2: TSpeedButton;
    btnClean3: TSpeedButton;
    btnClean4: TSpeedButton;
    btnClean5: TSpeedButton;
    eScenarioName: TEdit;
    Label33: TLabel;
    MenuItem6: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem16: TMenuItem;
    TabScenario: TTabItem;
    TabStep: TTabItem;
    Label34: TLabel;
    edScenario7: TEdit;
    btnScenario7: TSpeedButton;
    btnClearScenario: TSpeedButton;
    btnClean6: TSpeedButton;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    tabScreen: TTabItem;
    tabSend: TTabItem;
    mMessageText: TMemo;
    cbSendFile: TCheckBox;
    edFileSend: TEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    edNameFile: TEdit;
    btnInfoWaiting: TCornerButton;
    layInfo: TLayout;
    Rectangle3: TRectangle;
    ShadowEffect1: TShadowEffect;
    btnCloseInfo: TCornerButton;
    Memo: TMemo;
    MenuItem19: TMenuItem;
    btnCopy: TCornerButton;
    Label39: TLabel;
    edParamStep: TEdit;
    Label40: TLabel;
    mConditions: TMemo;
    btnInfoStep: TCornerButton;
    Memo2: TMemo;
    btnSetPosition: TCornerButton;
    layBtnCancelPosition: TLayout;
    Rectangle4: TRectangle;
    btnCanceltoSelPosition: TCornerButton;
    Label41: TLabel;
    btnApplyPosition: TCornerButton;
    Label35: TLabel;
    numClick: TNumberBox;
    Label42: TLabel;
    procedure btnAddClick(Sender: TObject);
    procedure timerGetPosTimer(Sender: TObject);
    procedure timerCheckTrackTimer(Sender: TObject);
    procedure btnTrackingStartClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure sleepTimeChangeTracking(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure numScrollChangeTracking(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem25Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure cbShiftLitterChange(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddScenarioClick(Sender: TObject);
    procedure btnCancelCreateClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDelScenarioClick(Sender: TObject);
    procedure ListViewItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure btnAddDialogClick(Sender: TObject);
    procedure btnScenario1Click(Sender: TObject);
    procedure btnChosseClick(Sender: TObject);
    procedure btnCancelChooseClick(Sender: TObject);
    procedure btnDelDialogClick(Sender: TObject);
    procedure SaveDialogData(Sender: TObject);
    procedure edSeparatorChangeTracking(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure edNameBlockPosChangeTracking(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure edScenario6ChangeTracking(Sender: TObject);
    procedure btnClean1Click(Sender: TObject);
    procedure eScenarioNameChangeTracking(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure edScenario7ChangeTracking(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure cbSendFileChange(Sender: TObject);
    procedure mMessageTextChangeTracking(Sender: TObject);
    procedure edFileSendChangeTracking(Sender: TObject);
    procedure edNameFileChangeTracking(Sender: TObject);
    procedure btnInfoWaitingClick(Sender: TObject);
    procedure btnCloseInfoClick(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure btnInfoStepClick(Sender: TObject);
    procedure edParamStepChangeTracking(Sender: TObject);
    procedure btnSetPositionClick(Sender: TObject);
    procedure btnCanceltoSelPositionClick(Sender: TObject);

  private
    OldPos: TPoint;
    Svc: IFMXClipboardService;
    ATimer: TTimer;
    FScenario: TScenarioFrame;
    Line: integer;
    SelItem: TRectangle;
    SelItemStep: TRectangle;
    LoadScenariesID: integer;
    FScenarioItems: TList<TDict>;
    ItemHint: PWideChar;
    FThread: ITask;
    FWork: TWork;

    procedure ItemsClick(Sender: TObject);
    procedure CreateItem(itemType: integer; itemOrder, ItemValue: string; ToSave: boolean = true);
    procedure LoadData(AItemID: integer);
    function IsNeedPos: boolean;
    function CreateBlock: TRectangle;
    procedure CreateDialogs(ParentDialogs: TRectangle; ItemHint: string);

    function CreateBoxNotHint(itemType: integer; itemOrder, itemText: string): TRectangle;
    function CreateBox(itemType : integer; itemOrder, itemText, ItemHint: string): TRectangle;
    procedure ExecuteScenario;
    procedure NextStep(IsSuccess: boolean);
    procedure SaveTabSend;
    procedure RePaintStepTo;

    { Private declarations }

  public
    UserName: string;
    procedure StartStopTest;
    constructor Create(AOwner: TFMXObject; AWhere: string = ''); overload;
    { Public declarations }
  end;

implementation

uses
  uStopStart;

var
  AFormStopStart: TFormStopStart;
{$R *.fmx}

procedure TScenarioFrame.btnAddClick(Sender: TObject);
begin
  PopupMenu.Popup(Screen.MousePos.X, Screen.MousePos.Y);
end;

procedure TScenarioFrame.btnAddDialogClick(Sender: TObject);
var
  I: integer;
begin

  btnAddDialog.Tag := btnAddDialog.Tag + 1;
  layDialogs.Height := 130 * btnAddDialog.Tag;

  (FindComponent('gb' + btnAddDialog.Tag.ToString) as TGroupBox).Visible := true;
  btnAddDialog.Visible := btnAddDialog.Tag < 5;
  btnDelDialog.Visible := btnAddDialog.Tag > 1;

  SaveDialogData(nil);
end;

procedure TScenarioFrame.btnAddScenarioClick(Sender: TObject);
begin
  layEdit.Visible := true;
  btnCreate.Tag := (Sender as TCornerButton).Tag;
end;

procedure TScenarioFrame.btnBackClick(Sender: TObject);
begin
  TabControlScenario.Previous();
end;

procedure TScenarioFrame.btnCancelChooseClick(Sender: TObject);
begin
  layChoose.Visible := false;

  FScenario.FDQuery.Active := false;
  FScenario.FDExe.Active := false;
  FScenario.FDConnection.Connected := false;

  FreeAndNil(FScenario);
end;

procedure TScenarioFrame.btnCancelCreateClick(Sender: TObject);
begin
  layEdit.Visible := false;
  edNameScenario.Text := '';
end;

procedure TScenarioFrame.btnCanceltoSelPositionClick(Sender: TObject);
var
  I: integer;
begin

  if (Sender as TCornerButton) = btnApplyPosition then
  begin
    if SelItemStep = nil then
    begin
      showmessage('Вы не указали позицию перехода.');
      exit;
    end;

    btnSetPosition.Tag := ObjectList.Content.Children.IndexOf(SelItemStep);
    edParamStepChangeTracking(nil);
    RePaintStepTo;
  end;

  layMenuEdit.Enabled := true;
  layBtnTest.Enabled := true;
  layCenter.Enabled := true;
  layBtnCancelPosition.Visible := false;

end;

procedure TScenarioFrame.btnChosseClick(Sender: TObject);
begin

  if FScenario.ListView.Selected <> nil then
  begin

    (FindComponent('edScenario' + FScenario.Tag.ToString) as TEdit).Tag := FScenario.ListView.Items[FScenario.ListView.Selected.Index].ImageIndex;
    (FindComponent('edScenario' + FScenario.Tag.ToString) as TEdit).Text := FScenario.ListView.Items[FScenario.ListView.Selected.Index].Text;

    btnCancelChooseClick(nil);
  end;

end;

procedure TScenarioFrame.btnClean1Click(Sender: TObject);
begin
  (FindComponent('edScenario' + (Sender as TSpeedButton).Tag.ToString) as TEdit).Tag := -1;
  (FindComponent('edScenario' + (Sender as TSpeedButton).Tag.ToString) as TEdit).Text := '';
end;

procedure TScenarioFrame.btnCloseInfoClick(Sender: TObject);
begin
  layInfo.Visible := false;
end;

procedure TScenarioFrame.btnCreateClick(Sender: TObject);
begin
  if btnCreate.Tag = tcNew then
  begin
    ExeQ(FDExe, Format('insert into scenaries (name) values (''%s'');', [edNameScenario.Text]), tsExec);

    FDQuery.Active := false;
    FDQuery.Active := true;

    ExeQ(FDExe, 'select max(id) as id from scenaries', tsActive);
    LoadScenariesID := FDExe.FieldByName('id').AsInteger;
    eScenarioName.Text := edNameScenario.Text;
    LoadData(LoadScenariesID);
    FDExe.Active := false;
    TabControlScenario.Next();
    btnCancelCreateClick(nil);
  end
  else if btnCreate.Tag = tcCopy then
  begin
    ExeQ(FDExe, Format('insert into scenaries (name) values (''%s'');', [edNameScenario.Text]), tsExec);
    ExeQ(FDExe, 'select max(id) as id from scenaries', tsActive);
    LoadScenariesID := FDExe.FieldByName('id').AsInteger;
    ExeQ(FDExe, Format('insert into scenario_item (id, value,order_id,id_scenario ) select id, value,order_id,%d from scenario_item where id_scenario = %d',
      [LoadScenariesID, ListView.Items[ListView.Selected.Index].ImageIndex]), tsExec);

    FDQuery.Active := false;
    FDQuery.Active := true;

    eScenarioName.Text := edNameScenario.Text;
    LoadData(LoadScenariesID);
    FDExe.Active := false;
    TabControlScenario.Next();
    btnCancelCreateClick(nil);
  end;
end;

procedure TScenarioFrame.btnDelClick(Sender: TObject);
var
  IndexSel: integer;
begin
  if Messagedlg('Подтверждаете удаление этого блока?', TMSGdlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = 6 then
  begin
    if (SelItem <> nil) then
    begin
      IndexSel := ObjectList.Content.Children.IndexOf(SelItem);
      SelItem := nil;
      FDExe.Active := false;
      FDExe.SQL.Clear;
      FDExe.SQL.Add(Format('delete from scenario_item where id_scenario=%d and order_id = %d;', [LoadScenariesID, IndexSel]));
      FDExe.SQL.Add(Format('update scenario_item set order_id = order_id - 1 where id_scenario=%d and order_id > %d;', [LoadScenariesID, IndexSel]));

      FDExe.ExecSQL;

      LoadData(LoadScenariesID);
      TabControl.Visible := false;

      if (IndexSel > 0) and (IndexSel <= ObjectList.Content.ChildrenCount) then
        SelItem := (ObjectList.Content.Children[IndexSel - 1] as TRectangle)
      else if ObjectList.Content.ChildrenCount <> 0 then
        SelItem := (ObjectList.Content.Children[0] as TRectangle);

      if SelItem <> nil then
      begin
        ItemsClick(SelItem);
        ObjectList.ScrollTo(0, Round(-SelItem.Position.Y + ObjectList.Height / 2 - SelItem.Height / 2));
      end;
    end;
  end;
end;

procedure TScenarioFrame.btnDelDialogClick(Sender: TObject);
var
  I: integer;
begin

  (FindComponent('gb' + btnAddDialog.Tag.ToString) as TGroupBox).Visible := false;
  btnAddDialog.Tag := btnAddDialog.Tag - 1;
  layDialogs.Height := 130 * btnAddDialog.Tag;

  btnDelDialog.Visible := btnAddDialog.Tag > 1;
  btnAddDialog.Visible := btnAddDialog.Tag < 5;

  SaveDialogData(nil);
end;

procedure TScenarioFrame.btnDelScenarioClick(Sender: TObject);
var
  ID: integer;
begin
  if Messagedlg('Вы уверены, что хотите удалить выбранный сценарий?', TMSGdlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = 6 then
  begin
    ID := ListView.Items[ListView.Selected.Index].ImageIndex;
    FDExe.Active := false;
    FDExe.SQL.Clear;
    FDExe.SQL.Append(Format('delete from scenaries where id = %d;', [ID]));
    FDExe.SQL.Append(Format('delete from scenaries_tree where id_scenario = %d;', [ID]));
    FDExe.SQL.Append(Format('delete from scenario_item where id_scenario = %d;', [ID]));
    FDExe.ExecSQL;

    FDQuery.Active := false;
    FDQuery.Active := true;

    btnEdit.Enabled := false;
    btnCopy.Enabled := false;
    btnDelScenario.Enabled := false;
  end;
end;

procedure TScenarioFrame.btnDownClick(Sender: TObject);
var
  CurrIndex: integer;
  CurrItem: TRectangle;
  tmpHint: string;
begin
  CurrIndex := ObjectList.Content.Children.IndexOf(SelItem);

  if (CurrIndex < ObjectList.Content.ChildrenCount - 1) and (SelItem.Tag <> itemStop) then
  begin
    FDExe.Active := false;

    FDExe.SQL.Clear;

    if SelItem.Tag <> itemStep then
      FDExe.SQL.Append
        (StringReplace
        (Format('update scenario_item set value = Replace(value,''<sep>%d'',''<sep>%d'') where id_scenario = %d and order_id = (select order_id from scenario_item s where s.id_scenario = id_scenario and id = 13 and value like ''proc<sep>%d'' );',
        [CurrIndex, CurrIndex + 1, LoadScenariesID, CurrIndex]), 'proc', '%', [rfReplaceAll]))
    else
    begin
      tmpHint := SelItem.Hint;
      Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
      Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);

      if CurrIndex = tmpHint.ToInteger() - 1 then

        FDExe.SQL.Append
          (StringReplace
          (Format('update scenario_item set value = Replace(value,''<sep>%d'',''<sep>%d'') where id_scenario = %d and order_id = (select order_id from scenario_item s where s.id_scenario = id_scenario and id = 13 and value like ''proc<sep>%d'' );',
          [CurrIndex + 1, CurrIndex, LoadScenariesID, CurrIndex + 1]), 'proc', '%', [rfReplaceAll]));

    end;
    FDExe.SQL.Append(Format('update scenario_item set order_id = 999999 where id_scenario=%d and order_id = %d;', [LoadScenariesID, CurrIndex]));
    FDExe.SQL.Append(Format('update scenario_item set order_id = %d where id_scenario=%d and order_id = %d;', [CurrIndex, LoadScenariesID, CurrIndex + 1]));
    FDExe.SQL.Append(Format('update scenario_item set order_id = %d where id_scenario=%d and order_id = 999999;', [CurrIndex + 1, LoadScenariesID]));
    FDExe.ExecSQL;
    LoadData(LoadScenariesID);

    CurrItem := (ObjectList.Content.Children[CurrIndex + 1] as TRectangle);
    ItemsClick(CurrItem);
    ObjectList.ScrollTo(0, Round(-CurrItem.Position.Y + ObjectList.Height / 2 - CurrItem.Height / 2));
  end;

end;

procedure TScenarioFrame.btnEditClick(Sender: TObject);
begin
  LoadScenariesID := ListView.Items[ListView.Selected.Index].ImageIndex;
  eScenarioName.Text := ListView.Items[ListView.Selected.Index].Text;
  LoadData(LoadScenariesID);
  TabControlScenario.Next();
end;

procedure TScenarioFrame.btnInfoStepClick(Sender: TObject);
begin
  layInfo.Visible := true;
  Memo.Visible := false;
  Memo2.Visible := true;
end;

procedure TScenarioFrame.btnInfoWaitingClick(Sender: TObject);
begin
  layInfo.Visible := true;
  Memo.Visible := true;
  Memo2.Visible := false;
end;

procedure TScenarioFrame.ListViewItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  btnEdit.Enabled := true;
  btnDelScenario.Enabled := true;
  btnCopy.Enabled := true;
end;

procedure TScenarioFrame.LoadData(AItemID: integer);
var
  I: integer;
  Value: string;
  Flags: TReplaceFlags;
  ID: integer;
  OrderId: string;
  l: TLine;
  tempItem: TRectangle;
begin
  TabControl.Visible := false;
  for I := 0 to ObjectList.Content.ChildrenCount - 1 do
    FreeAndNil(ObjectList.Content.Children[0]);

  Line := 0;

  FDItems.Params.ParamValues['id_scenario'] := AItemID;
  FDItems.Active := true;
  FDItems.First;

  while NOT FDItems.Eof do
  begin
    Value := FDItems.FieldByName('value').AsString;
    ID := FDItems.FieldByName('id').AsInteger;
    OrderId := FDItems.FieldByName('order_id').AsString;

    case ID of

      itemScreenShot, itemSend, itemStep, itemHotKey, itemTab, itemScenario, itemEnter, itemText, itemPos, ItemClick, itemSleep, itemScroll, itemRightClick, itemDoubleClick, itemStop, itemCtrlA,
        itemCtrlC, itemCtrlV, itemBuffer:
        begin
          CreateItem(ID, OrderId, Value, false);
          SelItem.Hint := Value;
        end;
      itemWaitWindow:
        begin
          CreateItem(ID, OrderId, '', false);
          CreateDialogs(SelItem, Value);
          Inc(Line);
          Inc(Line);
        end;
    end;

    FDItems.Next;
  end;

  FDItems.Active := false;
  layBtns.Enabled := true;

  RePaintStepTo;
end;

procedure TScenarioFrame.RePaintStepTo;
var
  I: integer;
  tempItem, tmpTargetObj: TRectangle;
  AIndexTo: string;
  l: TLine;
  j: integer;
begin
  for I := 0 to ObjectList.Content.ChildrenCount - 1 do
    if (ObjectList.Content.Children[I] as TRectangle).Tag = itemStep then
    begin
      tempItem := (ObjectList.Content.Children[I] as TRectangle);
      AIndexTo := tempItem.Hint;
      Delete(AIndexTo, 1, pos('<sep>', AIndexTo) + 4);
      Delete(AIndexTo, 1, pos('<sep>', AIndexTo) + 4);

      j := 0;

      while j <= tempItem.ChildrenCount - 1 do
      begin
        if (tempItem.Children[j] is TLine) then
          if (tempItem.Children[j] as TLine).Tag = 2 then
          begin
            (tempItem.Children[j] as TLine).Visible := false;
            FreeAndNil(tempItem.Children[j]);
            Dec(j);
          end;
        Inc(j);
      end;

      if AIndexTo <> '-1' then
        if ObjectList.Content.ChildrenCount - 1 >= AIndexTo.ToInteger then
        begin
          tmpTargetObj := ObjectList.Content.Children[AIndexTo.ToInteger] as TRectangle;
          l := TLine.Create(nil);
          l.Tag := 2;
          l.Parent := tempItem;
          l.Width := 1;
          l.Height := ABS(tmpTargetObj.Position.Y + tmpTargetObj.Height / 2 - tempItem.Position.Y - tempItem.Height / 2);
          l.LineType := TLineType.Left;
          l.Stroke.Dash := TStrokeDash.Dot;
          l.Stroke.Thickness := 2;
          l.Stroke.Cap := TStrokeCap.Round;
          l.Position.X := -15;

          if I > AIndexTo.ToInteger then
            l.Position.Y := -l.Height + tempItem.Height / 2
          else
            l.Position.Y := tempItem.Height / 2;

          l := TLine.Create(nil);
          l.Tag := 2;
          l.Parent := tempItem;
          l.Width := 25;
          l.Height := 1;
          l.LineType := TLineType.top;
          l.Stroke.Dash := TStrokeDash.Dot;
          l.Stroke.Thickness := 2;
          l.Stroke.Cap := TStrokeCap.Round;
          l.Position.X := -15;
          l.Position.Y := tempItem.Height / 2;

          l := TLine.Create(nil);
          l.Parent := tempItem;
          l.Tag := 2;
          l.Width := 15;
          l.Height := 1;
          l.LineType := TLineType.top;
          l.Stroke.Dash := TStrokeDash.Dot;
          l.Stroke.Thickness := 2;
          l.Stroke.Cap := TStrokeCap.Round;
          l.Position.X := -15;
          l.Position.Y := (tmpTargetObj.Position.Y - tempItem.Position.Y) + tmpTargetObj.Height / 2;

        end;

    end;

end;

procedure TScenarioFrame.btnScenario1Click(Sender: TObject);
begin
  FScenario := TScenarioFrame.Create(nil, '');
  FScenario.Parent := layScenariesChoose;
  FScenario.Tag := (Sender as TSpeedButton).Tag;
  (FindComponent('edScenario' + FScenario.Tag.ToString) as TEdit).Tag := -1;

  FScenario.layMenu.Visible := false;
  layChoose.Visible := true;
end;

procedure TScenarioFrame.btnSetPositionClick(Sender: TObject);
begin
  layMenuEdit.Enabled := false;
  layBtnTest.Enabled := false;
  layCenter.Enabled := false;
  layBtnCancelPosition.Visible := true;
end;

procedure TScenarioFrame.StartStopTest;
begin
  btnStart.SetFocus;

  if ObjectList.Content.ChildrenCount > 0 then
  begin
    if btnStart.Tag = 0 then
    begin
      AFormStopStart := TFormStopStart.Create(nil);
      AFormStopStart.AForm := Self;
      AFormStopStart.Left := 0;
      AFormStopStart.top := Round(Screen.Height - 150);
      AFormStopStart.Show;

      (Self.Parent as TForm).Hide;
      btnStart.Text := 'СТОП';
      btnStart.Tag := 1;
      FScenarioItems.Clear;
      ExecuteScenario();

    end
    else
    begin
      FWork.Stop;
      (Self.Parent as TForm).Show;
      btnStart.Tag := 0;
      btnStart.Text := 'ТЕСТ';
      Self.SetFocus;
      FreeAndNil(AFormStopStart);

      if FThread <> nil then
      begin
        FThread.Cancel;
        FThread := nil;
      end;
    end;
  end;

end;

procedure TScenarioFrame.btnStartClick(Sender: TObject);
begin
  StartStopTest;
end;

procedure TScenarioFrame.ExecuteScenario;
var
  I: integer;
  ADict: TDict;
begin
  ExeQ(FDExe, Format('select id,value from scenario_item where id_scenario = %d order by order_id', [LoadScenariesID]), tsActive);

  FDExe.First;

  while NOT FDExe.Eof do
  begin
    ADict.Key := FDExe.FieldByName('id').AsInteger;
    ADict.Value := FDExe.FieldByName('value').AsString;
    ADict.Parent := LoadScenariesID;

    FScenarioItems.Add(ADict);
    FDExe.Next;
  end;

  FThread := TTask.Run(
    procedure
    begin
      FWork.Stopping := false;
      FWork.IDSheduler := 0;
      FWork.IDScenario := LoadScenariesID;
      FWork.Start;
    end);
end;

procedure TScenarioFrame.btnTrackingStartClick(Sender: TObject);
begin
  (Self.Parent as TForm).Hide;
  timerCheckTrack.Enabled := true;
  timerGetPos.Enabled := true;
end;

procedure TScenarioFrame.btnUpClick(Sender: TObject);
var
  BeforeItem: TRectangle;
  CurrIndex: integer;
  CurrItem: TRectangle;
  tmpHint: string;
begin
  CurrIndex := ObjectList.Content.Children.IndexOf(SelItem);

  if (CurrIndex > 0) then
  begin
    BeforeItem := ObjectList.Content.Children[CurrIndex - 1] as TRectangle;

    if BeforeItem.Tag <> itemStop then
    begin
      FDExe.Active := false;
      FDExe.SQL.Clear;

      if SelItem.Tag <> itemStep then
        FDExe.SQL.Append
          (StringReplace
          (Format('update scenario_item set value = Replace(value,''<sep>%d'',''<sep>%d'') where id_scenario = %d and order_id = (select order_id from scenario_item s where s.id_scenario = id_scenario and id = 13 and value like ''proc<sep>%d'' );',
          [CurrIndex, CurrIndex - 1, LoadScenariesID, CurrIndex]), 'proc', '%', [rfReplaceAll]))
      else
      begin
        tmpHint := SelItem.Hint;
        Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
        Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);

        if CurrIndex = tmpHint.ToInteger() + 1 then

          FDExe.SQL.Append
            (StringReplace
            (Format('update scenario_item set value = Replace(value,''<sep>%d'',''<sep>%d'') where id_scenario = %d and order_id = (select order_id from scenario_item s where s.id_scenario = id_scenario and id = 13 and value like ''proc<sep>%d'' );',
            [CurrIndex - 1, CurrIndex, LoadScenariesID, CurrIndex - 1]), 'proc', '%', [rfReplaceAll]));

      end;

      FDExe.SQL.Append(Format('update scenario_item set order_id = 999999 where id_scenario = %d and order_id = %d;', [LoadScenariesID, CurrIndex - 1]));
      FDExe.SQL.Append(Format('update scenario_item set order_id = %d where id_scenario = %d and order_id = %d;', [CurrIndex - 1, LoadScenariesID, CurrIndex]));
      FDExe.SQL.Append(Format('update scenario_item set order_id = %d where id_scenario = %d and order_id = 999999;', [CurrIndex, LoadScenariesID]));

      FDExe.ExecSQL;
      LoadData(LoadScenariesID);

      CurrItem := (ObjectList.Content.Children[CurrIndex - 1] as TRectangle);
      ItemsClick(CurrItem);
      ObjectList.ScrollTo(0, Round(-CurrItem.Position.Y + ObjectList.Height / 2 - CurrItem.Height / 2));
    end;
  end;

end;

procedure TScenarioFrame.cbSendFileChange(Sender: TObject);
begin
  edFileSend.Enabled := cbSendFile.IsChecked;
  SaveTabSend;
end;

procedure TScenarioFrame.SaveTabSend;
begin
  SelItem.Hint := edFileSend.Text + '<sep>' + cbSendFile.IsChecked.ToString() + '<sep>' + mMessageText.Text;
  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.cbShiftLitterChange(Sender: TObject);
begin
  SelItem.Hint := cbShift.ItemIndex.ToString + '-' + cbShiftLitter.ItemIndex.ToString+ '+' + numClick.Value.ToString;
//  SelItem.Hint := cbShift.ItemIndex.ToString + '-' + cbShiftLitter.ItemIndex.ToString+ '+1';
  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.NextStep(IsSuccess: boolean);
begin
  btnStartClick(nil);
end;

constructor TScenarioFrame.Create(AOwner: TFMXObject; AWhere: string = '');
begin
  inherited Create(AOwner);

  TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Svc);
  FDConnection.Params.Database := ExtractFilePAth(paramstr(0)) + '\base.db';
  FDConnection.Connected := true;

  if AWhere <> '' then
    FDQuery.SQL.Text := FDQuery.SQL.Text + AWhere;

  FDQuery.SQL.Text := FDQuery.SQL.Text + ' order by name';
  FDQuery.Active := true;

  FScenarioItems := TList<TDict>.Create;

  FWork := TWork.Create(FDConnection);
  FWork.Proc := NextStep;
  FWork.Scenaries := FScenarioItems;
end;

function TScenarioFrame.CreateBlock: TRectangle;
var
  t: TRectangle;
  img: TImage;
  n, I: integer;
begin
  t := TRectangle.Create(nil);
  t.XRadius := 5;
  t.YRadius := 5;
  t.Stroke.Kind := TBrushKind.None;
  t.Parent := ObjectList;
  t.Height := 80;
  t.Fill.color := $FFF2F2F2;
  t.Width := ObjectList.Width - 50;
  t.Position.X := ObjectList.Width / 2 - t.Width / 2;
  t.Position.Y := (Line) * (80 + 5) + 5;
  t.OnClick := ItemsClick;
  t.HitTest := true;

  img := TImage.Create(nil);
  img.Parent := t;
  img.Margins.Left := 10;
  img.Height := 50;
  img.Align := TAlignLayout.Left;
  img.HitTest := false;

  t.TagObject := img;
  result := t;
end;

procedure TScenarioFrame.SaveDialogData(Sender: TObject);
var
  I: integer;
  ObjText: string;
begin
  if SelItem <> nil then
  begin
    ObjText := btnAddDialog.Tag.ToString + '<sep_d>';

    for I := 1 to btnAddDialog.Tag do
    begin
      ObjText := ObjText + (FindComponent('edWindow' + I.ToString) as TEdit).Text + '<sep>';
    end;

    ObjText := ObjText + '<sep_s>';

    for I := 1 to btnAddDialog.Tag do
    begin
      ObjText := ObjText + (FindComponent('edScenario' + I.ToString) as TEdit).Tag.ToString + '<sep>';
    end;

    ObjText := ObjText + '<sep_t>';

    for I := 1 to btnAddDialog.Tag do
    begin
      ObjText := ObjText + (FindComponent('swType' + I.ToString) as TSwitch).IsChecked.ToString + '<sep>';
    end;

    SelItem.Hint := ObjText;

    ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);

    CreateDialogs(SelItem, SelItem.Hint);
  end;

end;

procedure TScenarioFrame.CreateDialogs(ParentDialogs: TRectangle; ItemHint: string);
var
  t: TCornerButton;
  I: integer;
  DialogItems: string;
  ScenarioItems: string;
  Count: integer;
  l: TLine;
  Min: Single;
  Max: Single;
  TypeItems: string;
begin
  I := 0;

  while I <= ParentDialogs.ChildrenCount - 1 do
  begin
    if (ParentDialogs.Children[I] is TImage) then
      Inc(I)
    else
      FreeAndNil(ParentDialogs.Children[I]);
  end;

  Count := Copy(ItemHint, 1, pos('<sep_d>', ItemHint) - 1).ToInteger();
  DialogItems := Copy(ItemHint, pos('<sep_d>', ItemHint) + 7, pos('<sep_s>', ItemHint) - 8 - Count.ToString.Length);
  ScenarioItems := Copy(ItemHint, pos('<sep_s>', ItemHint) + 7, pos('<sep_t>', ItemHint) - 8 - Count.ToString.Length - DialogItems.Length);
  TypeItems := Copy(ItemHint, pos('<sep_t>', ItemHint) + 7);

  ParentDialogs.Height := 80 * 2 + 5;

  ParentDialogs.Tag := itemWaitWindow;
  ParentDialogs.Hint := ItemHint;
  ParentDialogs.ParentShowHint := false;

  if ObjectList.Content.Children.IndexOf(SelItem) <> 0 then
    if (ObjectList.Content.Children[ObjectList.Content.Children.IndexOf(SelItem) - 1].Tag <> itemStop) then
    begin
      l := TLine.Create(nil);
      l.Parent := ParentDialogs;
      l.Width := 1;
      l.Height := 26;
      l.LineType := TLineType.Left;
      l.Stroke.Dash := TStrokeDash.Dot;
      l.Stroke.Thickness := 2;
      l.Stroke.Cap := TStrokeCap.Round;
      l.Position.X := 50 + (ParentDialogs.Width - 50) / 2 - l.Width / 2;
      l.Position.Y := -l.Height;
    end;

  for I := 1 to Count do
  begin
    t := TCornerButton.Create(nil);
    t.Parent := ParentDialogs;

    t.Width := (ParentDialogs.Width - 100) / Count;
    t.Height := 40;
    t.Text := Copy(DialogItems, 1, pos('<sep>', DialogItems) - 1);
    Delete(DialogItems, 1, pos('<sep>', DialogItems) + 4);

    t.ParentShowHint := false;
    t.Position.X := 50 + (ParentDialogs.Width - 50) / (Count * 2) * (I * 2 - 1) - t.Width / 2;

    t.Position.Y := ParentDialogs.Height / 4 - t.Height / 2;

    t.OnClick := ItemsClick;
    t.TextSettings.WordWrap := true;

    if Copy(TypeItems, 1, pos('<sep>', TypeItems) - 1).ToBoolean() then
    begin
      with TRectangle.Create(nil) do
      begin
        Parent := ParentDialogs;
        Width := t.Width + 20;
        Height := ParentDialogs.Height - 20;
        Position.X := t.Position.X - 10;
        Position.Y := 10;
        SendToBack;
        Stroke.Kind := TBrushKind.None;
        Fill.color := TAlphaColors.Tomato;
        XRadius := 15;
        YRadius := 15;
      end;
    end;
    Delete(TypeItems, 1, pos('<sep>', TypeItems) + 4);

    if ObjectList.Content.Children.IndexOf(SelItem) <> 0 then
      if (ObjectList.Content.Children[ObjectList.Content.Children.IndexOf(SelItem) - 1].Tag <> itemStop) then
      begin
        l := TLine.Create(nil);
        l.Parent := ParentDialogs;
        l.Width := 1;
        l.Height := 22;
        l.LineType := TLineType.Left;
        l.Stroke.Dash := TStrokeDash.Dot;
        l.Stroke.Thickness := 2;
        l.Stroke.Cap := TStrokeCap.Round;
        l.Position.X := t.Position.X + t.Width / 2 - l.Width / 2;
        l.Position.Y := t.Position.Y - l.Height;
      end;
  end;

  for I := 1 to Count do
  begin

    t := TCornerButton.Create(nil);
    t.Parent := ParentDialogs;
    t.Width := (ParentDialogs.Width - 100) / Count;
    t.Height := 40;

    ExeQ(FDExe, 'select Name from scenaries where id = ' + Copy(ScenarioItems, 1, pos('<sep>', ScenarioItems) - 1), tsActive);

    Delete(ScenarioItems, 1, pos('<sep>', ScenarioItems) + 4);

    t.StyledSettings := [];

    if FDExe.FieldByName('Name').AsString = '' then
    begin
      t.Text := 'Сценарий не выбран';
      t.TextSettings.FontColor := TAlphaColors.Red;
    end
    else
    begin
      t.Text := FDExe.FieldByName('Name').AsString;
      t.TextSettings.FontColor := TAlphaColors.Black;
    end;

    t.Position.X := 50 + (ParentDialogs.Width - 50) / (Count * 2) * (I * 2 - 1) - t.Width / 2;
    t.Position.Y := ParentDialogs.Height / 4 * 3 - t.Height / 2;
    t.OnClick := ItemsClick;
    t.TextSettings.WordWrap := true;

    l := TLine.Create(nil);
    l.Parent := ParentDialogs;
    l.Width := 1;
    l.Height := 46;
    l.LineType := TLineType.Left;
    l.Stroke.Dash := TStrokeDash.Dot;
    l.Stroke.Thickness := 2;
    l.Stroke.Cap := TStrokeCap.Round;
    l.Position.X := t.Position.X + t.Width / 2 - l.Width / 2;
    l.Position.Y := t.Position.Y - l.Height + 2;

    l := TLine.Create(nil);
    l.Parent := ParentDialogs;
    l.Width := 1;
    l.Height := 22;
    l.LineType := TLineType.Left;
    l.Stroke.Dash := TStrokeDash.Dot;
    l.Stroke.Thickness := 2;
    l.Stroke.Cap := TStrokeCap.Round;
    l.Position.X := t.Position.X + t.Width / 2 - l.Width / 2;
    l.Position.Y := t.Position.Y + t.Height;

    if I = 1 then
      Min := l.Position.X
    else if I = Count then
      Max := l.Position.X + 1;
  end;

  if ObjectList.Content.Children.IndexOf(SelItem) <> 0 then
    if (ObjectList.Content.Children[ObjectList.Content.Children.IndexOf(SelItem) - 1].Tag <> itemStop) then
    begin
      l := TLine.Create(nil);
      l.Parent := ParentDialogs;
      l.Width := Max - Min;
      l.Height := 1;
      l.LineType := TLineType.top;
      l.Stroke.Dash := TStrokeDash.Dot;
      l.Stroke.Thickness := 2;
      l.Stroke.Cap := TStrokeCap.Round;
      l.Position.X := 50 + (ParentDialogs.Width - 50) / 2 - l.Width / 2;
      l.Position.Y := 0;
    end;

  l := TLine.Create(nil);
  l.Parent := ParentDialogs;
  l.Width := Max - Min;
  l.Height := 1;
  l.LineType := TLineType.top;
  l.Stroke.Dash := TStrokeDash.Dot;
  l.Stroke.Thickness := 2;
  l.Stroke.Cap := TStrokeCap.Round;
  l.Position.X := 50 + (ParentDialogs.Width - 50) / 2 - l.Width / 2;
  l.Position.Y := ParentDialogs.Height - 1;

end;

function TScenarioFrame.CreateBoxNotHint(itemType: integer;  itemOrder: string; itemText: string): TRectangle;
var
  t: TCornerButton;
  p: TRectangle;
  l: TLine;
  n: TText;
begin
  p := CreateBlock;
  p.Tag := itemType;

  t := TCornerButton.Create(nil);
  t.Parent := p;
  t.Width := p.Width - 100;
  t.Height := 40;
  t.Text := itemText;
  t.Position.Y := p.Height / 2 - t.Height / 2;
  t.Position.X := 50 + (p.Width - 50) / 2 - t.Width / 2;
  t.TextSettings.WordWrap := true;

  t.OnClick := ItemsClick;

  n := TText.Create(nil);
  n.Parent := t;
  n.Width := 40;
  n.Height := 20;
  n.Position.Y := 10;
  n.Position.X := 1;
  n.Text :=  itemOrder;
  n.Enabled := false;

  if ObjectList.Content.Children.IndexOf(p) <> 0 then
    if (ObjectList.Content.Children[ObjectList.Content.Children.IndexOf(p) - 1].Tag <> itemStop) then
    begin
      l := TLine.Create(nil);
      l.Parent := p;
      l.Width := 1;
      l.Height := 46;
      l.LineType := TLineType.Left;
      l.Stroke.Dash := TStrokeDash.Dot;
      l.Stroke.Thickness := 2;
      l.Stroke.Cap := TStrokeCap.Round;
      l.Position.X := 50 + (p.Width - 50) / 2 - l.Width / 2;
      l.Position.Y := t.Position.Y - l.Height;
    end;

  result := p;
  Inc(Line);
end;

function TScenarioFrame.CreateBox(itemType: integer; itemOrder: string; itemText: string; ItemHint: string): TRectangle;
var
  t: TCornerButton;
  p: TRectangle;
  l: TLine;
  n: TText;
begin
  p := CreateBlock;
  p.Hint := ItemHint;
  p.ParentShowHint := false;
  p.Tag := itemType;

  t := TCornerButton.Create(nil);
  t.Parent := p;
  t.Width := p.Width - 100;
  t.Height := 40;
  t.Text := itemText;

  n := TText.Create(nil);
  n.Parent := t;
  n.Width := 40;
  n.Height := 20;
  n.Position.Y := 10;
  n.Position.X := 1;
  n.Text :=  itemOrder;
  n.Enabled := false;


  t.Position.Y := p.Height / 2 - t.Height / 2;
  t.Position.X := 50 + (p.Width - 50) / 2 - t.Width / 2;

  t.OnClick := ItemsClick;
  t.TextSettings.WordWrap := true;

  if (ObjectList.Content.Children.IndexOf(p) <> 0) then
    if (ObjectList.Content.Children[ObjectList.Content.Children.IndexOf(p) - 1].Tag <> itemStop) then
    begin
      l := TLine.Create(nil);
      l.Parent := p;
      l.Width := 1;
      l.Height := 46;
      l.LineType := TLineType.Left;
      l.Stroke.Dash := TStrokeDash.Dot;
      l.Stroke.Thickness := 2;
      l.Stroke.Cap := TStrokeCap.Round;
      l.Position.X := 50 + (p.Width - 50) / 2 - l.Width / 2;
      l.Position.Y := t.Position.Y - l.Height;
    end;

  result := p;
  Inc(Line);
end;

procedure TScenarioFrame.CreateItem(itemType: integer; itemOrder, ItemValue: string; ToSave: boolean = true);
var
  IndexSel: integer;
  I: integer;
  CurrItem: TRectangle;
begin
  IndexSel := 0;

  if ObjectList.Content.ChildrenCount > 0 then
    if SelItem <> nil then
      IndexSel := ObjectList.Content.Children.IndexOf(SelItem) + 1
    else
      IndexSel := ObjectList.Content.ChildrenCount;

  case itemType of
    itemHotKey:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Горячая клавиша', '0-0+1');
//        SelItem := CreateBox(itemType, itemOrder, 'Горячая клавиша2', '0-0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[21].MultiResBitmap[0].Bitmap);
      end;
    itemText:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Вставить текст: ' + ItemValue);
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[16].MultiResBitmap[0].Bitmap);
      end;
    itemEnter:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Клавиша "Ввод"');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[15].MultiResBitmap[0].Bitmap);
      end;
    itemTab:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Табуляция');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[14].MultiResBitmap[0].Bitmap);
      end;
    itemPos:
      begin
        SelItem := CreateBox(itemType, itemOrder, Copy(ItemValue, 1, pos('<sep>', ItemValue) - 1), '0-0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[0].MultiResBitmap[0].Bitmap);
      end;
    itemSleep:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Пауза ' + ItemValue + ' сек.', '0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[2].MultiResBitmap[0].Bitmap);
      end;
    ItemClick:
      begin
        SelItem := CreateBox(itemType,itemOrder, Copy(ItemValue, 1, pos('<sep>', ItemValue) - 1), '0-0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[1].MultiResBitmap[0].Bitmap);
      end;
    itemScroll:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Прокрутить колесом', '-10000');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[3].MultiResBitmap[0].Bitmap);
      end;

    itemRightClick:
      begin
        SelItem := CreateBox(itemType, itemOrder, Copy(ItemValue, 1, pos('<sep>', ItemValue) - 1), '0-0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[5].MultiResBitmap[0].Bitmap);
      end;
    itemDoubleClick:
      begin
        SelItem := CreateBox(itemType, itemOrder, Copy(ItemValue, 1, pos('<sep>', ItemValue) - 1), '0-0');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[6].MultiResBitmap[0].Bitmap);
      end;
    itemCtrlA:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Выбрать все (Ctrl + A)');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[7].MultiResBitmap[0].Bitmap);
      end;
    itemCtrlC:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Копировать (Ctrl + C)');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[8].MultiResBitmap[0].Bitmap);
      end;
    itemCtrlV:
      begin
        SelItem := CreateBoxNotHint(itemType, itemOrder, 'Вставить (Ctrl + V)');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[9].MultiResBitmap[0].Bitmap);
      end;
    itemWaitWindow:
      begin
        SelItem := CreateBlock;
        SelItem.Hint := '1<sep_d>Ожидание события диалога<sep><sep_s>-1<sep><sep_t>0<sep>';
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap := (ImageList.Source[19].MultiResBitmap[0].Bitmap);
      end;

    itemStop:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Прервать выполнение если...', '-1');
        SelItem.Fill.color := $FFFCCEC2;
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[24].MultiResBitmap[0].Bitmap);
      end;

    itemScenario:
      begin
        ExeQ(FDExe, 'select Name from scenaries where id = ' + ItemValue, tsActive);
        SelItem := CreateBox(itemType, itemOrder, 'Выполнить сценарий "' + FDExe.FieldByName('name').AsString + '"', ItemValue);
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[26].MultiResBitmap[0].Bitmap);
      end;
    itemStep:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Перейти к шагу если...', ItemValue);
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[13].MultiResBitmap[0].Bitmap);
      end;
    itemScreenShot:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Сделать скриншот', ItemValue);
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[27].MultiResBitmap[0].Bitmap);
      end;
    itemSend:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Отправить сообщение', '<sep>false<sep>');
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[33].MultiResBitmap[0].Bitmap);
      end;
    itemBuffer:
      begin
        SelItem := CreateBox(itemType, itemOrder, 'Скопировать из буфера в переменную', ItemValue);
        (SelItem.TagObject as TImage).MultiResBitmap[0].Bitmap.Assign(ImageList.Source[20].MultiResBitmap[0].Bitmap);
      end;
  end;

  if ToSave then
  begin
    FDExe.Active := false;
    FDExe.SQL.Clear;

    if itemType = itemStop then
    begin
      FDExe.SQL.Add(Format('update scenario_item set order_id = order_id + 1 where id_scenario = %d;', [LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]));
      FDExe.SQL.Add(Format('insert into scenario_item (id, value,id_scenario,order_id) values (%d,''%s'',%d,0);', [itemType, SelItem.Hint, LoadScenariesID]));
    end
    else
    begin
      FDExe.SQL.Add(Format('update scenario_item set order_id = order_id + 1 where id_scenario = %d and order_id >= %d;', [LoadScenariesID, IndexSel]));
      FDExe.SQL.Add(Format('insert into scenario_item (id, value,id_scenario,order_id) values (%d,''%s'',%d,%d);', [itemType, SelItem.Hint, LoadScenariesID, IndexSel]));
    end;
    FDExe.ExecSQL;

    LoadData(LoadScenariesID);

    CurrItem := (ObjectList.Content.Children[IndexSel] as TRectangle);
    ItemsClick(CurrItem);
    ObjectList.ScrollTo(0, Round(-CurrItem.Position.Y + ObjectList.Height / 2 - CurrItem.Height / 2));
  end;

end;

procedure TScenarioFrame.edFileSendChangeTracking(Sender: TObject);
begin
  SaveTabSend;
end;

procedure TScenarioFrame.edNameBlockPosChangeTracking(Sender: TObject);
var
  I: integer;
begin
  SelItem.Hint := edNameBlockPos.Text + '<sep>' + editPosCursor.Text;

  for I := 0 to SelItem.ChildrenCount - 1 do
  begin
    if SelItem.Children[I] is TCornerButton then
    begin
      (SelItem.Children[I] as TCornerButton).Text := edNameBlockPos.Text;
      break;
    end;
  end;

  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.edNameFileChangeTracking(Sender: TObject);
begin
  SelItem.Hint := edNameFile.Text;
  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.edParamStepChangeTracking(Sender: TObject);
begin
  SelItem.Hint := edParamStep.Text + '<sep>' + mConditions.Text + '<sep>' + btnSetPosition.Tag.ToString;
  Label35.Text := 'Установлен переход на блок '+ btnSetPosition.Tag.ToString;
  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.edScenario6ChangeTracking(Sender: TObject);
begin
  if SelItem <> nil then
  begin
    SelItem.Hint := edScenario6.Tag.ToString;

    ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= 0', [SelItem.Hint, LoadScenariesID]), tsExec);
  end;
end;

procedure TScenarioFrame.edSeparatorChangeTracking(Sender: TObject);
var
  I: integer;
begin
  SelItem.Hint := edSeparator.Text;

  for I := 0 to SelItem.ChildrenCount - 1 do
  begin
    if SelItem.Children[I] is TCornerButton then
    begin
      case SelItem.Tag of
        itemText:
          (SelItem.Children[I] as TCornerButton).Text := 'Вставить текст: ' + edSeparator.Text;
    end;

    break;
  end;
end;

ExeQ(FDExe, Format('update scenario_item set value = ''%s'' where id_scenario = %d and order_id = %d;', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.edScenario7ChangeTracking(Sender: TObject);
var
  I: integer;
begin
  if SelItem <> nil then
  begin
    SelItem.Hint := edScenario7.Tag.ToString;
    ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
  end;

  for I := 0 to SelItem.ChildrenCount - 1 do
  begin
    if SelItem.Children[I] is TCornerButton then
    begin
      (SelItem.Children[I] as TCornerButton).Text := 'Выполнить сценарий "' + edScenario7.Text + '"';
      break;
    end;
  end;
end;

procedure TScenarioFrame.eScenarioNameChangeTracking(Sender: TObject);
begin
  ExeQ(FDExe, Format('update scenaries set name = ''%s'' where id = %d;', [eScenarioName.Text, LoadScenariesID]), tsExec);
  FDQuery.Active := false;
  FDQuery.Active := true;
end;

procedure TScenarioFrame.MenuItem10Click(Sender: TObject);
begin
  CreateItem(itemScenario, '', '-1');
end;

procedure TScenarioFrame.MenuItem11Click(Sender: TObject);
begin
  CreateItem(itemRightClick, '', 'Нажать правую кнопку мыши');
end;

procedure TScenarioFrame.MenuItem12Click(Sender: TObject);
begin
  CreateItem(itemDoubleClick, '', 'Нажать двойную левую кнопку мыши');
end;

procedure TScenarioFrame.MenuItem13Click(Sender: TObject);
begin
  CreateItem(itemCtrlA, '', '');
end;

procedure TScenarioFrame.MenuItem14Click(Sender: TObject);
begin
  CreateItem(itemCtrlC, '', '');
end;

procedure TScenarioFrame.MenuItem15Click(Sender: TObject);
begin
  CreateItem(itemCtrlV, '', '');
end;

procedure TScenarioFrame.MenuItem16Click(Sender: TObject);
begin
  CreateItem(itemStep, '', '<sep><sep>-1');
end;

procedure TScenarioFrame.MenuItem17Click(Sender: TObject);
begin
  CreateItem(itemScreenShot, '', '');
end;

procedure TScenarioFrame.MenuItem18Click(Sender: TObject);
begin
  CreateItem(itemSend, '', '');
end;

procedure TScenarioFrame.MenuItem19Click(Sender: TObject);
begin
  CreateItem(itemBuffer, '', '');
end;

procedure TScenarioFrame.MenuItem1Click(Sender: TObject);
begin
  CreateItem(itemPos, '', 'Переместить курсор');
end;

procedure TScenarioFrame.MenuItem25Click(Sender: TObject);
begin
  ContactForm.ShowModal;
end;

procedure TScenarioFrame.MenuItem26Click(Sender: TObject);
begin
  CreateItem(itemTab, '', '');
end;

procedure TScenarioFrame.MenuItem27Click(Sender: TObject);
begin
  CreateItem(itemEnter, '', '');
end;

procedure TScenarioFrame.MenuItem28Click(Sender: TObject);
begin
  CreateItem(itemText, '', '');
end;

procedure TScenarioFrame.MenuItem2Click(Sender: TObject);
begin
  CreateItem(ItemClick, '', 'Нажать левую кнопку мыши');
end;

procedure TScenarioFrame.MenuItem3Click(Sender: TObject);
begin
  CreateItem(itemSleep, '', '');
end;

procedure TScenarioFrame.MenuItem5Click(Sender: TObject);
begin
  CreateItem(itemScroll, '', '');
end;

procedure TScenarioFrame.MenuItem7Click(Sender: TObject);
begin
  CreateItem(itemHotKey, '', '');
end;

procedure TScenarioFrame.MenuItem8Click(Sender: TObject);
begin
  CreateItem(itemWaitWindow, '', '');
  CreateDialogs(SelItem, '1<sep_d>Ожидание события диалога<sep><sep_s>-1<sep><sep_t>0<sep>');
  Inc(Line);
  Inc(Line);
end;

procedure TScenarioFrame.MenuItem9Click(Sender: TObject);
begin
  if (ObjectList.Content.Children[0] as TRectangle).Tag <> itemStop then
    CreateItem(itemStop, '', 'Прервать выполнение если...');
end;

procedure TScenarioFrame.mMessageTextChangeTracking(Sender: TObject);
begin
  SaveTabSend;
end;

procedure TScenarioFrame.numScrollChangeTracking(Sender: TObject);
begin

  if swScroll.IsChecked then
    SelItem.Hint := '-' + numScroll.Text
  else
    SelItem.Hint := numScroll.Text;

  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.sleepTimeChangeTracking(Sender: TObject);
var
  I: integer;
begin
  SelItem.Hint := sleepTime.Text;

  for I := 0 to SelItem.ChildrenCount - 1 do
  begin
    if SelItem.Children[I] is TCornerButton then
    begin
      (SelItem.Children[I] as TCornerButton).Text := 'Пауза ' + sleepTime.Text + ' сек.';
      break;
    end;
  end;

  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);
end;

procedure TScenarioFrame.timerCheckTrackTimer(Sender: TObject);
begin
  if IsNeedPos then
  begin
    btnTrackingStart.Text := 'Начать запись позиции';
    SelItem.Hint := edNameBlockPos.Text + '<sep>' + editPosCursor.Text
  end;

  ExeQ(FDExe, Format('update scenario_item set value =''%s'' where id_scenario=%d and order_id= %d', [SelItem.Hint, LoadScenariesID, ObjectList.Content.Children.IndexOf(SelItem)]), tsExec);

  timerGetPos.Enabled := false;
  timerCheckTrack.Enabled := false;
  (Self.Parent as TForm).FormStyle := TFormStyle.StayOnTop;
  (Self.Parent as TForm).Show;
  (Self.Parent as TForm).FormStyle := TFormStyle.Normal;
end;

function TScenarioFrame.IsNeedPos: boolean;
begin
  result := (SelItem.Tag = itemPos) or (SelItem.Tag = ItemClick) or (SelItem.Tag = itemRightClick) or (SelItem.Tag = itemDoubleClick);
end;

procedure TScenarioFrame.timerGetPosTimer(Sender: TObject);
var
  posXY: TPoint;
begin
  GetCursorPos(posXY);

  if IsNeedPos then
  begin
    if editPosCursor.Text = posXY.X.ToString + '-' + posXY.Y.ToString then
    begin
      btnTrackingStart.Hint := (StrToFloat(btnTrackingStart.Hint) - 0.1).ToString;
      btnTrackingStart.Text := 'Не двигайте мышью еще ' + btnTrackingStart.Hint + ' сек.';;
      timerCheckTrack.Enabled := true;
    end
    else
    begin
      editPosCursor.Text := posXY.X.ToString + '-' + posXY.Y.ToString;
      timerCheckTrack.Enabled := false;
      btnTrackingStart.Hint := '2,5';
      btnTrackingStart.Text := 'Не двигайте мышью еще 2,5 сек.';
    end;
  end
end;

procedure TScenarioFrame.ItemsClick(Sender: TObject);
var
  s: string;
  tmp: string;
  I: integer;
  tmpHint: string;
  Count: integer;
  DialogItems: string;
  ScenarioItems: string;
  TypeItems: string;
  IDString: string;
begin
  if NOT layBtnCancelPosition.Visible then
  begin
    SelItem := nil;
    btnAddDialog.Tag := 1;
    layDialogs.Height := 130;

    for I := 1 to 5 do
    begin
      (FindComponent('edWindow' + I.ToString) as TEdit).Text := '';
      (FindComponent('edScenario' + I.ToString) as TEdit).Text := '';
      (FindComponent('swType' + I.ToString) as TSwitch).IsChecked := false;
      (FindComponent('edScenario' + I.ToString) as TEdit).Tag := -1;

      if I > 1 then
        (FindComponent('gb' + I.ToString) as TGroupBox).Visible := false;
    end;

    if Sender is TCornerButton then
      SelItem := (Sender as TCornerButton).Parent as TRectangle
    else
      SelItem := Sender as TRectangle;

    for I := 0 to ObjectList.Content.ChildrenCount - 1 do
      if (ObjectList.Content.Children[I] as TRectangle).Tag = itemStop then
        (ObjectList.Content.Children[I] as TRectangle).Fill.color := $FFFCCEC2
      else
        (ObjectList.Content.Children[I] as TRectangle).Fill.color := $FFF2F2F2;

    if SelItem.Tag = itemStop then
      SelItem.Fill.color := $FFFBE6B0
    else
      SelItem.Fill.color := $FFAAD2BC;

    case SelItem.Tag of
      itemPos, ItemClick, itemRightClick, itemDoubleClick:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabPos;

          if pos('<sep>', SelItem.Hint) <> 0 then
            editPosCursor.Text := Copy(SelItem.Hint, pos('<sep>', SelItem.Hint) + 5)
          else
            editPosCursor.Text := SelItem.Hint;

          edNameBlockPos.Text := Copy(SelItem.Hint, 1, pos('<sep>', SelItem.Hint) - 1);

        end;

      itemSleep:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabSleep;
          sleepTime.Text := SelItem.Hint;
        end;
      itemCtrlA, itemCtrlC, itemCtrlV, itemTab, itemEnter:
        begin
          TabControl.Visible := false;
        end;
      itemText:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabSeparator;
          edSeparator.Text := SelItem.Hint;
        end;
      itemScroll:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabScroll;
          numScroll.OnChangeTracking := nil;
          numScroll.Value := ABS(SelItem.Hint.ToInteger);
          swScroll.IsChecked := SelItem.Hint.ToInteger() < 0;
          numScroll.OnChangeTracking := numScrollChangeTracking;
        end;
      itemHotKey:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabHotKey;
          tmpHint := SelItem.Hint;
          begin
            cbShift.ItemIndex := Copy(tmpHint, 1, 1).ToInteger;
            tmpHint := Copy(tmpHint, 3);
            if pos('+', tmpHint) <> 0 then
            begin
              cbShiftLitter.ItemIndex := Copy(tmpHint, 1, pos('+', tmpHint) - 1).ToInteger;
              numClick.Value := Copy(tmpHint, pos('+', tmpHint) + 1).ToInteger;
            end
            else
            begin
              cbShiftLitter.ItemIndex := tmpHint.ToInteger;
              numClick.Value := 1;
            end;
          end;
        end;
      itemWaitWindow:
        begin

          TabControl.Visible := true;
          TabControl.ActiveTab := TabWaitWindow;
          tmpHint := SelItem.Hint;

          Count := Copy(tmpHint, 1, pos('<sep_d>', tmpHint) - 1).ToInteger();
          DialogItems := Copy(tmpHint, pos('<sep_d>', tmpHint) + 7, pos('<sep_s>', tmpHint) - 8 - Count.ToString.Length);
          ScenarioItems := Copy(tmpHint, pos('<sep_s>', tmpHint) + 7, pos('<sep_t>', tmpHint) - 8 - Count.ToString.Length - DialogItems.Length);
          TypeItems := Copy(tmpHint, pos('<sep_t>', tmpHint) + 7);

          for I := 1 to Count do
          begin
            (FindComponent('swType' + I.ToString) as TSwitch).IsChecked := Copy(TypeItems, 1, pos('<sep>', TypeItems) - 1).ToBoolean();
            Delete(TypeItems, 1, pos('<sep>', TypeItems) + 4);

            (FindComponent('edWindow' + I.ToString) as TEdit).Text := Copy(DialogItems, 1, pos('<sep>', DialogItems) - 1);
            Delete(DialogItems, 1, pos('<sep>', DialogItems) + 4);

            IDString := Copy(ScenarioItems, 1, pos('<sep>', ScenarioItems) - 1);

            if IDString <> '' then
            begin
              ExeQ(FDExe, 'select Name from scenaries where id = ' + IDString, tsActive);

              (FindComponent('edScenario' + I.ToString) as TEdit).Tag := IDString.ToInteger();
              (FindComponent('edScenario' + I.ToString) as TEdit).Text := FDExe.FieldByName('Name').AsString;
              Delete(ScenarioItems, 1, pos('<sep>', ScenarioItems) + 4);
            end;

            if I <> Count then
              btnAddDialogClick(nil);

          end;
        end;
      itemStop:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabStop;

          ExeQ(FDExe, 'select Name from scenaries where id = ' + SelItem.Hint, tsActive);

          edScenario6.Tag := SelItem.Hint.ToInteger();
          edScenario6.Text := FDExe.FieldByName('Name').AsString;
        end;

      itemScenario:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := TabScenario;
          ExeQ(FDExe, 'select Name from scenaries where id = ' + SelItem.Hint, tsActive);

          edScenario7.Tag := SelItem.Hint.ToInteger();
          edScenario7.Text := FDExe.FieldByName('Name').AsString;
        end;
      itemStep:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := TabStep;
          tmpHint := SelItem.Hint;
          edParamStep.Text := Copy(tmpHint, 1, pos('<sep>', tmpHint) - 1);
          Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
          mConditions.Text := Copy(tmpHint, 1, pos('<sep>', tmpHint) - 1);
          Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
          Label35.Text := 'Установлен переход на блок '+ tmpHint;

          if (tmpHint <> '') and (tmpHint <> '-1') then
          begin
            btnSetPosition.Tag := tmpHint.ToInteger;

            if ObjectList.Content.ChildrenCount - 1 >= btnSetPosition.Tag then
              (ObjectList.Content.Children[btnSetPosition.Tag] as TRectangle).Fill.color := $FFAAC2C0;
          end;

        end;
      itemScreenShot:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabScreen;
          edNameFile.Text := SelItem.Hint;
        end;
      itemSend:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabSend;
          tmpHint := SelItem.Hint;
          edFileSend.Text := Copy(tmpHint, 1, pos('<sep>', tmpHint) - 1);
          Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
          cbSendFile.IsChecked := Copy(tmpHint, 1, pos('<sep>', tmpHint) - 1).ToBoolean();
          Delete(tmpHint, 1, pos('<sep>', tmpHint) + 4);
          mMessageText.Text := tmpHint;
        end;
      itemBuffer:
        begin
          TabControl.Visible := true;
          TabControl.ActiveTab := tabSeparator;
          edSeparator.Text := SelItem.Hint;
        end;
    end;
  end
  else
  begin
    SelItemStep := nil;

    if Sender is TCornerButton then
      SelItemStep := (Sender as TCornerButton).Parent as TRectangle
    else
      SelItemStep := Sender as TRectangle;

    if SelItemStep = SelItem then
      showmessage('Вы не можете выбрать настраиваемую позицию. Выберите другую позицию.')
    else if SelItemStep.Tag = itemStop then
      showmessage('Вы не можете выбрать позицию обработки ошибки. Выберите другую позицию.')
    else
    begin
      for I := 0 to ObjectList.Content.ChildrenCount - 1 do
        if (ObjectList.Content.Children[I] as TRectangle).Tag = itemStop then
          (ObjectList.Content.Children[I] as TRectangle).Fill.color := $FFFCCEC2
        else if (ObjectList.Content.Children[I] as TRectangle) <> SelItem then
          (ObjectList.Content.Children[I] as TRectangle).Fill.color := $FFF2F2F2;

      if SelItemStep.Tag = itemStop then
        SelItemStep.Fill.color := $FFFBE6B0
      else
        SelItemStep.Fill.color := $FFAAC2C0;
    end;
  end;

end;

end.
