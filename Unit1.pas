unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,system.StrUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.Taskbar,
  Vcl.JumpList, Vcl.ActnPopup, Vcl.StdStyleActnCtrls, System.Win.TaskbarCore,
  Vcl.Printers, Vcl.PlatformDefaultStyleActnCtrls;

type
  TForm1 = class(TForm)
    PopupActionBar1: TPopupActionBar;
    Save1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Cut1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Taskbar1: TTaskbar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    Help1: TMenuItem;
    new2: TMenuItem;
    open2: TMenuItem;
    save2: TMenuItem;
    saveas2: TMenuItem;
    close2: TMenuItem;
    N3: TMenuItem;
    cut2: TMenuItem;
    copy1: TMenuItem;
    paste1: TMenuItem;
    find1: TMenuItem;
    findinfiles1: TMenuItem;
    replace1: TMenuItem;
    delphihelp1: TMenuItem;
    about1: TMenuItem;
    JumpList1: TJumpList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    SaveAs1: TMenuItem;
    StatusBar1: TStatusBar;
    Format1: TMenuItem;
    Format2: TMenuItem;
    FontDialog1: TFontDialog;
    PageSetup1: TMenuItem;
    N4: TMenuItem;
    Print1: TMenuItem;
    PageSetupDialog1: TPageSetupDialog;
    ReplaceDialog1: TReplaceDialog;
    FindDialog1: TFindDialog;
    PrintDialog1: TPrintDialog;
    SelectAll1: TMenuItem;
    Delete1: TMenuItem;
    richedit1: TRichEdit;
    procedure Close1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure open2Click(Sender: TObject);
    procedure saveas2Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure new2Click(Sender: TObject);
    procedure Format2Click(Sender: TObject);
    procedure PageSetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure find1Click(Sender: TObject);
    procedure replace1Click(Sender: TObject);
    procedure copy1Click(Sender: TObject);
    procedure cut2Click(Sender: TObject);
    procedure paste1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure about1Click(Sender: TObject);
  private
    FCurrentFile: string;
    FModified: Boolean;
    procedure UpdateCaption;
    procedure SetModified(Sender: TObject);
    function SaveCurrentFile: Boolean;
    function PromptSave: Boolean;
  public
    function SaveAs: boolean;
    procedure SaveFile;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenDialog1.Filter := 'Rich Text Files (*.rtf)|*.RTF|Text files (*.txt)|*.TXT|Any file (*.*)|*.*';
  SaveDialog1.Filter := 'Rich Text Files (*.rtf)|*.RTF|Text files (*.txt)|*.TXT|Any file (*.*)|*.*';
  SaveDialog1.Options := [ofOverwritePrompt];
  FCurrentFile := '';
  FModified := False;
  richedit1.Clear;
  richedit1.OnChange := SetModified;
  UpdateCaption;
end;

procedure TForm1.SetModified(Sender: TObject);
begin
  if not FModified then
  begin
    FModified := True;
    UpdateCaption;
  end;
end;

procedure TForm1.UpdateCaption;
var
  Title: string;
begin
  if FCurrentFile = '' then
    Title := 'Untitled'
  else
    Title := ExtractFileName(FCurrentFile);

  if FModified then
    Caption := Title + '* - Despeedy Text'
  else
    Caption := Title + ' - Despeedy Text';
end;

function TForm1.PromptSave: Boolean;
var
  Response: Integer;
