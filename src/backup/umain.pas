unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  ExtCtrls, DBGrids, DBExtCtrls, DateTimePicker, DBDateTimePicker, LR_Class,
  LR_DBSet, LR_Desgn, udm, db, SQLDB;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frDesigner1: TfrDesigner;
    frReport1: TfrReport;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    SearchEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    QueryPrint: TSQLQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frDesigner1LoadReport(Report: TfrReport; var ReportName: String);
    procedure Panel1Click(Sender: TObject);
    procedure SearchEditChange(Sender: TObject);
    procedure LoadImageFromBlobField(AField: TField; AImage: TImage);
    procedure SetImageToBlobField(AField: TField; AImage: TImage);
    procedure enablededitor(saklar: boolean);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SearchEditChange(Sender: TObject);
begin
  with DataModule1 do
  begin
  QueryBrg.Close;
  QueryBrg.SQL.Text := 'SELECT * FROM barang WHERE id_barang LIKE :SearchText OR nama_barang LIKE :SearchText';
  QueryBrg.ParamByName('SearchText').AsString := '%' + SearchEdit.Text + '%';
  QueryBrg.Open;
  end;
end;

procedure TForm1.LoadImageFromBlobField(AField: TField; AImage: TImage);
var
  BlobStream: TStream;
  Picture: TPicture;

begin
  // Pastikan AField dan AImage bukan nil
  if (AField = nil) or (AImage = nil) then
    Exit;

  // Pastikan AField adalah TBlobField
  if not (AField is TBlobField) then
    Exit;

  // Buat BlobStream dari AField
  BlobStream := SQLQuery1.CreateBlobStream(AField, bmRead);
  if BlobStream = nil then
    Exit;

  try
    // Periksa apakah BlobStream memiliki data
    if BlobStream.Size > 0 then
    begin
      Picture := TPicture.Create;
      try
        Picture.LoadFromStream(BlobStream);
        AImage.Picture.Assign(Picture);
      finally
        Picture.Free;
      end;
    end;
  finally
    BlobStream.Free;
  end;
end;

procedure TForm1.SetImageToBlobField(AField: TField; AImage: TImage);
var
  BlobStream: TStream;
begin
  if not (AField is TBlobField) then Exit;

  BlobStream := DataModule1.QueryBrg.CreateBlobStream(AField, bmWrite);
  try
    AImage.Picture.SaveToStream(BlobStream);
  finally
    BlobStream.Free;
  end;
end;

procedure TForm1.enablededitor(saklar: boolean);
begin
    if(saklar=True) then
  begin
  edit1.Enabled := true;
  edit2.Enabled := true;
  edit3.Enabled := true;
  edit2.Caption:= '';
  edit3.Caption:= '';
  DateTimePicker1.Enabled:=True;
  Button3.Enabled:=True;
  end
  else if(saklar=False) then
  begin
  edit1.Enabled := False;
  edit2.Enabled := False;
  edit3.Enabled := False;
  DateTimePicker1.Enabled:=False;
  Button3.Enabled:=False;

  end;

end;



procedure TForm1.Button1Click(Sender: TObject);
var
  CurrentDateTime: TDateTime;
  DT : String;
  KodeID : string;
begin
  if Button1.Caption = 'Simpan'then
  begin
  CurrentDateTime := now;
  DT := DateTimeToStr(CurrentDateTime);
  KodeID :=   StringReplace(DT, '/', '', [rfReplaceAll]);
  KodeID :=   StringReplace(KodeID, '.', '', [rfReplaceAll]);
  Edit1.Text:='BRG-'+KodeID;
  with DataModule1 do
  begin
    if QueryBrg.Active then
      QueryBrg.Close;

    QueryBrg.SQL.Text := 'INSERT INTO barang (id_barang, nama_barang, stok_barang, tanggal_masuk, gambar_barang) ' +
                          'VALUES (:id, :nama, :stok, :tanggal, :gambar)';
    QueryBrg.Params.ParamByName('id').AsString := Edit1.Text;
    QueryBrg.Params.ParamByName('nama').AsString := Edit2.Text;
    QueryBrg.Params.ParamByName('stok').AsInteger := StrToInt(Edit3.Text);
    QueryBrg.Params.ParamByName('tanggal').AsDateTime := DateTimePicker1.DateTime;

    // Tambahkan gambar jika ada
    if OpenDialog1.FileName <> '' then
    begin
      // Menyimpan gambar ke dalam field BLOB
      QueryBrg.Params.ParamByName('gambar').LoadFromFile(OpenDialog1.FileName, ftBlob);
    end
    else
    begin
      QueryBrg.Params.ParamByName('gambar').Clear;
    end;

    QueryBrg.ExecSQL;
    SQLTransaction1.Commit;

    QueryBrg.Close;
    QueryBrg.SQL.Text := 'SELECT * FROM barang';
    QueryBrg.Open;
    Button1.Caption := 'Tambah';
    EnabledEditor(false);
    Button4.Enabled:=True;
    Button2.Caption:='Hapus';
  end;
  end
