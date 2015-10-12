program PlintDirection;

uses
  Forms,
  PlintDef in 'PlintDef.pas',
  uStructure in 'uStructure.pas' {frmStructure: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule},
  uMain in 'uMain.pas' {fmMain},
  uPlintDirection in 'uPlintDirection.pas' {frmPlintDirection: TFrame},
  DirectionDef in 'DirectionDef.pas',
  uAddPlintDir in 'uAddPlintDir.pas' {fmAddPlintDir};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmAddPlintDir, fmAddPlintDir);
  Application.Run;
end.
