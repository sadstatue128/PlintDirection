object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = #1059#1087#1072#1082#1086#1074#1082#1072' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1081
  ClientHeight = 626
  ClientWidth = 883
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 344
    Top = 48
    Width = 4
    Height = 17
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clHotLight
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object pnLeft: TPanel
    Left = 0
    Top = 0
    Width = 321
    Height = 626
    Align = alLeft
    TabOrder = 1
    inline frmStructure1: TfrmStructure
      Left = 1
      Top = 1
      Width = 319
      Height = 624
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 319
      ExplicitHeight = 624
      inherited tvComStruct: TTreeView
        Width = 319
        Height = 624
        ExplicitWidth = 319
        ExplicitHeight = 624
      end
    end
  end
  object btCreateNodes: TButton
    Left = 472
    Top = 8
    Width = 75
    Height = 21
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 2
    OnClick = btCreateNodesClick
  end
  object edNodeCount: TEdit
    Left = 344
    Top = 8
    Width = 122
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = edNodeCountChange
    OnEnter = edNodeCountEnter
    OnKeyDown = edNodeCountKeyDown
  end
  object btClearAll: TButton
    Left = 557
    Top = 8
    Width = 124
    Height = 21
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1090#1088#1091#1082#1090#1091#1088#1091
    TabOrder = 3
    OnClick = btClearAllClick
  end
  object pnPlintDir: TPanel
    Left = 368
    Top = 71
    Width = 377
    Height = 210
    BevelOuter = bvLowered
    TabOrder = 4
    inline frmPlintDirection1: TfrmPlintDirection
      Left = 1
      Top = 1
      Width = 375
      Height = 208
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 487
      ExplicitHeight = 208
      inherited lblPlintDir: TLabel
        Left = 103
        Top = 12
        Font.Charset = RUSSIAN_CHARSET
        ExplicitLeft = 103
        ExplicitTop = 12
      end
      inherited grPlintDirections: TStringGrid
        Width = 233
        Height = 161
        DefaultColWidth = 200
        ExplicitWidth = 233
        ExplicitHeight = 161
      end
      inherited btAdd: TButton
        Left = 281
        Top = 150
        Height = 43
        OnClick = frmPlintDirection1btAddClick
        ExplicitLeft = 281
        ExplicitTop = 150
        ExplicitHeight = 43
      end
    end
  end
  object pnPlintDirs: TPanel
    Left = 368
    Top = 304
    Width = 488
    Height = 257
    BevelOuter = bvLowered
    TabOrder = 5
    object lblPlintDirName: TLabel
      Left = 176
      Top = 9
      Width = 103
      Height = 13
      Caption = #1055#1083#1080#1085#1090#1086#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object GrPlintDirections: TStringGrid
      Left = 25
      Top = 30
      Width = 440
      Height = 206
      ColCount = 1
      DefaultColWidth = 400
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 0
    end
  end
end