else if Button1.Caption = 'Tambah' then
begin
     Button1.Caption:='Simpan';
     EnabledEditor(true);
     Button4.Enabled:=False;
     Button2.Caption:='Batal';
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Button2.Caption = 'Hapus' then
  Begin
  with DataModule1 do
  begin
    if QueryBrg.Active then
      QueryBrg.Close;

    QueryBrg.SQL.Text := 'DELETE FROM barang WHERE id_barang = :id';
    QueryBrg.Params.ParamByName('id').AsString := Edit1.Text;
    QueryBrg.ExecSQL;
    SQLTransaction1.Commit;

    QueryBrg.Close;
    QueryBrg.SQL.Text := 'SELECT * FROM barang';
    QueryBrg.Open;
  end;

  end else if Button2.Caption = 'Batal' then
begin
   Button2.Caption := 'Hapus';
   EnabledEditor(False);
   Button1.Caption := 'Tambah';
   Button1.Enabled := True;
   Button4.Caption := 'Edit';
   Button4.Enabled := True;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    try
      Image1.Picture.LoadFromFile(OpenDialog1.FileName);
    except
      on E: Exception do
        ShowMessage('Error loading image: ' + E.Message);
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Button4.Caption = 'Simpan' then
  begin
  with DataModule1 do
  begin
    if QueryBrg.Active then
      QueryBrg.Close;

    // Set SQL untuk update data
    QueryBrg.SQL.Text := 'UPDATE barang SET nama_barang = :nama, stok_barang = :stok, tanggal_masuk = :tanggal, gambar_barang = :gambar WHERE id_barang = :id';

    QueryBrg.Params.ParamByName('id').AsString := Edit1.Text;
    QueryBrg.Params.ParamByName('nama').AsString := Edit2.Text;
    QueryBrg.Params.ParamByName('stok').AsInteger := StrToInt(Edit3.Text);
    QueryBrg.Params.ParamByName('tanggal').AsDateTime := DateTimePicker1.DateTime;

    if OpenDialog1.FileName <> '' then
    begin
      // Jika ada file yang dipilih, muat dari file
      QueryBrg.Params.ParamByName('gambar').LoadFromFile(OpenDialog1.FileName, ftBlob);
    end
    else
    begin
      // Jika tidak ada file, hapus data gambar dari field
      QueryBrg.Params.ParamByName('gambar').Clear;
    end;

    QueryBrg.ExecSQL;
    SQLTransaction1.Commit;

    // Menyegarkan data di grid
    QueryBrg.Close;
    QueryBrg.SQL.Text := 'SELECT * FROM barang';
    QueryBrg.Open;
    Button4.Caption:= 'Edit';
    EnabledEditor(false);
    Button1.Enabled:=True;
    Button2.Caption:='Hapus';
    end;
  end
    else if Button4.Caption = 'Edit' then
    begin
    EnabledEditor(true);
    Button4.Caption:='Simpan';
    Button1.Enabled:=False;
    Button2.Caption:='Batal';
    end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  QueryPrint.Active:=True;
  frReport1.LoadFromFile('laporan.lrf');
  frReport1.ShowReport;
  QueryPrint.Active:=False;
end;

procedure TForm1.DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin
  {if DataModule1.SQLQuery1.FieldByName('gambar_barang') is TBlobField then
 begin
   LoadImageFromBlobField(DataModule1.SQLQuery1.FieldByName('gambar_barang'), Image1);
 end;}
   if DataModule1.QueryBrg.IsEmpty then Exit;

  Edit1.Text := DataModule1.QueryBrg.FieldByName('id_barang').AsString;
  Edit2.Text := DataModule1.QueryBrg.FieldByName('nama_barang').AsString;
  Edit3.Text := DataModule1.QueryBrg.FieldByName('stok_barang').AsString;
  DateTimePicker1.DateTime := DataModule1.QueryBrg.FieldByName('tanggal_masuk').AsDateTime;

  // Menampilkan gambar jika ada
  LoadImageFromBlobField(DataModule1.QueryBrg.FieldByName('gambar_barang'), Image1);

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  with DataModule1 do
    begin
      SQLite3Connection1.Connected := True;
      QueryBrg.SQL.Text := 'SELECT * FROM barang';
      QueryBrg.Open;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  with DataModule1 do
  begin
    if QueryBrg.Active then
      QueryBrg.Close;
      QueryPrint.Close;
    if SQLite3Connection1.Connected then
    begin
      SQLTransaction1.Commit;
      SQLite3Connection1.Connected := False;
    end;
  end;
end;

procedure TForm1.frDesigner1LoadReport(Report: TfrReport; var ReportName: String
  );
begin

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

end.

