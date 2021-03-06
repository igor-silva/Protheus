#Include 'Totvs.ch'

/*
Autor		:	Fabiano da Silva
Data		:	05/08/13
Descri��o	:	Pontos de Entrada do m�dulo Compras (SIGACOM)

MT100TOK()	:	Esse Ponto de Entrada � chamado 2 vezes dentro da rotina A103Tudok().
Para o controle do n�mero de vezes em que ele � chamado foi criada a vari�vel l�gica lMT100TOK,
que quando for definida como (.F.) o ponto de entrada ser� chamado somente uma vez.

*/

User Function MT100TOK()

_aAliOri  := GetArea()
_aAliSD1  := SD1->(GetArea())
_aAliSB1  := SB1->(GetArea())

_nPoProd  := aScan(aHeader,{ |x| Upper(Alltrim(x[2])) == "D1_COD" } )

lMT100TOK := .F.
_lRet      := .T.

If UPPER(FUNNAME()) == 'MATA103'
	
	For I:= 1 to Len(Acols)
		_cFim := (Len(aHeader)+1)
		
		_cProduto := ACols[I][_nPoProd]
		
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+_cProduto))
			If rTrim(SB1->B1_TIPO) <> 'SE'
				If Empty(SB1->B1_POSIPI)
					Alert("Produto "+Alltrim(SB1->B1_COD)+" est� sem o NCM no cadastro de Produtos!")
					_lRet := .F.
				Else
					SYD->(dbSetOrder(1))
					If !SYD->(dbSeek(xFilial("SYD")+SB1->B1_POSIPI))
						Alert("Produto "+Alltrim(SB1->B1_COD)+" est� com o NCM cadastrado erroneamente!")
						_lRet := .F.
					Endif
				Endif
			Endif
		Endif
	Next I
Endif

RestArea(_aAliSB1)
RestArea(_aAliSD1)
RestArea(_aAliOri)

Return(_lRet)
