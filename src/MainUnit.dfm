object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Blocker'
  ClientHeight = 175
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BlockLabel: TLabel
    Left = 0
    Top = 0
    Width = 745
    Height = 175
    Align = alClient
    Caption = 'CD-ROM, Keyboard and mouse are blocked'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -64
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    OnClick = BlockLabelClick
    OnDblClick = BlockLabelDblClick
    ExplicitWidth = 743
    ExplicitHeight = 154
  end
  object BlockTimer: TTimer
    OnTimer = BlockTimerTimer
    Left = 8
    Top = 8
  end
  object InBlockTimer: TTimer
    Enabled = False
    OnTimer = InBlockTimerTimer
    Left = 40
    Top = 8
  end
end
