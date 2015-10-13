unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  uStructure, uPlintDirection, PlintDef, DirectionDef, uAddPlintDir;

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
    Panel2: TPanel;
    lblInfo: TLabel;
    frmPlintDirection1: TfrmPlintDirection;
    procedure btCreateNodesClick(Sender: TObject);
    procedure edNodeCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNodeCountEnter(Sender: TObject);
    procedure btClearAllClick(Sender: TObject);
    procedure edNodeCountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure frmPlintDirection1btAddClick(Sender: TObject);
    function GetCurPlint: TPlint;
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
    property CurPlint: TPlint read GetCurPlint;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses uDM;


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
end;

{$Region '������ �������� ���������'}

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
  edNodeCount.Text := '���������� �����...';
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

{$Region '����������� �� ���������'}

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

{$Region '�������������� �����������������'}

procedure TfmMain.frmPlintDirection1btAddClick(Sender: TObject);
var
  Lfm: TfmAddPlintDir;
  ModRes: Integer;
begin
  Lfm := TfmAddPlintDir.Create(CurPlint, Self);
  try
    ModRes := Lfm.ShowModal;
    if ModRes = mrOK then
      frmPlintDirection1.Refresh;
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
end.
