object SQLiteModule: TSQLiteModule
  Height = 119
  Width = 186
  object SQL: TFDConnection
    Params.Strings = (
      'Database=D:\GitClicker\AsistTranslaterYT\libast.dll'
      'DriverID=SQLite')
    Left = 16
    Top = 8
  end
  object SQLQuery: TFDQuery
    Connection = SQL
    Left = 72
    Top = 8
  end
end
