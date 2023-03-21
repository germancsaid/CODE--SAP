'QUERYS DESDE HANA

Option Explicit

Dim odbc_driver As String, connection_string As String
Dim cnn As ADODB.Connection, rs As ADODB.Recordset

Const HKEY_LOCAL_MACHINE As Long = &H80000002
Const REGISTRY_KEY_PATH As String = "SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers"
Const SERVERNODE As String = "hlp93:30015"



Private Function checkHANAConnection() As Boolean
    If isODBCDriverInstalled <> True Then
        MsgBox "¡No se ha encontrado el driver ODBC necesario para realizar la conexión al servidor!", vbExclamation + vbOKOnly + vbApplicationModal, "ODBC Driver Missing"
        checkHANAConnection = False
        Exit Function
    End If
    
    connection_string = vbNullString
    connection_string = "DRIVER={B1CRHPROXY32};" '{ & odbc_driver & "};"
    connection_string = connection_string & "SERVERNODE=" & SERVERNODE & ";" & "DATABASE=GC_ELIANA" & ";"
    connection_string = connection_string & "UID=B1ADMIN;"
    connection_string = connection_string & "PWD=B1Admin1$;"
    MsgBox connection_string
    
    Set cnn = New ADODB.Connection
    On Error GoTo connection_error
    cnn.Open connection_string
    checkHANAConnection = True
    Exit Function
    
    connection_error:
    checkHANAConnection = False
    MsgBox "¡Ha ocurrido un error al intentar establecer la conexión con el servidor!" & vbNewLine & vbNewLine & Err.Description, vbApplicationModal + vbExclamation + vbOKOnly, "Database Connection Error"
End Function

Private Function isODBCDriverInstalled() As Boolean
    Dim registry As Object, i As Integer
    Dim arrValueNames() As Variant, arrValueTypes() As Variant
    
    Set registry = GetObject("winmgmts:\\.\root\default:StdRegProv")
    registry.EnumValues HKEY_LOCAL_MACHINE, REGISTRY_KEY_PATH, arrValueNames, arrValueTypes
    
    For i = 0 To UBound(arrValueNames)
        If UCase(arrValueNames(i)) Like "HDBODBC*" Then
            odbc_driver = arrValueNames(i)
            isODBCDriverInstalled = True
            Exit Function
        End If
    Next i
    
    isODBCDriverInstalled = False
End Function

Public Sub getDataFromHANA()
    Dim query As String
    Dim i As Integer
    If checkHANAConnection <> True Then Exit Sub
    
    Set rs = New ADODB.Recordset
    query = InputBox("Introduzca la consulta SQL a ejecutar")
    Set rs = cnn.Execute(query)

    If rs.EOF <> True Then
    'Obtener la hoja activa de Excel y agregar los datos de la consulta a la misma
    Dim Worksheet As Worksheet
    Set Worksheet = ActiveSheet
    Dim row As Integer
    Dim col As Integer
    row = 1
    col = 1
    For i = 0 To rs.Fields.Count - 1
        Worksheet.Cells(row, col) = rs.Fields(i).Name
        col = col + 1
    Next
    row = row + 1
    col = 1
    Do While Not rs.EOF
        For i = 0 To rs.Fields.Count - 1
            Worksheet.Cells(row, col) = rs.Fields(i).Value
            col = col + 1
        Next
        row = row + 1
        col = 1
        rs.MoveNext
    Loop
       
        If rs.State = 1 Then rs.Close: Set rs = Nothing
        If cnn.State = 1 Then cnn.Close: Set cnn = Nothing
    End If
End Sub



