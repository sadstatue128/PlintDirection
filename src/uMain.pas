unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  uStructure, uPlintDirection, PlintDef, DirectionDef, uAddPlintDir, Grids;

const
  ERROR_NODE_COUNT = '"%s"';

type
  TfmMain = class(TForm)
    pnLeft: TPanel;
    frmStructure1: TfrmStructure;
    btCreateNodes: TButton;
    edNodeCount: TEdit;
    btClearAll: TButton;
    pnPlintDir: TPanel;
    pnPlintDirs: TPanel;
    lblInfo: TLabel;
    frmPlintDirection1: TfrmPlintDirection;
    lblPlintDirName: TLabel;
    GrPlintDirections: TStringGrid;
    btCalc: TButton;
    Button1: TButton;
    procedure btCreateNodesClick(Sender: TObject);
    procedure edNodeCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNodeCountEnter(Sender: TObject);
    procedure btClearAllClick(Sender: TObject);
    procedure edNodeCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure frmPlintDirection1btAddClick(Sender: TObject);
    function GetCurPlint: TPlint;
    procedure btCalcClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fEmpty: Boolean;
    fNodeCount: Integer;
    fCurRecord: TRecord;
    procedure ClearMainCtrls;
    procedure MainCtrlsBeforePlintCreation;
    procedure MainCtrlsAfterPlintCreate;
    function CheckNodeCounts: Boolean;
    procedure FillStruc;
    procedure ClearStruct;
    procedure HandleSelectedData(aRecord: TRecord; aType: TChosenType);
    procedure FillInfo;
    procedure ClearAll;
    procedure FillPlintDir;
    procedure FillGrPlintDirections;
    procedure ClearGrPlintDirections;
    property CurPlint: TPlint read GetCurPlint;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses uDM, uCalcDirection;


procedure TfmMain.FormCreate(Sender: TObject);
begin
  frmStructure1.ChangeEvent := HandleSelectedData;
  ClearAll;
end;

procedure TfmMain.ClearAll;
begin
  fCurRecord := nil;
  frmPlintDirection1.Visible := false;
  ClearStruct;
  ClearMainCtrls;
  lblInfo.Caption := '';
  ClearGrPlintDirections;
end;

{$Region 'Кнопки создания структуры'}



procedure TfmMain.btClearAllClick(Sender: TObject);
begin
  ClearAll;
end;

procedure TfmMain.FillStruc;
begin
  DM.AddTestNodes(fNodeCount);
  frmStructure1.FillStruct;
end;

procedure TfmMain.ClearStruct;
begin
  fNodeCount := 0;
  FillStruc;
end;

procedure TfmMain.btCreateNodesClick(Sender: TObject);
begin
  if CheckNodeCounts then
  begin
    MainCtrlsAfterPlintCreate;
    FillStruc;
  end
  else
  begin
    ClearMainCtrls;
  end;
end;

procedure TfmMain.edNodeCountChange(Sender: TObject);
begin
  MainCtrlsBeforePlintCreation;
end;

procedure TfmMain.edNodeCountEnter(Sender: TObject);
begin
  if edNodeCount.Enabled = true then
    edNodeCount.Text := EmptyStr;
end;

procedure TfmMain.edNodeCountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btCreateNodesClick(btCreateNodes);
end;

procedure TfmMain.ClearMainCtrls;
begin
  fEmpty := True;
  fNodeCount := 0;
  edNodeCount.Text := 'Количество узлов...';
  edNodeCount.Font.Color := clGrayText;
  edNodeCount.Enabled := true;
  btCreateNodes.Enabled := false;
  btClearAll.Enabled := false;
end;

procedure TfmMain.MainCtrlsBeforePlintCreation;
begin
  fEmpty := false;
  edNodeCount.Font.Color := clBlack;
  btCreateNodes.Enabled := True;
  btClearAll.Enabled := false;
end;

procedure TfmMain.MainCtrlsAfterPlintCreate;
begin
  edNodeCount.Font.Color := clGrayText;
  edNodeCount.Enabled := false;
  btCreateNodes.Enabled := false;
  btClearAll.Enabled := True;
end;

function TfmMain.CheckNodeCounts: Boolean;
var
  N: Integer;
begin
  N := StrToIntDef(edNodeCount.Text, 0);
  if N <= 0 then
  begin
    Application.MessageBox(PChar(Format(ERROR_NODE_COUNT, [edNodeCount.Text])), PChar(APPLICATION_NAME),MB_ICONERROR);
    result := false;
    Exit;
  end;
  result := true;
  fNodeCount := N;
end;

{$Endregion}

{$Region 'Перемещение по структуре'}

procedure TfmMain.HandleSelectedData(aRecord: TRecord; aType: TChosenType);
begin
  fCurRecord := aRecord;
  FillInfo;
  FillPlintDir;
end;

procedure TfmMain.FillInfo;
begin
  if fCurRecord is TNode then
    lblInfo.Caption := TNode(fCurRecord).Info
  else if fCurRecord is TCU then
    lblInfo.Caption := TCU(fCurRecord).Info
  else if fCurRecord is TPlint then
    lblInfo.Caption := TPlint(fCurRecord).Info   
end;

procedure TfmMain.FillPlintDir;
begin
  if fCurRecord is TPlint then
  begin
    frmPlintDirection1.AssignPlint(TPlint(fCurRecord));
    frmPlintDirection1.Refresh;
    frmPlintDirection1.Visible := true;    
  end
  else
    frmPlintDirection1.Visible := false;
end;

{$Endregion}

{$Region 'Редактирование плинтонаправлений'}

procedure TfmMain.frmPlintDirection1btAddClick(Sender: TObject);
var
  Lfm: TfmAddPlintDir;
  ModRes: Integer;
begin
  Lfm := TfmAddPlintDir.Create(CurPlint, Self);
  try
    ModRes := Lfm.ShowModal;
    if ModRes = mrOK then
    begin
      frmPlintDirection1.Refresh;
      FillGrPlintDirections;
    end;
  finally
    Lfm.Free;
  end;
end;

function TfmMain.GetCurPlint: TPlint;
begin
  result := nil;
  if Assigned(fCurRecord)and (fCurRecord is TPlint) then
    result := TPlint(fCurRecord);
end;

{$Endregion}

{$Region 'Все плинтонаправления'}

procedure  TfmMain.FillGrPlintDirections;
var
  i: Integer;
  LPlintDir: TPlintDirection;
begin
  ClearGrPlintDirections;
  GrPlintDirections.RowCount := DM.PlintDirController.Dirs.Count;
  for i := 0 to DM.PlintDirController.Dirs.Count - 1 do
  begin
    LPlintDir := DM.PlintDirController.Dirs[i];
    GrPlintDirections.Objects[0, i] := TObject(LPlintDir);
    GrPlintDirections.Cells[0, i] := LPlintDir.Info;
  end;
end;

procedure TfmMain.ClearGrPlintDirections;
var
  i: Integer;
begin
  for i := 0 to grPlintDirections.RowCount - 1 do
    grPlintDirections.Rows[i].Clear;
end;

{$Endregion}


procedure TfmMain.btCalcClick(Sender: TObject);
var
  LCalcDirFm: TfmCalcDirection;
begin
  LCalcDirFm := TfmCalcDirection.Create(Self);
  try
    LCalcDirFm.ShowModal;
  finally
    LCalcDirFm.Free;
  end;
end;

procedure TfmMain.Button1Click(Sender: TObject);
begin
  DM.PlintDirController.Dirs.Sort;
  FillGrPlintDirections;
end;

end.
