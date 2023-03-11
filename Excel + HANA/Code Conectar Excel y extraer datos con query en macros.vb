'
' HANA Connector (Get information from HANA Server)
'
'
' Created by Alejandro Agustin Franzoni Gimenez on Mar 2022.
' Contact me at contacto@alejandrofranzoni.com.ar
'
' Copyright © 2022. All rights reserved.
' www.alejandrofranzoni.com.ar
'
Option Explicit

Dim odbc_driver As String, connection_string As String
Dim cnn As ADODB.Connection, rs As ADODB.Recordset

Const HKEY_LOCAL_MACHINE As Long = &H80000002
Const REGISTRY_KEY_PATH As String = "SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers"
Const SERVERNODE As String = "hlp93:30015"

Public Sub getDataFromHANA()
    Dim query As String
    Dim i As Integer
    If checkHANAConnection <> True Then Exit Sub
    
    Set rs = New ADODB.Recordset
    query = "SELECT " & """ItemCode""" & ", " & """ItemName""" & " FROM OITM"  '& ", " & """ItemName"""
    Set rs = cnn.Execute(query)

    If rs.EOF <> True Then
        'Metodo 1
        ThisWorkbook.Sheets(1).Range("A2").CopyFromRecordset rs
        
        For i = 0 To rs.Fields.Count - 1
            ThisWorkbook.Sheets(1).Cells(1, i + 1).Value = rs.Fields(i).Name
        Next
               
        'Metodo 2
        'While rs.EOF <> True
         '   Debug.Print rs!CODE
          '  rs.MoveNext
        'Wend
        
        If rs.State = 1 Then rs.Close: Set rs = Nothing
        If cnn.State = 1 Then cnn.Close: Set cnn = Nothing
    End If
End Sub
Private Function checkHANAConnection() As Boolean
    If isODBCDriverInstalled <> True Then
        MsgBox "¡No se ha encontrado el driver ODBC necesario para realizar la conexión al servidor!", vbExclamation + vbOKOnly + vbApplicationModal, "ODBC Driver Missing"
        checkHANAConnection = False
        Exit Function
    End If
    
    DRIVER={B1CRHPROXY32};SERVERNODE=hlp93:30015;DATABASE=GC_ELIANA;UID=B1ADMIN;PWD=B1Admin1$;

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



