Sub agruparInformacion()
    Dim ws As Worksheet
    Dim ultimaFila As Long
    Dim ultimaColumna As Long
    Dim hojaDestino As Worksheet
    
    'Elegir la hoja destino para agrupar la información
    Set hojaDestino = ThisWorkbook.Sheets("OITT CAB")
    
    'Eliminar la información anterior en la hoja destino
    hojaDestino.Cells.ClearContents
    
    'Recorrer cada hoja del libro
    For Each ws In ThisWorkbook.Worksheets
        'Saltar la hoja destino y cualquier otra hoja que no tenga información
        If ws.Name <> hojaDestino.Name And Application.CountA(ws.Cells) > 0 Then
            'Determinar la última fila y última columna con información en la hoja actual
            ultimaFila = ws.Cells.Find(What:="*", SearchDirection:=xlPrevious, SearchOrder:=xlByRows).Row
            ultimaColumna = ws.Cells.Find(What:="*", SearchDirection:=xlPrevious, SearchOrder:=xlByColumns).Column
            
            'Copiar la información de la hoja actual a la hoja destino
            ws.Range(ws.Cells(1, 1), ws.Cells(ultimaFila, ultimaColumna)).Copy _
                Destination:=hojaDestino.Cells(hojaDestino.Rows.Count, 1).End(xlUp).Offset(1, 0)
        End If
    Next ws
    
    'Seleccionar la primera celda en la hoja destino
    hojaDestino.Activate
    hojaDestino.Range("A1").Select
End Sub


