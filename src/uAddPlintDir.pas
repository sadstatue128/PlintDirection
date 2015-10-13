unit uAddPlintDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PlintDef;

const
  PLINT_NOT_CHOSEN = '����������, �������� �����';

type
  TfmAddPlintDir = class(TForm)
    cbPlints: TComboBox;
    btAdd: TButton;
    procedure btAddClick(Sender: TObject);
  private
    fPlint: TPlint;
    fPlintList: TPlintList;
    procedure FillList;
    procedure FillcbPlints;
  public
    constructor Create(aPlint: TPlint; aOwner: TComponent);
    destructor Destroy;
  end;

var
  fmAddPlintDir: TfmAddPlintDir;

implementation

uses uDM;

{$R *.dfm}

{ TfmAddPlintDir }

procedure TfmAddPlintDir.btAddClick(Sender: TObject);
var
  LChosenPlint: TPlint;
begin
  //���������, ��� ���-�� �������
  if cbPlints.Text = '' then
  begin
    Application.MessageBox(PChar(PLINT_NOT_CHOSEN), PChar(APPLICATION_NAME),MB_ICONERROR);
    Exit;
  end;
  //��������� �� ������� ����� �����
  LChosenPlint := TPlint(cbPlints.Items.Objects[cbPlints.ItemIndex]);
  DM.PlintDirController.AddNewPlintDir(fPlint, LChosenPlint);
end;

constructor TfmAddPlintDir.Create(aPlint: TPlint; aOwner: TComponent);
begin
  inherited Create(aOwner);
  fPlint := aPlint;
  fPlintList := TPlintList.Create(false);
  FillList;
end;

destructor TfmAddPlintDir.Destroy;
begin
  fPlintList.Free;
  inherited;
end;

procedure TfmAddPlintDir.FillList;
begin
  //��������� ����
  DM.GetPlintListForBinding(fPlint, fPlintList);
  //��������� ���������
  FillcbPlints;
end;

procedure TfmAddPlintDir.FillcbPlints;
var
  i: Integer;
  LPlint: TPlint;
begin
  for i := 0 to fPlintList.Count - 1 do
  begin
    LPlint := fPlintList[i];
    cbPlints.AddItem(LPlint.Info, TObject(LPlint));
  end;    
end;



end.
