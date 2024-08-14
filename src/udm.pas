unit udm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    DataSource1: TDataSource;
    SQLite3Connection1: TSQLite3Connection;
    QueryBrg: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DataSource1UpdateData(Sender: TObject);
  private

  public

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.lfm}

{ TDataModule1 }

procedure TDataModule1.DataSource1UpdateData(Sender: TObject);
begin

end;

end.

