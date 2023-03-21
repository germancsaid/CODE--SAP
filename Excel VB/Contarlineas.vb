Sub contarLineas()
    Dim ws As Worksheet
    Dim ultimaFila As Long
    Dim filaActual As Long
    
    'Recorrer cada hoja del libro
    For Each ws In ThisWorkbook.Worksheets
        'Saltar cualquier hoja que esté en blanco
        If Application.CountA(ws.Cells) > 0 Then
            'Determinar la última fila con información en la hoja actual
            ultimaFila = ws.Cells.Find(What:="*", SearchDirection:=xlPrevious, SearchOrder:=xlByRows).Row
            'Escribir el número de filas en la celda actual de la hoja activa
            filaActual = ActiveCell.Row
            Cells(filaActual, 1).Value = ws.Name
            Cells(filaActual, 2).Value = ultimaFila
            'Moverse a la siguiente fila en la hoja activa
            ActiveCell.Offset(1, 0).Select
        End If
    Next ws
End Sub