unit uScheduler;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.DateTimeCtrls, FMX.TabControl, FMX.Layouts,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit, System.ImageList,
  FMX.ImgList, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.TreeView, uMain,
  FMX.Objects, uScenarioFrame, uTypes, Generics.Collections, System.Threading, uWork,
  FMX.ExtCtrls, FMX.Effects, FMX.Menus;

type
  TItemTree = class(TObject)
    Level: integer;
    Sorting: integer;
    ParentID: integer;
  end;

  TFormScheduler = class(TForm)
    layLeft: TLayout;
    laySettings: TLayout;
    TabControl: TTabControl;
    TabDaily: TTabItem;
    TabWeekly: TTabItem;
    TabMonthly: TTabItem;
    GridPanelLayout3: TGridPanelLayout;
    cbFirstWorkMonthDay: TCheckBox;
    cbLastWorkMonthDay: TCheckBox;
    cbLastMonthDay: TCheckBox;
    lbMontly: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    ListBoxItem18: TListBoxItem;
    ListBoxItem19: TListBoxItem;
    ListBoxItem20: TListBoxItem;
    ListBoxItem21: TListBoxItem;
    ListBoxItem22: TListBoxItem;
    ListBoxItem23: TListBoxItem;
    ListBoxItem24: TListBoxItem;
    ListBoxItem25: TListBoxItem;
    ListBoxItem26: TListBoxItem;
    ListBoxItem27: TListBoxItem;
    ListBoxItem28: TListBoxItem;
    ListBoxItem29: TListBoxItem;
    ListBoxItem30: TListBoxItem;
    ListBoxItem31: TListBoxItem;
    lbWeekly: TListBox;
    lwScheduler: TListView;
    Gro: TLayout;
    btnOpenScenario: TCornerButton;
    ImageList: TImageList;
    Layout4: TLayout;
    btnSave: TCornerButton;
    Label2: TLabel;
    eName: TEdit;
    FDConn: TFDConnection;
    FDExe: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    btnCancel: TCornerButton;
    layBtns: TLayout;
    btnAdd: TCornerButton;
    btnDel: TCornerButton;
    TabPage: TTabControl;
    TabScheduler: TTabItem;
    TabScenario: TTabItem;
    Layout6: TLayout;
    btnBack: TCornerButton;
    TreeView: TTreeView;
    layScenaries: TLayout;
    layChoose: TLayout;
    Rectangle1: TRectangle;
    RoundRect1: TRoundRect;
    Label3: TLabel;
    btnChosse: TCornerButton;
    btnCancelCreate: TCornerButton;
    layScenariesChoose: TLayout;
    btnAddParent: TCornerButton;
    btnAddChild: TCornerButton;
    btnDown: TCornerButton;
    btnUp: TCornerButton;
    Line1: TLine;
    btnDeleteItem: TCornerButton;
    TabControlSettings: TTabControl;
    TabSettings: TTabItem;
    TabLogs: TTabItem;
    Layout1: TLayout;
    lwLog: TListView;
    FDLog: TFDQuery;
    Label4: TLabel;
    deBegin: TDateEdit;
    deEnd: TDateEdit;
    Label5: TLabel;
    btnRefresh: TCornerButton;
    FDSchedulers: TFDQuery;
    ilRes: TImageList;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField2: TLinkFillControlToField;
    PopupMenu: TPopupMenu;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    TimeEdit: TTimeEdit;
    radioDaily: TRadioButton;
    radioWeekly: TRadioButton;
    radioMonthly: TRadioButton;
    GroupBox2: TGroupBox;
    radioSystem: TRadioButton;
    radioVariable: TRadioButton;
    layVariable: TLayout;
    Label6: TLabel;
    edVariable: TEdit;
    MenuItem1: TMenuItem;
    procedure btnOpenScenarioClick(Sender: TObject);
    procedure radioDailyChange(Sender: TObject);
    procedure radioWeeklyChange(Sender: TObject);
    procedure radioMonthlyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lwSchedulerItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddParentClick(Sender: TObject);
    procedure btnChosseClick(Sender: TObject);
    procedure btnCancelCreateClick(Sender: TObject);
    procedure btnAddChildClick(Sender: TObject);
    procedure TreeViewChange(Sender: TObject);
    procedure btnDeleteItemClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure radioVariableChange(Sender: TObject);
  private
    FScenarioList: TList<TDict>;
    FScenarioItems: TList<TDict>;
    FWork: TWork;
    FScenario: TScenarioFrame;
    FIdScheduler: integer;
    FThread: ITask;
    procedure GetProperty(AItem: TListViewItem);
    procedure ClearProperties;
    procedure LoadScenario;
    function GetScheduleID: integer;
    function FindParent(AParentName: string): TTreeViewItem;
    procedure OnBtnPlay(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
    function ExecuteScenario(IdScenario: integer): Boolean;
    procedure NextStep(IsSuccess: Boolean);
    procedure OnStartPosition(Sender: TObject);
    procedure StartScenaries(APosition: integer);
    function FindParentIdInPopup(AParentID: integer; Level: integer): integer;

    { Private declarations }
  public
    { Public declarations }
    procedure Stop;
  end;

var
  FormScheduler: TFormScheduler;

implementation

uses
  uStopStart;

var
  AFormStopStart: TFormStopStart;

{$R *.fmx}

procedure TFormScheduler.btnAddChildClick(Sender: TObject);
var
  AItem: TTreeViewItem;
begin
  FScenario := TScenarioFrame.Create(nil, ' where id not in (select s.id_scenario from scenaries_tree s where s.id_scheduler = ' + GetScheduleID.ToString + ')');
  FScenario.Parent := layScenariesChoose;
  FScenario.Tag := 1;
  layChoose.Visible := true;
end;

procedure TFormScheduler.btnAddClick(Sender: TObject);
begin
  ClearProperties;
  TabControlSettings.Visible := true;
  radioDaily.IsChecked := true;
  lwScheduler.Selected := lwScheduler.Items.AddItem(lwScheduler.ItemCount);
  layLeft.Enabled := false;
  btnDel.Enabled := true;
  layBtns.Enabled := false;
end;

procedure TFormScheduler.btnAddParentClick(Sender: TObject);
begin
  FScenario := TScenarioFrame.Create(nil, ' where id not in (select s.id_scenario from scenaries_tree s where s.id_scheduler = ' + GetScheduleID.ToString + ')');
  FScenario.Parent := layScenariesChoose;
  FScenario.Tag := 0;
  FScenario.layMenu.Visible := false;
  layChoose.Visible := true;
end;

procedure TFormScheduler.btnBackClick(Sender: TObject);
begin
  btnOpenScenario.Tag := TreeView.Count;
  TabPage.Previous();
end;

procedure TFormScheduler.btnCancelClick(Sender: TObject);
begin
  TabControlSettings.Visible := false;
  layLeft.Enabled := true;
  layBtns.Enabled := true;
  btnDel.Enabled := false;
  FDSchedulers.Active := false;
  FDSchedulers.Active := true;
end;

procedure TFormScheduler.btnCancelCreateClick(Sender: TObject);
begin
  layChoose.Visible := false;
  FScenario.FDQuery.Active := false;
  FScenario.FDExe.Active := false;
  FScenario.FDConnection.Connected := false;

  FreeAndNil(FScenario);
end;

procedure TFormScheduler.btnChosseClick(Sender: TObject);
var
  AParentID: integer;
  AItemTag: integer;
  AItemLevel: integer;
begin
  if FScenario.ListView.Selected <> nil then
  begin

    AItemTag := FScenario.ListView.Items[FScenario.ListView.Selected.Index].ImageIndex;

    FDExe.Active := false;
    FDExe.SQL.Clear;

    if FScenario.Tag = 0 then
    begin

      if (TreeView.Selected = nil) then
      begin
        if TreeView.Count = 0 then
          FDExe.SQL.Append(Format('insert into scenaries_tree (id_scenario,parent_scenario,id_scheduler,level,sorting) values (0,0,%d,0,0);', [GetScheduleID]));

        FDExe.SQL.Append
          (Format('insert into scenaries_tree (id_scenario,parent_scenario,id_scheduler,level,sorting) values (%d,0,%d,1,(select Coalesce(Max(sorting),0) + 1 from scenaries_tree where id_scheduler = %d and parent_scenario = 0));',
          [AItemTag, GetScheduleID, GetScheduleID]));
      end
      else if (TreeView.Selected.Parent.Parent is TTreeViewItem) then
      begin
        AParentID := (TreeView.Selected.Parent.Parent as TTreeViewItem).Tag;
        AItemLevel := TreeView.Selected.Level;
        FDExe.SQL.Append
          (Format('insert into scenaries_tree (id_scenario,parent_scenario,id_scheduler,level,sorting) values (%d,%d,%d,%d,(select Coalesce(Max(sorting),0) + 1 from scenaries_tree where id_scheduler = %d and parent_scenario = %d));',
          [AItemTag, AParentID, GetScheduleID, AItemLevel, GetScheduleID, AParentID]));
      end
      else
      begin
        AItemLevel := TreeView.Selected.Level;
        FDExe.SQL.Append
          (Format('insert into scenaries_tree (id_scenario,parent_scenario,id_scheduler,level,sorting) values (%d,0,%d,%d,(select Coalesce(Max(sorting),0) + 1 from scenaries_tree where id_scheduler = %d and parent_scenario = 0));',
          [AItemTag, GetScheduleID, AItemLevel, GetScheduleID]));
      end;
    end
    else
    begin
      AItemLevel := TreeView.Selected.Level + 1;
      FDExe.SQL.Append
        (Format('insert into scenaries_tree (id_scenario,parent_scenario,id_scheduler,level,sorting) values (%d,%d,%d,%d,(select Coalesce(Max(sorting),0) + 1 from scenaries_tree where id_scheduler = %d and parent_scenario = %d));',
        [AItemTag, TreeView.Selected.Tag, GetScheduleID, AItemLevel, GetScheduleID, TreeView.Selected.Tag]));
    end;

    FDExe.ExecSQL;
    LoadScenario;

    btnCancelCreateClick(nil);
  end;

end;

procedure TFormScheduler.Stop;
begin
  FWork.Stop;

  if FThread <> nil then
  begin
    FThread.Cancel;
    FThread := nil;
  end;

  Self.Show;
end;

procedure TFormScheduler.btnDelClick(Sender: TObject);
begin
  if Messagedlg('Вы уверены, что хотите удалить эту запись?', TMSGdlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = 6 then
  begin
    FDExe.Active := false;
    FDExe.SQL.Clear;
    FDExe.SQL.Append(Format('delete from scheduler_list where id_scheduler = %d;', [GetScheduleID]));
    FDExe.SQL.Append(Format('delete from scenaries_tree where id_scheduler = %d;', [GetScheduleID]));
    FDExe.SQL.Append(Format('delete from scheduler where id = %d;', [GetScheduleID]));

    FDExe.ExecSQL;

    FDSchedulers.Active := false;
    FDSchedulers.Active := true;

    TabControlSettings.Visible := false;

  end;
end;

procedure TFormScheduler.btnDeleteItemClick(Sender: TObject);
begin
  if Messagedlg('Вы уверены, что хотите удалить этот сценарий?', TMSGdlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = 6 then
  begin
    FDExe.Active := false;
    FDExe.SQL.Clear;
    FDExe.SQL.Append(Format('delete from scenaries_tree where id_scenario = %d and id_scheduler = %d;', [TreeView.Selected.Tag, GetScheduleID]));
    FDExe.SQL.Append(Format('update scenaries_tree set sorting = sorting - 1 where id_scheduler = %d and sorting > %d and level = %d;', [GetScheduleID, TreeView.Selected.Index + 1,
      TreeView.Selected.Level]));
    FDExe.ExecSQL;

    LoadScenario;

    if TreeView.Count = 0 then
    begin
      FDExe.SQL.Clear;
      FDExe.SQL.Append(Format('delete from scenaries_tree where id_scheduler = %d;', [GetScheduleID]));
      FDExe.ExecSQL;
    end;

    btnDeleteItem.Enabled := false;
  end;
end;

procedure TFormScheduler.btnDownClick(Sender: TObject);
var
  AText: string;
begin
  if TreeView.Selected <> nil then
  begin
    AText := TreeView.Selected.Text;

    FDExe.Active := false;
    FDExe.SQL.Clear;
    FDExe.SQL.Append
      (Format('update scenaries_tree set sorting = sorting - 1 where id_scheduler = %d and parent_scenario = %d and sorting = %d and sorting <= (select Count(sorting) from scenaries_tree where id_scheduler = %d and parent_scenario = %d);',
      [GetScheduleID, (TreeView.Selected.TagObject as TItemTree).ParentID, (TreeView.Selected.TagObject as TItemTree).Sorting + 1, GetScheduleID,
      (TreeView.Selected.TagObject as TItemTree).ParentID]));
    FDExe.SQL.Append
      (Format('update scenaries_tree set sorting = sorting + 1 where id_scheduler = %d and id_scenario = %d and sorting < (select Count(sorting) from scenaries_tree where id_scheduler = %d and parent_scenario = %d);',
      [GetScheduleID, TreeView.Selected.Tag, GetScheduleID, (TreeView.Selected.TagObject as TItemTree).ParentID]));
    FDExe.ExecSQL;

    LoadScenario;
    TreeView.ItemByText(AText).Select;
  end;
end;

function TFormScheduler.GetScheduleID: integer;
begin
  result := lwScheduler.Items[lwScheduler.Selected.Index].Data['ID'].AsVariant;
end;

procedure TFormScheduler.LoadScenario;
var
  AItem: TTreeViewItem;
  AItemTree: TItemTree;
  AMenuItem: TMenuItem;
  ASpace: string;
begin
  TreeView.Clear;

  FDExe.Active := false;
  FDExe.SQL.Clear;
  FDExe.SQL.Append
    (Format('select id_scenario, parent_scenario, name, (select name from scenaries where id = parent_scenario) as parent_name,level, sorting  from scenaries_tree st join scenaries s on st.id_scenario = s.id where id_scheduler = %d order by level, sorting;',
    [GetScheduleID]));
  FDExe.Active := true;

  while NOT FDExe.Eof do
  begin
    AItem := TTreeViewItem.Create(nil);
    AItemTree := TItemTree.Create;
    AItemTree.Level := FDExe.FieldByName('level').AsInteger;
    AItemTree.Sorting := FDExe.FieldByName('sorting').AsInteger;
    AItemTree.ParentID := FDExe.FieldByName('parent_scenario').AsInteger;

    with AItem do
    begin
      Text := FDExe.FieldByName('name').AsString;
      Tag := FDExe.FieldByName('id_scenario').AsInteger;
      TagObject := AItemTree;
    end;

    AMenuItem := TMenuItem.Create(nil);

    with AMenuItem do
    begin
      ASpace := '';
      GroupIndex := FDExe.FieldByName('level').AsInteger;
      Text := ASpace.PadLeft((FDExe.FieldByName('level').AsInteger - 1) * 5, ' ') + '↪ ' + FDExe.FieldByName('name').AsString;
      Tag := FDExe.FieldByName('id_scenario').AsInteger;
      OnClick := OnStartPosition;
    end;

    if AItemTree.ParentID = 0 then
    begin
      TreeView.AddObject(AItem);
      PopupMenu.AddObject(AMenuItem);
    end
    else
    begin
      FindParent(FDExe.FieldByName('parent_name').AsString).AddObject(AItem);
      PopupMenu.InsertObject(FindParentIdInPopup(AItemTree.ParentID, AMenuItem.GroupIndex), AMenuItem);
    end;

    FDExe.Next;
  end;
end;

procedure TFormScheduler.OnStartPosition(Sender: TObject);
begin
  StartScenaries((Sender as TMenuItem).Index);
end;

function TFormScheduler.FindParent(AParentName: string): TTreeViewItem;
var
  I: integer;
  s: string;
begin
  result := nil;
  TreeView.ExpandAll;
  result := TreeView.ItemByText(AParentName);
end;

function TFormScheduler.FindParentIdInPopup(AParentID: integer; Level: integer): integer;
var
  I: integer;
  s: string;
  j: integer;
begin
  result := -1;

  for I := 0 to PopupMenu.ItemsCount - 1 do
    if PopupMenu.Items[I].Tag = AParentID then
    begin
      j := 1;

      while PopupMenu.Items[I + j].GroupIndex = Level do
        Inc(j);

      result := i + j;
      exit;
    end;
end;

procedure TFormScheduler.btnOpenScenarioClick(Sender: TObject);
begin
  LoadScenario;
  TabPage.Next();
end;

procedure TFormScheduler.btnRefreshClick(Sender: TObject);
var
  SQL: string;
  AFormat: TFormatSettings;
begin
  AFormat := TFormatSettings.Create;
  AFormat.ShortDateFormat := 'YYYY-MM-DD';
  AFormat.DateSeparator := '-';
  SQL := 'select * from all_log where id = ' + lwScheduler.Items[lwScheduler.Selected.Index].Data['ID'].ToString;
  SQL := SQL + ' and sdate between ''' + DateToStr(deBegin.Date, AFormat) + ' 00:00'' and ''' + DateToStr(deEnd.Date, AFormat) + ' 23:59''';
  ExeQ(FDLog, SQL, tsActive);

end;

procedure TFormScheduler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDLog.Active := false;
  FDExe.SQL.Clear;
  FDExe.SQL.Append('delete from scenaries_tree where id_scheduler = 0;');
  FDExe.ExecSQL;
  FDConn.Connected := false;
end;

procedure TFormScheduler.FormCreate(Sender: TObject);
begin
  FDConn.Params.Database := ExtractFilePath(paramstr(0)) + '\base.db';
  FDConn.Connected := true;
  FDSchedulers.Active := true;
  lwScheduler.OnButtonClick := OnBtnPlay;
end;

procedure TFormScheduler.StartScenaries(APosition: integer);
var
  I: integer;
begin

  if Messagedlg('Продолжить запуск этого сценария?', TMSGdlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = 6 then
  begin
    ExeQ(FDExe, 'insert into log_schedulers(id_scheduler,sys_date,type_start) values (' + FIdScheduler.ToString + ',current_timestamp,2)', tsExec);

    AFormStopStart := TFormStopStart.Create(nil);
    AFormStopStart.AForm := Self;
    AFormStopStart.Left := 0;
    AFormStopStart.Top := Round(Screen.Height - 150);
    AFormStopStart.Show;

    Self.Hide;

    if FScenarioList = nil then
      FScenarioList := TList<TDict>.Create
    else
      FScenarioList.Clear;

    if FScenarioItems = nil then
      FScenarioItems := TList<TDict>.Create
    else
      FScenarioItems.Clear;

    if FWork = nil then
    begin
      FWork := TWork.Create(FDConn);
      FWork.Proc := NextStep;
      FWork.Scenaries := FScenarioItems;
    end;

    GetTree(FScenarioList, FIdScheduler, 0, FDExe);

    for I := 0 to APosition - 1 do
      FScenarioList.Delete(0);

    if FScenarioList.Count > 0 then
      ExecuteScenario(FScenarioList[0].Key)
    else
    begin
      FreeAndNil(AFormStopStart);
      Self.Show;
    end;
  end;
end;

procedure TFormScheduler.OnBtnPlay(const Sender: TObject; const AItem: TListItem; const AObject: TListItemSimpleControl);
var
  I: integer;
  AMenuItem: TMenuItem;
begin
  FIdScheduler := (AItem as TListViewItem).Data['ID'].AsVariant;

  if (AObject as TListItemTextButton).Name = 'btnPlay' then
    StartScenaries(0)
  else
  begin
    PopupMenu.Clear;
    LoadScenario;

    PopupMenu.Popup(Screen.MousePos.X, Screen.MousePos.Y);
  end;
end;

procedure TFormScheduler.NextStep(IsSuccess: Boolean);
var
  j: integer;
begin

  if Not IsSuccess and (FScenarioList.Count <> 0) then
    for j := 0 to FScenarioList[0].Value.ToInteger() - 1 do
      FScenarioList.Delete(0);

  FScenarioList.Delete(0);

  if FScenarioList.Count > 0 then
    ExecuteScenario(FScenarioList[0].Key)
  else
  begin
    FreeAndNil(AFormStopStart);
    Self.Show;
  end;
end;

function TFormScheduler.ExecuteScenario(IdScenario: integer): Boolean;
var
  I: integer;
  ADict: TDict;
begin

  FScenarioItems.Clear;
  ExeQ(FDExe, Format('select id,value from scenario_item where id_scenario = %d order by order_id', [IdScenario]), tsActive);

  FDExe.First;

  while NOT FDExe.Eof do
  begin
    ADict.Key := FDExe.FieldByName('id').AsInteger;
    ADict.Value := FDExe.FieldByName('value').AsString;
    ADict.Parent := IdScenario;

    FScenarioItems.Add(ADict);
    FDExe.Next;
  end;

  FThread := TTask.Run(
    procedure
    begin
      FWork.Stopping := false;
      FWork.IDSheduler := FIdScheduler;
      FWork.IdScenario := IdScenario;
      FWork.Start;
    end);
end;

procedure TFormScheduler.lwSchedulerItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  ClearProperties;
  if AItem.Data['ID'].AsVariant <> -1 then
  begin
    FDSchedulers.Locate('id', AItem.Data['ID'].ToString, []);
    TabControlSettings.Visible := true;
    TabControlSettings.ActiveTab := TabSettings;
    eName.Text := FDSchedulers.FieldByName('sname').AsString;
    btnOpenScenario.Tag := FDSchedulers.FieldByName('cnt').AsInteger;
    TimeEdit.Time := FDSchedulers.FieldByName('time_start').AsDateTime;
    edVariable.Text := FDSchedulers.FieldByName('variable').AsString;

    radioSystem.IsChecked := FDSchedulers.FieldByName('variable').AsString = '';
    radioVariable.IsChecked := NOT radioSystem.IsChecked;
    edVariable.Text := FDSchedulers.FieldByName('variable').AsString;

    case FDSchedulers.FieldByName('id_type_repeat').AsInteger of
      1:
        radioDaily.IsChecked := true;
      2:
        radioWeekly.IsChecked := true;
      3:
        radioMonthly.IsChecked := true;
    end;
    GetProperty(AItem);
  end;
  btnDel.Enabled := true;

  deBegin.Date := now();
  deEnd.Date := now();
  btnRefreshClick(nil);
end;

procedure TFormScheduler.btnSaveClick(Sender: TObject);
var
  AIdTypeRepeat: integer;
  I: integer;
  AIndex: integer;
begin

  if eName.Text = '' then
  begin
    showmessage('Введите название процесса.');
    exit
  end;

  if btnOpenScenario.Tag = 0 then
  begin
    showmessage('Произведите настройку сценария.');
    exit
  end;

  if (edVariable.Text = '') and (radioVariable.IsChecked) then
  begin
    showmessage('Поле параметр должно быть заполнено для "Анализируемой даты из сохраненного параметра"');
    exit
  end;

  AIndex := lwScheduler.Selected.Index;

  if radioDaily.IsChecked then
    AIdTypeRepeat := 1;

  if radioWeekly.IsChecked then
    AIdTypeRepeat := 2;

  if radioMonthly.IsChecked then
    AIdTypeRepeat := 3;

  FDExe.Active := false;
  FDExe.SQL.Clear;

  if FDSchedulers.Locate('id', GetScheduleID.ToString, []) then
  begin
    FDExe.SQL.Append(Format('update scheduler set name = ''%s'',time_start=''%s'',id_type_repeat = %d, variable = ''%s'' where id = %d;', [eName.Text, TimeEdit.Text, AIdTypeRepeat, edVariable.Text,
      GetScheduleID]));
    FDExe.SQL.Append(Format('delete from scheduler_list where id_scheduler = %d;', [GetScheduleID]));

    case AIdTypeRepeat of
      2:
        for I := 0 to lbWeekly.Count - 1 do
          if lbWeekly.ListItems[I].IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values (%d,%d);', [GetScheduleID, lbWeekly.ListItems[I].TabOrder]));
      3:
        begin
          for I := 0 to lbMontly.Count - 1 do
            if lbMontly.ListItems[I].IsChecked then
              FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values (%d,%d);', [GetScheduleID, lbMontly.ListItems[I].TabOrder]));

          if cbFirstWorkMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values (%d,%d);', [GetScheduleID, cbFirstWorkMonthDay.TabOrder]));

          if cbLastWorkMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values (%d,%d);', [GetScheduleID, cbLastWorkMonthDay.TabOrder]));

          if cbLastMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values (%d,%d);', [GetScheduleID, cbLastMonthDay.TabOrder]));
        end;
    end;
  end
  else
  begin
    FDExe.SQL.Append(Format('insert into scheduler (name,time_start,id_type_repeat, variable) values (''%s'',''%s'', %d, ''%s'');', [eName.Text, TimeEdit.Text, AIdTypeRepeat, edVariable.Text]));

    case AIdTypeRepeat of
      2:
        for I := 0 to lbWeekly.Count - 1 do
          if lbWeekly.ListItems[I].IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values ((select max(id) from scheduler),%d);', [lbWeekly.ListItems[I].TabOrder]));
      3:
        begin
          for I := 0 to lbMontly.Count - 1 do
            if lbMontly.ListItems[I].IsChecked then
              FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values ((select max(id) from scheduler),%d);', [lbMontly.ListItems[I].TabOrder]));

          if cbFirstWorkMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values ((select max(id) from scheduler),%d);', [cbFirstWorkMonthDay.TabOrder]));

          if cbLastWorkMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values ((select max(id) from scheduler),%d);', [cbLastWorkMonthDay.TabOrder]));

          if cbLastMonthDay.IsChecked then
            FDExe.SQL.Append(Format('insert into scheduler_list (id_scheduler,id_type_name) values ((select max(id) from scheduler),%d);', [cbLastMonthDay.TabOrder]));
        end;
    end;

    FDExe.SQL.Append('update scenaries_tree set id_scheduler = (select max(id) from scheduler) where id_scheduler = 0;');

  end;
  FDExe.ExecSQL;

  btnCancelClick(nil);
end;

procedure TFormScheduler.btnUpClick(Sender: TObject);
var
  AText: string;
begin
  if TreeView.Selected <> nil then
  begin
    AText := TreeView.Selected.Text;

    FDExe.Active := false;
    FDExe.SQL.Clear;
    FDExe.SQL.Append(Format('update scenaries_tree set sorting = sorting + 1 where id_scheduler = %d and parent_scenario = %d and sorting = %d and sorting >= 1;',
      [GetScheduleID, (TreeView.Selected.TagObject as TItemTree).ParentID, (TreeView.Selected.TagObject as TItemTree).Sorting - 1]));
    FDExe.SQL.Append(Format('update scenaries_tree set sorting = sorting - 1 where id_scheduler = %d and id_scenario = %d and sorting > 1;', [GetScheduleID, TreeView.Selected.Tag]));
    FDExe.ExecSQL;

    LoadScenario;
    TreeView.ItemByText(AText).Select;
  end;
end;

procedure TFormScheduler.ClearProperties;
var
  I: integer;
begin
  eName.Text := '';
  btnOpenScenario.Tag := 0;

  for I := 0 to lbWeekly.Count - 1 do
    lbWeekly.ListItems[I].IsChecked := false;
  for I := 0 to lbMontly.Count - 1 do
    lbMontly.ListItems[I].IsChecked := false;

  cbFirstWorkMonthDay.IsChecked := false;
  cbLastWorkMonthDay.IsChecked := false;
  cbLastMonthDay.IsChecked := false;
  radioSystem.IsChecked := true;
end;

procedure TFormScheduler.GetProperty(AItem: TListViewItem);
var
  AListTypes, AListType: string;
  I: integer;
begin
  if AItem.Data['ID'].AsVariant <> 0 then
  begin
    FDSchedulers.Locate('id', AItem.Data['ID'].ToString, []);
    AListTypes := FDSchedulers.FieldByName('tnname').AsString;

    case FDSchedulers.FieldByName('id_type_repeat').AsInteger of
      2:
        begin
          while AListTypes <> '' do
          begin
            AListType := Copy(AListTypes, 1, 2);
            Delete(AListTypes, 1, 3);
            for I := 0 to lbWeekly.Count - 1 do
              if lbWeekly.ListItems[I].ItemData.Text = AListType then
                lbWeekly.ListItems[I].IsChecked := true;
          end;
        end;
      3:
        begin
          while AListTypes <> '' do
          begin

            if Pos(',', AListTypes) <> 0 then
            begin
              AListType := Copy(AListTypes, 1, Pos(',', AListTypes) - 1);
              Delete(AListTypes, 1, Pos(',', AListTypes))
            end
            else
            begin
              AListType := Copy(AListTypes, 1);
              AListTypes := ''
            end;

            for I := 0 to lbMontly.Count - 1 do
              if lbMontly.ListItems[I].ItemData.Text = AListType then
                lbMontly.ListItems[I].IsChecked := true;

            if AListType = cbFirstWorkMonthDay.Text then
              cbFirstWorkMonthDay.IsChecked := true;

            if AListType = cbLastWorkMonthDay.Text then
              cbLastWorkMonthDay.IsChecked := true;

            if AListType = cbLastMonthDay.Text then
              cbLastMonthDay.IsChecked := true;
          end;
        end;
    end;
  end;

end;

procedure TFormScheduler.radioDailyChange(Sender: TObject);
begin
  TabControl.ActiveTab := TabDaily;

  if lwScheduler.Selected <> nil then
    GetProperty(lwScheduler.Items[lwScheduler.Selected.Index]);
end;

procedure TFormScheduler.radioMonthlyChange(Sender: TObject);
begin
  TabControl.ActiveTab := TabMonthly;
end;

procedure TFormScheduler.radioVariableChange(Sender: TObject);
begin
  layVariable.Visible := radioVariable.IsChecked;

  if NOT layVariable.Visible then
    edVariable.Text := '';
end;

procedure TFormScheduler.radioWeeklyChange(Sender: TObject);
begin
  TabControl.ActiveTab := TabWeekly;
end;

procedure TFormScheduler.TreeViewChange(Sender: TObject);
begin
  if TreeView.Selected <> nil then
  begin
    btnAddChild.Enabled := true;
    btnDeleteItem.Enabled := true;
  end;
end;

end.
