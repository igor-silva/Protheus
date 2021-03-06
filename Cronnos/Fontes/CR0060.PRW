#INCLUDE 'TOTVS.CH'

/*
Programa	:	CR0060
Autor		:	Fabiano da Silva
Data		:	02/07/14
Descri��o	:	Validador dos campo Tipo / Grupo / SubGrupo no cadastro de Produtos
T = Tipo
G = Grupo
S = Subgrupo					
*/

User Function CR0060(_cOpt)

	Private _lRet := .T.

	If _cOpt = 'T'
		ValidTipo()
	ElseIf _cOpt = 'G'
		ValidGrupo()
	ElseIf _cOpt = 'S'
		ValidSubGrupo()
	Endif

Return(_lRet)


Static Function ValidTipo()

	M->B1_GRUPO = Space(4)
	M->B1_SUBGR = Space(6)

Return


Static Function ValidGrupo()

	If Empty(M->B1_TIPO)
		MsgAlert('Favor preencher o campo Tipo! ')
		M->B1_GRUPO := Space(4)
		//			_lRet := .F.
	Else
		SBM->(dbSetOrder(1))
		If SBM->(msSeek(xFilial("SBM")+M->B1_GRUPO))

			If SBM->BM_MSBLQL <> '1'
				If M->B1_TIPO $ ('AF|EM|MO|RR|SE')
					If M->B1_GRUPO <> '9999'
						MsgAlert('Para os produtos cujo o Tipo � igual � "AF","EM","MO" ou "SE", s� � aceito o Grupo "9999" ')
						M->B1_GRUPO := Space(4)
						_lRet := .F.
					Endif
				Else
					If M->B1_TIPO <> Left(M->B1_GRUPO,2)
						MsgAlert('Para os produtos cujo o Tipo � igua � '+M->B1_TIPO+' s� � aceito Grupos que se iniciam com '+M->B1_TIPO)
						M->B1_GRUPO := Space(4)
						_lRet := .F.
					Endif
				Endif
			Else
				MsgAlert('Grupo utilizado est� bloqueado para uso!')
				_lRet := .F.
			Endif
		Endif
	Endif
	M->B1_SUBGR := Space(6)

Return


Static Function ValidSubGrupo()

	If Empty(M->B1_TIPO)
		MsgAlert('Favor preencher o campo Tipo! ')
		M->B1_SUBGR := Space(6)
		//			_lRet := .F.	 
	ElseIf Empty(M->B1_GRUPO)
		MsgAlert('Favor preencher o campo Grupo! ')
		M->B1_SUBGR := Space(6)
		//			_lRet := .F.	 
	ElseIf M->B1_GRUPO $ ('9999|MCAD|MCIN|DPVC|DPAC|DPPF|DPCT|PACJ|PATF|PAVZ|PPCO|PPPF|PPIM|PPSA|PPVZ')
		If !M->B1_SUBGR $ '999999'
			MsgAlert('Para os produtos cujo o Grupo esteja contido nos itens abaixo, s� � aceito o SubGrupo "999999" '+CRLF+CRLF+;
			'"9999","MCAD","MCIN","DPVC","DPAC","DPPF","DPCT","PACJ","PATF","PAVZ","PPCO","PPPF","PPIM","PPSA","PPVZ"')
			M->B1_SUBGR := Space(6)
			_lRet := .F.
		Endif
	ElseIf M->B1_GRUPO <> Left(M->B1_SUBGR,4) .And. M->B1_GRUPO $ ('DPPA|PACP|PAMD')
		MsgAlert('Para os produtos cujo o Grupo � igual � '+M->B1_GRUPO+' s� � aceito SubGrupos que se iniciam com '+M->B1_GRUPO)
		M->B1_SUBGR := Space(6)
		_lRet := .F.
	ElseIf M->B1_GRUPO $ ('MPCP|MPIM|MPVC|MPVZ|MPOU')
		If !M->B1_SUBGR $ ('MPUDPP|MPUDVC|MPUDVZ|MPUDPA|999999')
			MsgAlert('Para os produtos cujo o Grupo esteja contido nos itens abaixo, s� � aceito um dos seguinte SubGrupos: "MPUDPP","MPUDVC","MPUDVZ","MPUDPA" ou "999999" '+CRLF+CRLF+;
			'"MPCP","MPIM","MPVC","MPVZ","MPOU"')
			M->B1_SUBGR := Space(6)
			_lRet := .F.
		Endif
	ElseIf Left(M->B1_GRUPO,2) = 'FR'
		If !M->B1_SUBGR $ ('FRCRNN|FRCLTE')
			MsgAlert('Para os produtos cujo o Grupo se iniciam com "FR", s� � aceito um dos seguinte SubGrupos: "FRCRNN" ou "FRCLTE" ')
			M->B1_SUBGR := Space(6)
			_lRet := .F.
		Endif
	Endif

Return
