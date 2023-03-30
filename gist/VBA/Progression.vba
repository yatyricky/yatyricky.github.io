
Function ArithmeticProgression(a As Range, b As Range)
    Dim r1 As Integer
    Dim c1 As Integer
    Dim r2 As Integer
    Dim c2 As Integer
    Dim mr As Integer
    Dim mc As Integer
    Dim dist As Integer
    Dim step As Double
    Dim diff As Double
    Dim walked As Integer
    
    r1 = a.Row
    c1 = a.Column
    
    r2 = b.Row
    c2 = b.Column
    
    mr = Application.Caller.Row
    mc = Application.Caller.Column
        
    dist = r2 + c2 - r1 - c1
    diff = b.Value - a.Value
    step = diff / dist
    
    walked = mr + mc - r1 - c1
        
    ArithmeticProgression = a.Value + walked * step
End Function

Function GeometricProgression(a As Range, b As Range) As Double
    Dim r1 As Integer
    Dim c1 As Integer
    Dim r2 As Integer
    Dim c2 As Integer
    Dim mr As Integer
    Dim mc As Integer
    Dim dist As Integer
    Dim step As Double
    Dim diff As Double
    Dim walked As Integer
    
    r1 = a.Row
    c1 = a.Column
    
    r2 = b.Row
    c2 = b.Column
    
    mr = Application.Caller.Row
    mc = Application.Caller.Column
        
    dist = r2 + c2 - r1 - c1
    diff = b.Value / a.Value
    step = WorksheetFunction.Power(diff, 1 / dist)
    
    walked = mr + mc - r1 - c1
        
    GeometricProgression = a.Value * WorksheetFunction.Power(step, walked)
End Function

Public Function ShellRun(sCmd As String) As String

    'Run a shell command, returning the output as a string

    Dim oShell As Object
    Set oShell = CreateObject("WScript.Shell")

    'run command
    Dim oExec As Object
    Dim oOutput As Object
    Set oExec = oShell.Exec(sCmd)
    Set oOutput = oExec.StdOut

    'handle the results as they are written to and read from the StdOut object
    Dim s As String
    Dim sLine As String
    While Not oOutput.AtEndOfStream
        sLine = oOutput.ReadLine
        If sLine <> "" Then s = s & sLine & vbCrLf
    Wend

    ShellRun = s

End Function
