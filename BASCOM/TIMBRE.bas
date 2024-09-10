'Main.bas
'
'                 WATCHING Soluciones Tecnológicas
'                    Fernando Vásquez - 25.06.15
'
' Programa para almacenar los datos que se reciben por el puerto serial a una
' memoria SD
'


$regfile = "m328def.dat"                                    ' used micro
$crystal = 7372800                                          ' used xtal
$baud = 9600                                                ' baud rate we want
$hwstack = 80
$swstack = 80
$framesize = 80

$projecttime = 21
$version 0 , 0 , 14



'Declaracion de constantes



'Configuracion de entradas/salidas
Led1 Alias Portd.2                                          'LED ROJO
Config Led1 = Output

Smov Alias Pinb.5
Config Smov = Input
Set Portb.5

Rele Alias Portc.1
Config Rele = Output
Reset Rele

Buzzer Alias Portc.0
Config Buzzer = Output
Reset Buzzer

'Configuración de Interrupciones
'TIMER0
Config Timer0 = Timer , Prescale = 1024                     'Ints a 100Hz si Timer0=184
On Timer0 Int_timer0
Enable Timer0
Start Timer0

' Puerto serial 1
Open "com1:" For Binary As #1
On Urxc At_ser1
Enable Urxc


Enable Interrupts


'*******************************************************************************
'* Archivos incluidos
'*******************************************************************************
$include "TIMBRE_archivos.bas"



'Programa principal

Call Inivar()


Do

   If Sernew = 1 Then                                       'DATOS SERIAL 1
      Reset Sernew
      Print #1 , "SER1=" ; Serproc
      Call Procser()
   End If

   If Smov <> Smovant Then
      Waitms 20
      If Smov <> Smovant Then
         Print #1 , "Smov=" ; Smov
         Smovant = Smov
         If Smov = 1 Then
            Set Initimbrar
         End If
      End If
   End If

   If Initimbrar = 1 Then
      Reset Initimbrar
      Call Beep_error()
      Call Timbrar()

   End If

Loop