begin
  Result := True;
  if FModified then
  begin
    Response := MessageDlg('Save changes to ' +
      Ifthen(FCurrentFile = '', 'Untitled', ExtractFileName(FCurrentFile)) + '?',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case Response of
      mrYes: Result := SaveCurrentFile;
      mrCancel: Result := False;
    end;
  end;
end;

function TForm1.SaveCurrentFile: Boolean;
begin
  if FCurrentFile = '' then
    Result := SaveAs
  else
  begin
    try
      richedit1.Lines.SaveToFile(FCurrentFile);
      FModified := False;
      UpdateCaption;
      Result := True;
    except
      on E: Exception do
      begin
        MessageDlg('Error saving file: ' + E.Message, mtError, [mbOK], 0);
        Result := False;
      end;
    end;
  end;
end;

procedure TForm1.new2Click(Sender: TObject);
begin
  if PromptSave then
  begin
    richedit1.Clear;
    FCurrentFile := '';
    FModified := False;
    UpdateCaption;
  end;
end;

procedure TForm1.open2Click(Sender: TObject);
begin
  if not PromptSave then Exit;

  if OpenDialog1.Execute then
  begin
    if FileExists(OpenDialog1.FileName) then
    begin
      try
        richedit1.Lines.LoadFromFile(OpenDialog1.FileName);
        FCurrentFile := OpenDialog1.FileName;
        FModified := False;
        UpdateCaption;
      except
        on E: Exception do
          MessageDlg('Error opening file: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  SaveCurrentFile;
end;

procedure TForm1.saveas2Click(Sender: TObject);
begin
  SaveAs;
end;

function TForm1.SaveAs: Boolean;
begin
  Result := False;
  if SaveDialog1.Execute then
  begin
    try
      richedit1.Lines.SaveToFile(SaveDialog1.FileName);
      FCurrentFile := SaveDialog1.FileName;
      FModified := False;
      UpdateCaption;
      Result := True;
    except
      on E: Exception do
        MessageDlg('Error saving file: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm1.SaveFile;
begin
  SaveCurrentFile;
end;

// Edit operations
procedure TForm1.copy1Click(Sender: TObject);
begin
  richedit1.CopyToClipboard;
end;

procedure TForm1.cut2Click(Sender: TObject);
begin
  richedit1.CutToClipboard;
end;

procedure TForm1.paste1Click(Sender: TObject);
begin
  richedit1.PasteFromClipboard;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  richedit1.SelText := '';
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  richedit1.SelectAll;
end;

// Format
procedure TForm1.Format2Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    richedit1.SelAttributes.Assign(FontDialog1.Font);
end;

// Find and Replace
procedure TForm1.find1Click(Sender: TObject);
begin
  FindDialog1.FindText := richedit1.SelText;
  FindDialog1.Execute;
end;

procedure TForm1.replace1Click(Sender: TObject);
begin
  ReplaceDialog1.FindText := richedit1.SelText;
  ReplaceDialog1.Execute;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: Integer;
  SearchOptions: TSearchTypes;
begin
  SearchOptions := [];
  if frMatchCase in FindDialog1.Options then
    SearchOptions := SearchOptions + [stMatchCase];
  if frWholeWord in FindDialog1.Options then
    SearchOptions := SearchOptions + [stWholeWord];

  with richedit1 do
  begin
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;

    ToEnd := Length(Text) - StartPos;
    FoundAt := FindText(FindDialog1.FindText, StartPos, ToEnd, SearchOptions);

    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
    end
    else
      MessageDlg('Text "' + FindDialog1.FindText + '" not found.',
        mtInformation, [mbOK], 0);
  end;
end;

procedure TForm1.ReplaceDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: Integer;
  SearchOptions: TSearchTypes;
begin
  SearchOptions := [];
  if frMatchCase in ReplaceDialog1.Options then
    SearchOptions := SearchOptions + [stMatchCase];
  if frWholeWord in ReplaceDialog1.Options then
    SearchOptions := SearchOptions + [stWholeWord];

  with richedit1 do
  begin
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;

    ToEnd := Length(Text) - StartPos;
    FoundAt := FindText(ReplaceDialog1.FindText, StartPos, ToEnd, SearchOptions);

    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(ReplaceDialog1.FindText);
    end
    else
      MessageDlg('Text "' + ReplaceDialog1.FindText + '" not found.',
        mtInformation, [mbOK], 0);
  end;
end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
begin
  if richedit1.SelText = ReplaceDialog1.FindText then
    richedit1.SelText := ReplaceDialog1.ReplaceText;

  ReplaceDialog1Find(Sender);
end;

// Print
procedure TForm1.Print1Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    // Simple print - you can enhance this
    Printer.BeginDoc;
    Printer.Canvas.Font.Assign(richedit1.Font);
    Printer.Canvas.TextOut(100, 100, richedit1.Text);
    Printer.EndDoc;
  end;
end;

procedure TForm1.PageSetup1Click(Sender: TObject);
begin
  PageSetupDialog1.Execute;
end;

// Close and Exit
procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := PromptSave;
end;

// About
procedure TForm1.about1Click(Sender: TObject);
begin
  MessageDlg('Despeedy Text Editor' + sLineBreak +
    'Version 1.0' + sLineBreak +
    'A complete text editor built with Delphi' + sLineBreak +
    'Using TRichEdit component', mtInformation, [mbOK], 0);
end;

end.
