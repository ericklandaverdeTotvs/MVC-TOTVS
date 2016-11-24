#INCLUDE "rwmake.ch"

User Function PADAWANES

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracion de Variables                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validación para permitir la modificación. Se puede utilizar ExecBlock.
Local cVldExc := ".T." // Validación para permitir el borrado. Se puede utilizar ExecBlock.

Private cString := "ZZ5"

dbSelectArea("ZZ5")
dbSetOrder(1)

AxCadastro(cString,"PADAWANES",cVldExc,cVldAlt)

Return