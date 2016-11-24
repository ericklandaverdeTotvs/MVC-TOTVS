/*Portuges
Salve salve erick.
Eu nunca fiz, mas você poderia tentar da seguinte forma:
Español!
Salve salve erick.
Eu nunca fiz, mas você poderia tentar da seguinte forma:*/

....
cAliasAux := "XXX" //Seu Alias aqui
lInvert   := .F.
cMarca    := GetMark()
oMark:AddMarkColumns({|| If((cAliasAux)->OK == cMarca, "LBTIK", "LBNO")}, {|| fMarcar(cMarca, lInvert, ,cAliasAux, @oMark), oMark:Refresh()}, {|| fMarcar(cMarca, lInvert, .T., cAliasAux, @oMark), oMark:Refresh(.T.)}) //Coluna de marcacao
...

/*Portugues
No caso o método chama 3 blocos de código, um para saber se está checado, outro para marcar individualmente e outro para marcar todos.
Ai você pode criar uma função estática, por exemplo:
Español
Si el método llama a 3 bloques de código, uno para saber si está activada, el otro a la puntuación de forma individual y otro para marcar todos.
Oh, puede crear una función estática, por ejemplo:*/
...
Static Function fMarcar(cMarca, lInvert, lAll, cAliTRB, oMark)
...

/*Portugues
E nessa função estática, fazer os RecLocks que você precisa.
Espero ter ajudado.
Um grande abraço.﻿
Español
Y esta función estática, hacer las Regenera que necesita.
Espero haber ayudado.
Un gran abrazo.*/

//Função para marcar/desmarcar todos os registros do grid
Static Function MCFG6Invert(cMarca,lMarcar)
    Local cAliasSD1 := 'TRB'
    Local aAreaSD1  := (cAliasSD1)-&gt;( GetArea() )
 
    dbSelectArea(cAliasSD1)
    (cAliasSD1)-&gt;( dbGoTop() )
    While !(cAliasSD1)-&gt;( Eof() )
        RecLock( (cAliasSD1), .F. )
        (cAliasSD1)-&gt;TR_OK := IIf( lMarcar, cMarca, '  ' )
        MsUnlock()
        (cAliasSD1)-&gt;( dbSkip() )
    EndDo
 
    RestArea( aAreaSD1 )
Return .T.
