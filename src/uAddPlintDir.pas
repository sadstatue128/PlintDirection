unit uAddPlintDir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PlintDef;

const
  PLINT_NOT_CHOSEN = 'ѕожалуйста, выберите плинт';

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
  //проверить, что что-то выбрано
  if cbPlints.Text = '' then
  begin
    Application.MessageBox(PChar(PLINT_NOT_CHOSEN), PChar(APPLICATION_NAME),MB_ICONERROR);
    Exit;
  end;
  //отправить на добавку новой св€зи
  LChosenPlint := TPlint(cbPlints.Items.Objects[cbPlints.ItemIndex]);
  DM.PlintDirController.AddNewPlintDir(fPlint, LChosenPlint);
  ModalResult := mrOK;
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
  //очистить список
  fPlintList.Clear;
  //заполнить лист
  DM.GetPlintListForBinding(fPlint, fPlintList);
  //заполнить комбобокс
  FillcbPlints;
end;

procedure TfmAddPlintDir.FillcbPlints;
var
  i: Integer;
  LPlint: TPlint;
begin
  cbPlints.Items.Clear;
  for i := 0 to fPlintList.Count - 1 do
  begin
    LPlint := fPlintList[i];
    cbPlints.AddItem(LPlint.Info, TObject(LPlint));
  end;    
end;



end.
