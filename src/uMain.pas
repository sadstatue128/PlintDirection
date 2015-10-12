unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  uStructure;

const
  ERROR_NODE_COUNT = '"%s"';

type
  TfmMain = class(TForm)
    pnLeft: TPanel;
    frmStructure1: TfrmStructure;
    btCreateNodes: TButton;
    edNodeCount: TEdit;
    btClearAll: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btCreateNodesClick(Sender: TObject);
    procedure edNodeCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNodeCountEnter(Sender: TObject);
    procedure btClearAllClick(Sender: TObject);
  private
    fEmpty: Boolean;
    fNodeCount: Integer;
    procedure ClearMainCtrls;
    procedure MainCtrlsBeforePlintCreation;
    procedure MainCtrlsAfterPlintCreate;
    function CheckNodeCounts: Boolean;
    procedure FillStruc;
    procedure ClearStruct;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses uDM;

procedure TfmMain.btClearAllClick(Sender: TObject);
begin
  ClearStruct;
  ClearMainCtrls;
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

procedure TfmMain.FormCreate(Sender: TObject);
begin
  ClearMainCtrls;
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
    Application.MessageBox(PChar(Format(ERROR_NODE_COUNT, [edNodeCount.Text])), PChar(Application.Name),MB_ICONERROR);
    result := false;
    Exit;
  end;
  result := true;
  fNodeCount := N;
end;


end.
