object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = #1059#1087#1072#1082#1086#1074#1082#1072' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1081
  ClientHeight = 819
  ClientWidth = 1116
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object lblInfo: TLabel
    Left = 450
    Top = 63
    Width = 5
    Height = 21
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clHotLight
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblNodeCount: TLabel
    Left = 450
    Top = 4
    Width = 118
    Height = 17
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1079#1083#1086#1074
  end
  object pnLeft: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 819
    Align = alLeft
    TabOrder = 1
    inline frmStructure1: TfrmStructure
      Left = 1
      Top = 1
      Width = 418
      Height = 817
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 418
      ExplicitHeight = 817
      inherited tvComStruct: TTreeView
        Width = 418
        Height = 817
        ExplicitWidth = 418
        ExplicitHeight = 817
      end
    end
  end
  object btCreateNodes: TButton
    Left = 617
    Top = 22
    Width = 98
    Height = 28
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 2
    OnClick = btCreateNodesClick
  end
  object edNodeCount: TEdit
    Left = 450
    Top = 22
    Width = 159
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = edNodeCountChange
    OnEnter = edNodeCountEnter
    OnKeyDown = edNodeCountKeyDown
  end
  object btClearAll: TButton
    Left = 728
    Top = 22
    Width = 163
    Height = 28
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1090#1088#1091#1082#1090#1091#1088#1091
    TabOrder = 3
    OnClick = btClearAllClick
  end
  object pnPlintDir: TPanel
    Left = 450
    Top = 93
    Width = 493
    Height = 274
    BevelOuter = bvLowered
    TabOrder = 4
    inline frmPlintDirection1: TfrmPlintDirection
      Left = 1
      Top = 1
      Width = 491
      Height = 272
      Align = alClient
      TabOrder = 0
      ExplicitLeft = -31
      ExplicitTop = -3
      ExplicitWidth = 491
      ExplicitHeight = 272
      inherited lblPlintDir: TLabel
        Left = 135
        Top = 16
        Width = 129
        Height = 18
        Caption = #1057#1074#1103#1079#1072#1085#1085#1099#1077' '#1087#1083#1080#1085#1090#1099
        Font.Charset = RUSSIAN_CHARSET
        Font.Height = -15
        ExplicitLeft = 135
        ExplicitTop = 16
        ExplicitWidth = 129
        ExplicitHeight = 18
      end
      inherited grPlintDirections: TStringGrid
        Left = 31
        Top = 42
        Width = 305
        Height = 210
        DefaultColWidth = 200
        ExplicitLeft = 31
        ExplicitTop = 42
        ExplicitWidth = 305
        ExplicitHeight = 210
      end
      inherited btAdd: TButton
        Left = 367
        Top = 196
        Width = 99
        Height = 56
        OnClick = frmPlintDirection1btAddClick
        ExplicitLeft = 367
        ExplicitTop = 196
        ExplicitWidth = 99
        ExplicitHeight = 56
      end
    end
  end
  object pnPlintDirs: TPanel
    Left = 450
    Top = 398
    Width = 638
    Height = 336
    BevelOuter = bvLowered
    TabOrder = 5
    object lblPlintDirName: TLabel
      Left = 230
      Top = 12
      Width = 132
      Height = 17
      Caption = #1055#1083#1080#1085#1090#1086#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object GrPlintDirections: TStringGrid
      Left = 33
      Top = 39
      Width = 575
      Height = 270
      ColCount = 1
      DefaultColWidth = 500
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      TabOrder = 0
    end
  end
  object btCalc: TButton
    Left = 818
    Top = 756
    Width = 144
    Height = 55
    Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
    TabOrder = 6
    OnClick = btCalcClick
  end
  object btSort: TButton
    Left = 561
    Top = 756
    Width = 137
    Height = 55
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 7
    OnClick = btSortClick
  end
end
